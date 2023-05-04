/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanSimpleSample/main.dart';
import 'package:MatrixScanSimpleSample/scan_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MatrixScanScreen extends StatefulWidget {
  final String title;
  final String licenseKey;

  MatrixScanScreen(this.title, this.licenseKey, {Key? key}) : super(key: key);

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _MatrixScanScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _MatrixScanScreenState extends State<MatrixScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;

  List<ScanResult> scanResults = [];

  _MatrixScanScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera?.switchToDesiredState(FrameSourceState.on);
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    // Use the recommended camera settings for the BarcodeTracking mode.
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;
    // Adjust camera settings - set Full HD resolution.
    cameraSettings.preferredResolution = VideoResolution.fullHd;

    _camera?.applySettings(cameraSettings);

    // Switch camera on to start streaming frames and enable the barcode tracking mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The barcode tracking process is configured through barcode tracking settings
    // which are then applied to the barcode tracking instance that manages barcode tracking.
    var captureSettings = BarcodeTrackingSettings();

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

    // Add a barcode tracking overlay to the data capture view to render the tracked barcodes on
    // top of the video preview. This is optional, but recommended for better visual feedback.
    _captureView.addOverlay(BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
        _barcodeTracking, _captureView, BarcodeTrackingBasicOverlayStyle.frame));

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      var bottomPadding = 48 + MediaQuery.of(context).padding.bottom;
      var containerPadding = defaultTargetPlatform == TargetPlatform.iOS
          ? EdgeInsets.fromLTRB(48, 48, 48, bottomPadding)
          : EdgeInsets.all(48);
      child = Stack(children: [
        _captureView,
        Container(
          alignment: Alignment.bottomCenter,
          padding: containerPadding,
          child: SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                  onPressed: () => _showScanResults(context),
                  cupertino: (_, __) => CupertinoElevatedButtonData(
                      color: Color(scanditBlue), borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  child: PlatformText(
                    'Done',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))),
        )
      ]);
    }
    return WillPopScope(
        child: PlatformScaffold(appBar: PlatformAppBar(title: Text(widget.title)), body: child),
        onWillPop: () {
          dispose();
          return Future.value(true);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _camera?.switchToDesiredState(FrameSourceState.off);
    }
  }

  // This function is called whenever objects are updated and it's the right place to react to
  // the tracking results.
  @override
  void didUpdateSession(BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    for (final trackedBarcode in session.addedTrackedBarcodes) {
      scanResults.add(ScanResult(trackedBarcode.barcode.symbology, trackedBarcode.barcode.data ?? ''));
    }
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _barcodeTracking.removeListener(this);
    _barcodeTracking.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  void _showScanResults(BuildContext context) {
    _barcodeTracking.isEnabled = false;
    Navigator.pushNamed(context, "/scanResults", arguments: scanResults).then((value) => _resetScanResults());
  }

  void _resetScanResults() {
    scanResults.clear();
    _barcodeTracking.isEnabled = true;
  }

  T? _ambiguate<T>(T? value) => value;
}
