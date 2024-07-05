/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(MyApp());
}

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: BarcodeSelectionScreen(),
    );
  }
}

class BarcodeSelectionScreen extends StatefulWidget {
  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _BarcodeSelectionScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _BarcodeSelectionScreenState extends State<BarcodeSelectionScreen>
    with WidgetsBindingObserver
    implements BarcodeSelectionListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late BarcodeSelection _barcodeSelection;
  late DataCaptureView _captureView;
  late BarcodeSelectionSettings _selectionSettings;
  int _currentIndex = 0;

  bool _isPermissionMessageVisible = false;

  _BarcodeSelectionScreenState(this._context);

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

    // Use the recommended camera settings for the BarcodeSelection mode.
    _camera?.applySettings(BarcodeSelection.recommendedCameraSettings);

    // Switch camera on to start streaming frames and enable the barcode selection mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The barcode selection process is configured through barcode selection settings
    // which are then applied to the barcode selection instance that manages barcode recognition.
    _selectionSettings = BarcodeSelectionSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    _selectionSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.qr,
      Symbology.dataMatrix,
      Symbology.code39,
      Symbology.code128,
    });

    // Create new barcode selection mode with the settings created above.
    _barcodeSelection = BarcodeSelection.forContext(_context, _selectionSettings);

    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a barcode selection overlay to the data capture view to render the location of captured barcodes on top of the video preview.
    // This is optional, but recommended for better visual feedback.
    var overlay = BarcodeSelectionBasicOverlay.withBarcodeSelectionForView(_barcodeSelection, _captureView);

    _captureView.addOverlay(overlay);

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeSelection.isEnabled = true;
    // Register self as a listener to get informed whenever a new barcode got recognized.
    _barcodeSelection.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = Text('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      child = _captureView;
    }
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.qr_code),
                  label: 'Tap to Select',
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.qr_code),
                  label: 'Aim to Select',
                )
              ],
              onTap: (int index) {
                setState(() {
                  // Update selection type and apply new settings
                  if (index == 0) {
                    _selectionSettings.selectionType = BarcodeSelectionTapSelection();
                  } else {
                    _selectionSettings.selectionType = BarcodeSelectionAimerSelection();
                  }
                  _barcodeSelection.applySettings(_selectionSettings);
                  _currentIndex = index;
                });
              },
              selectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
              unselectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
              backgroundColor: Colors.black,
              unselectedItemColor: Colors.white,
            ),
          ),
        ),
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

  @override
  void didUpdateSelection(BarcodeSelection barcodeSelection, BarcodeSelectionSession session) {
    // Check if we have selected a barcode, if that's the case, show a snackbar with its info.
    var newlySelectedBarcodes = session.newlySelectedBarcodes;
    if (newlySelectedBarcodes.isEmpty) return;

    // Get the human readable name of the symbology and assemble the result to be shown.
    var barcode = newlySelectedBarcodes.first;
    var symbologyReadableName = SymbologyDescription.forSymbology(barcode.symbology).readableName;

    session.getCount(barcode).then((value) {
      final result = '${symbologyReadableName}: ${barcode.data} \nTimes: ${value}';

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
        duration: Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  @override
  void didUpdateSession(BarcodeSelection barcodeCapture, BarcodeSelectionSession session) {}

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _barcodeSelection.removeListener(this);
    _barcodeSelection.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  T? _ambiguate<T>(T? value) => value;
}
