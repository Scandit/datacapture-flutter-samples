/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureId.initialize();
  runApp(MyApp());
}

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
            color: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white)),
      ),
      home: IdCaptureScreen(),
    );
  }
}

class IdCaptureScreen extends StatefulWidget {
  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _IdCaptureScreenState(DataCaptureContext.forLicenseKey(licenseKey));
}

class _IdCaptureScreenState extends State<IdCaptureScreen>
    with WidgetsBindingObserver
    implements IdCaptureAdvancedAsyncListener {
  final DataCaptureContext _context;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;
  late IdCapture _idCapture;
  late DataCaptureView _captureView;

  bool _isPermissionMessageVisible = false;

  _IdCaptureScreenState(this._context);

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
    WidgetsBinding.instance.addObserver(this);

    // Use the recommended camera settings for the IdCapture mode.
    _camera?.applySettings(IdCapture.recommendedCameraSettings);

    // Switch camera on to start streaming frames and enable the id capture mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The Id capturing process is configured through id capture settings
    // and are then applied to the id capture instance that manages id recognition.
    var settings = IdCaptureSettings();

    // Recognize national ID cards & driver's licenses.
    settings.supportedDocuments.addAll([
      IdDocumentType.dlViz,
      IdDocumentType.idCardViz,
    ]);

    // Create new Id capture mode with the settings from above.
    _idCapture = IdCapture.forContext(_context, settings)
      // Register self as a listener to get informed whenever a new id got recognized.
      ..addAdvancedAsyncListener(this);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a Id capture overlay to the data capture view to render the location of captured ids on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    var overlay = IdCaptureOverlay.withIdCaptureForView(_idCapture, _captureView);
    overlay.idLayoutStyle = IdLayoutStyle.rounded;

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _idCapture.isEnabled = true;
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
        child: Center(child: child),
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _idCapture.removeAdvancedAsyncListener(this);
    _idCapture.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  @override
  Future<void> didCaptureId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    CapturedId? capturedId = session.newlyCapturedId;
    if (capturedId == null) {
      return;
    }
    // Don't capture unnecessarily when the alert is displayed.
    idCapture.isEnabled = false;

    String result = _getResultFromCapturedId(capturedId);

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  result,
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
  Future<void> didLocalizeId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    // In this sample we are not interested in this callback.
  }

  @override
  Future<void> didTimedOut(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    // In this sample we are not interested in this callback.
  }

  @override
  Future<void> didRejectId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
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
                'Document not supported',
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

  String _getResultFromCapturedId(CapturedId capturedId) {
    String result = _getDescriptionForCapturedId(capturedId);
    if (capturedId.viz != null) {
      result += _getDescriptionForVizResult(capturedId);
    }
    return result;
  }

  String _getDescriptionForVizResult(CapturedId result) {
    return """
    Additional Name Information: ${result.viz?.additionalNameInformation ?? "empty"}
    Additional Address Information: ${result.viz?.additionalAddressInformation ?? "empty"}
    Place of Birth: ${result.viz?.placeOfBirth ?? "empty"}
    Race: ${result.viz?.race ?? "empty"}
    Religion: ${result.viz?.religion ?? "empty"}
    Profession: ${result.viz?.profession ?? "empty"}
    Marital Status: ${result.viz?.maritalStatus ?? "empty"}
    Residential Status: ${result.viz?.residentialStatus ?? "empty"}
    Employer: ${result.viz?.employer ?? "empty"}
    Personal Id Number: ${result.viz?.personalIdNumber ?? "empty"}
    Document Additional Number: ${result.viz?.documentAdditionalNumber ?? "empty"}
    Issuing Jurisdiction: ${result.viz?.issuingJurisdiction ?? "empty"}
    Issuing Authority: ${result.viz?.issuingAuthority ?? "empty"}
    Blood Type: ${result.viz?.bloodType ?? "empty"}
    Sponsor: ${result.viz?.sponsor ?? "empty"}
    Mother's Name: ${result.viz?.mothersName ?? "empty"}
    Father's Name: ${result.viz?.fathersName ?? "empty"}
    \n""";
  }

  String _getDescriptionForCapturedId(CapturedId result) {
    return """Name: ${result.firstName ?? "empty"}
    Last Name: ${result.lastName ?? "empty"}
    Full Name: ${result.fullName}
    Sex: ${result.sex ?? "empty"}
    Date of Birth: ${result.dateOfBirth?.date.humanReadable ?? "empty"}
    Nationality: ${result.nationality ?? "empty"}
    Address: ${result.address ?? "empty"}
    Document Type: ${result.documentType}
    Captured Result Type: ${result.capturedResultType}
    Issuing Country: ${result.issuingCountry ?? "empty"}
    Issuing Country ISO: ${result.issuingCountryIso ?? "empty"}
    Document Number: ${result.documentNumber ?? "empty"}
    Date of Expiry: ${result.dateOfExpiry?.date.humanReadable ?? "empty"}
    Date of Issue: ${result.dateOfIssue?.date.humanReadable ?? "empty"}
    \n""";
  }
}

extension DateTimeExtension on DateTime {
  String get humanReadable {
    return DateFormat.yMMMd().format(this);
  }
}
