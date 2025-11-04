/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureId.initialize();
  runApp(MyApp());
}

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IdCaptureSimpleSample',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white)),
      ),
      home: IdCaptureScreen(),
    );
  }
}

class IdCaptureScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IdCaptureScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _IdCaptureScreenState extends State<IdCaptureScreen> with WidgetsBindingObserver implements IdCaptureListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late IdCapture _idCapture;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;

  _IdCaptureScreenState(this._context);

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;

      final isGranted = status.isGranted;
      setState(() {
        _isPermissionMessageVisible = !isGranted;
      });

      if (isGranted && _camera != null) {
        _camera!.switchToDesiredState(FrameSourceState.on);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Use the recommended camera settings for the IdCapture mode.
    _camera?.applySettings(IdCapture.createRecommendedCameraSettings());

    // Switch camera on to start streaming frames and enable the id capture mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The Id capturing process is configured through id capture settings
    // and are then applied to the id capture instance that manages id recognition.
    var settings = IdCaptureSettings();

    // Recognize national ID cards, driver's licenses and passports.
    settings.acceptedDocuments.addAll([
      new IdCard(IdCaptureRegion.any),
      new DriverLicense(IdCaptureRegion.any),
      new Passport(IdCaptureRegion.any),
    ]);
    settings.scanner = IdCaptureScanner(physicalDocumentScanner: FullDocumentScanner());

    // Create new Id capture mode with the settings from above.
    _idCapture = IdCapture(settings)
      // Register self as a listener to get informed whenever a new id got recognized.
      ..addListener(this);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a Id capture overlay to the data capture view to render the location of captured ids on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    var overlay = IdCaptureOverlay(_idCapture)..idLayoutStyle = IdLayoutStyle.rounded;

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _idCapture.isEnabled = true;

    // Set the id capture mode as the current mode of the data capture context.
    _context.setMode(_idCapture);

    // Add the overlay to the data capture view.
    _captureView.addOverlay(overlay);
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        // Cleanup everything on back press because this is the only screen
        _cleanup();

        // Exit the app since this is the only screen
        SystemNavigator.pop();
      },
      child: child,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission();
        break;
      default:
        if (_camera != null) {
          _camera!.switchToDesiredState(FrameSourceState.off);
        }
        break;
    }
  }

  void _cleanup() {
    WidgetsBinding.instance.removeObserver(this);
    _idCapture.removeListener(this);
    _idCapture.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
  }

  @override
  Future<void> didCaptureId(IdCapture idCapture, CapturedId capturedId) async {
    // Don't capture unnecessarily when the alert is displayed.
    idCapture.isEnabled = false;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  _getDescriptionForCapturedId(capturedId),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              actions: [
                GestureDetector(
                    child: Text('OK'),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            )).then((value) => {
          // Enable capture again, after the dialog is dismissed.
          idCapture.isEnabled = true
        });
  }

  @override
  Future<void> didRejectId(IdCapture idCapture, CapturedId? rejectedId, RejectionReason reason) async {
    // Implement to handle documents recognized in a frame, but rejected.
    // A document or its part is considered rejected when (a) it's valid, but not enabled in the settings,
    // (b) it's a barcode of a correct symbology or a Machine Readable Zone (MRZ),
    // but the data is encoded in an unexpected/incorrect format.

    // Don't capture unnecessarily when the dialog is displayed.
    idCapture.isEnabled = false;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(
                _getRejectionReasonMessage(reason),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              actions: [
                GestureDetector(
                    child: Text('OK'),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            )).then((value) => {
          // Enable capture again, after the dialog is dismissed.
          idCapture.isEnabled = true
        });
  }

  String _getRejectionReasonMessage(RejectionReason reason) {
    switch (reason) {
      case RejectionReason.notAcceptedDocumentType:
        return 'Document not supported. Try scanning another document.';
      case RejectionReason.timeout:
        return 'Document capture failed. Make sure the document is well lit and free of glare. Alternatively, try scanning another document';
      default:
        return 'Document capture was rejected. Reason=${reason}.';
    }
  }

  String _getDescriptionForCapturedId(CapturedId capturedId) {
    return """
    Full Name: ${capturedId.fullName}
    Date of Birth: ${capturedId.dateOfBirth?.utcDate.humanReadable}
    Date of Expiry: ${capturedId.dateOfExpiry?.utcDate.humanReadable}
    Document Number: ${capturedId.documentNumber}
    Nationality: ${capturedId.nationality}
    """;
  }
}

extension DateTimeExtension on DateTime {
  String get humanReadable {
    return DateFormat.yMMMd().format(this);
  }
}
