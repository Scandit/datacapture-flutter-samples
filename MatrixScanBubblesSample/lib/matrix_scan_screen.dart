/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanBubblesSample/freeze_button.dart';
import 'package:MatrixScanBubblesSample/product_bubble.dart';
import 'package:MatrixScanBubblesSample/quadrilateral_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'bubble_view_state.dart';

class MatrixScanScreen extends StatefulWidget {
  final String licenseKey;

  MatrixScanScreen(this.licenseKey, {Key key}) : super(key: key);

  // Create data capture context using your license key.
  @override
  _MatrixScanScreenState createState() => _MatrixScanScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _MatrixScanScreenState extends State<MatrixScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener, BarcodeTrackingAdvancedOverlayListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera _camera = Camera.defaultCamera;
  BarcodeTracking _barcodeTracking;
  DataCaptureView _captureView;
  BarcodeTrackingAdvancedOverlay _advancedOverlay;

  Map<int, ProductBubble> _trackedBarcodes = {};

  bool _isPermissionMessageVisible = false;

  bool _isFrozen = false;

  _MatrixScanScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera.switchToDesiredState(_isFrozen ? FrameSourceState.off : FrameSourceState.on);
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Use the recommended camera settings for the BarcodeTracking mode.
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;
    // Adjust camera settings - set Ultra HD resolution.
    cameraSettings.preferredResolution = VideoResolution.uhd4k;

    _camera.applySettings(cameraSettings);

    // Switch camera on to start streaming frames and enable the barcode tracking mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The barcode tracking process is configured through barcode tracking settings
    // which are then applied to the barcode tracking instance that manages barcode tracking.
    var captureSettings = BarcodeTrackingSettings.forScenario(BarcodeTrackingScenario.a);

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.code39,
      Symbology.code128,
    });

    // Create new barcode tracking mode with the settings from above.
    _barcodeTracking = BarcodeTracking.forContext(_context, captureSettings)
      // Register self as a listener to get informed of tracked barcodes.
      ..addListener(this);

    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a barcode tracking overlay to the data capture view to render the tracked barcodes on top of the video
    // preview. This is optional, but recommended for better visual feedback.
    var _basicOverlay = BarcodeTrackingBasicOverlay.withBarcodeTrackingForView(_barcodeTracking, _captureView)
      ..brush = Brush(Color(0x00FFFFFF), Color(0xFFFFFFFF), 2);
    _captureView.addOverlay(_basicOverlay);

    // Add an advanced barcode tracking overlay to the data capture view to render AR visualization on
    // top of the camera preview.
    _advancedOverlay = BarcodeTrackingAdvancedOverlay.withBarcodeTrackingForView(_barcodeTracking, _captureView)
      ..listener = this;
    _captureView.addOverlay(_advancedOverlay);

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    _context.setFrameSource(_camera);
    _camera.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      child = Stack(children: [
        _captureView,
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(48.0),
          child: SizedBox(height: 120, width: 120, child: FreezeButton(onPressed: (isFrozen) => _freeze(isFrozen))),
        )
      ]);
    }
    return PlatformScaffold(body: child);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      if (!_isFrozen) _camera.switchToDesiredState(FrameSourceState.off);
    }
  }

  // This function is called whenever objects are updated and it's the right place to react to
  // the tracking results.
  @override
  void didUpdateSession(BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    // Remove information about tracked barcodes that are no longer tracked.
    for (final removedBarcodeId in session.removedTrackedBarcodes) {
      _trackedBarcodes[removedBarcodeId] = null;
    }

    // Update AR views
    for (final trackedBarcode in session.trackedBarcodes.values) {
      _captureView
          .viewQuadrilateralForFrameQuadrilateral(trackedBarcode.location)
          .then((location) => _updateView(trackedBarcode, location));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _barcodeTracking.removeListener(this);
    _barcodeTracking.isEnabled = false;
    _camera.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  @override
  Anchor anchorForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode) {
    // The offset of our overlay will be calculated from the top-center anchoring point.
    return Anchor.topCenter;
  }

  @override
  void didTapViewForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode) {
    // Transfer the didTap event to the corresponding bubble widget.
    var productBubble = _trackedBarcodes[trackedBarcode.identifier];
    if (productBubble != null) {
      productBubble.onTap();
    }
    // Because the Matrix Scan augmentations (bubbles) are actually drawn on the native layer and not by the Flutter
    // engine, it is not enough to modify the augmentation UI in the productBubble.onTap() call. We also need to reset
    // the widget on the native layer by calling the BarcodeTrackingAdvancedOverlay.setWidgetForTrackedBarcode(...)
    // method.
    _advancedOverlay.setWidgetForTrackedBarcode(productBubble, trackedBarcode);
  }

  @override
  PointWithUnit offsetForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode) {
    // We set the offset's height to be equal of the 100 percent of our overlay.
    // The minus sign means that the overlay will be above the barcode.
    return PointWithUnit(DoubleWithUnit(0, MeasureUnit.fraction), DoubleWithUnit(-1, MeasureUnit.fraction));
  }

  @override
  Widget widgetForTrackedBarcode(BarcodeTrackingAdvancedOverlay overlay, TrackedBarcode trackedBarcode) {
    return null;
  }

  _updateView(TrackedBarcode trackedBarcode, Quadrilateral viewLocation) {
    // If the barcode is wider than the desired percent of the data capture view's width, show it to the user.
    var shouldBeShown = viewLocation.width() > MediaQuery.of(context).size.width * 0.1;
    if (!shouldBeShown) {
      if (_trackedBarcodes.containsKey(trackedBarcode.identifier) &&
          _trackedBarcodes[trackedBarcode.identifier] == null) {
        return;
      }
      _trackedBarcodes[trackedBarcode.identifier] = null;
      _advancedOverlay.setWidgetForTrackedBarcode(null, trackedBarcode);
      return;
    }

    if (_trackedBarcodes[trackedBarcode.identifier] == null) {
      var bubble = ProductBubble(trackedBarcode.barcode.data, BubbleViewState(BubbleType.StockInfo));
      _trackedBarcodes[trackedBarcode.identifier] = bubble;
      _advancedOverlay.setWidgetForTrackedBarcode(bubble, trackedBarcode);
    }
  }

  _freeze(bool isFrozen) {
    // Toggle barcode tracking to stop or start processing frames.
    _barcodeTracking.isEnabled = !isFrozen;
    // Switch the camera on or off to toggle streaming frames. The camera is stopped asynchronously.
    _camera.switchToDesiredState(isFrozen ? FrameSourceState.off : FrameSourceState.on);

    _isFrozen = isFrozen;
  }
}
