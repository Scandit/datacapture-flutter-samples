/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
    return PlatformApp(
      cupertino: (_, __) => CupertinoAppData(theme: CupertinoThemeData(brightness: Brightness.light)),
      home: IdCaptureScreen(),
    );
  }
}

class IdCaptureScreen extends StatefulWidget {
  // Create data capture context using your license key.
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
    WidgetsBinding.instance?.addObserver(this);

    // Use the recommended camera settings for the IdCapture mode.
    _camera?.applySettings(IdCapture.recommendedCameraSettings);

    // Switch camera on to start streaming frames and enable the id capture mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The Id capturing process is configured through id capture settings
    // and are then applied to the id capture instance that manages id recognition.
    var settings = IdCaptureSettings();

    // We are interested in the front side of national Id Cards and passports using MRZ.
    settings.supportedDocuments.addAll([IdDocumentType.idCardViz, IdDocumentType.aamvaBarcode, IdDocumentType.dlViz]);

    // Create new Id capture mode with the settings from above.
    _idCapture = IdCapture.forContext(_context, settings)
      // Register self as a listener to get informed whenever a new id got recognized.
      ..addListener(this);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a Id capture overlay to the data capture view to render the location of captured ids on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    var overlay = IdCaptureOverlay.withIdCaptureForView(_idCapture, _captureView);
    overlay.idLayoutStyle = IdLayoutStyle.square;

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
      child = PlatformText('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      child = _captureView;
    }
    return Center(child: child);
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
    WidgetsBinding.instance?.removeObserver(this);
    _idCapture.removeListener(this);
    _idCapture.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  @override
  void didCaptureId(IdCapture idCapture, IdCaptureSession session) async {
    CapturedId? capturedId = session.newlyCapturedId;
    if (capturedId == null) {
      return;
    }
    // Don't capture unnecessarily when the alert is displayed.
    _idCapture.isEnabled = false;

    String result = _getResultFromCapturedId(capturedId);

    await showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: PlatformText(
                  result,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              actions: [
                PlatformDialogAction(
                    child: PlatformText('OK'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ));

    // Enable capture again, after the dialog is dismissed.
    _idCapture.isEnabled = true;
  }

  @override
  void didFailWithError(IdCapture idCapture, IdCaptureError error, IdCaptureSession session) {
    showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              content: PlatformText(
                error.message,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              actions: [
                PlatformDialogAction(
                    child: PlatformText('OK'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ));
  }

  @override
  void didLocalizeId(IdCapture idCapture, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didRejectId(IdCapture idCapture, IdCaptureSession session) async {
    // Implement to handle documents recognized in a frame, but rejected.
    // A document or its part is considered rejected when (a) it's valid, but not enabled in the settings,
    // (b) it's a barcode of a correct symbology or a Machine Readable Zone (MRZ),
    // but the data is encoded in an unexpected/incorrect format.

    // Don't capture unnecessarily when the dialog is displayed.
    _idCapture.isEnabled = false;

    await showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              content: PlatformText(
                'Document not supported',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              actions: [
                PlatformDialogAction(
                    child: PlatformText('OK'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ));

    // Enable capture again, after the dialog is dismissed.
    _idCapture.isEnabled = true;
  }

  String _getResultFromCapturedId(CapturedId capturedId) {
    String result = _getDescriptionForCapturedId(capturedId);
    if (capturedId.mrz != null) {
      result += _getDescriptionForMrzResult(capturedId);
    } else if (capturedId.viz != null) {
      result += _getDescriptionForVizResult(capturedId);
    } else if (capturedId.aamvaBarcode != null) {
      result += _getDescriptionForUsDriverLicenseBarcodeResult(capturedId);
    } else if (capturedId.usUniformedServicesBarcode != null) {
      result += _getDescriptionForUsUniformedServicesBarcodeResult(capturedId);
    }
    return result;
  }

  String _getDescriptionForMrzResult(CapturedId result) {
    return """
    Document Code: ${result.mrz?.documentCode}
    Names Are Truncated: ${result.mrz?.namesAreTruncated == true ? "Yes" : "No"}
    Optional: ${result.mrz?.optional ?? "empty"}
    Optional 1: ${result.mrz?.optional1 ?? "empty"}
    \n""";
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
    \n""";
  }

  String _getDescriptionForUsDriverLicenseBarcodeResult(CapturedId result) {
    return """
     AAMVA Version: ${result.aamvaBarcode?.aamvaVersion}
     Jurisdiction Version: ${result.aamvaBarcode?.jurisdictionVersion}
     IIN: ${result.aamvaBarcode?.iIN}
     Issuing Jurisdiction: ${result.aamvaBarcode?.issuingJurisdiction}
     Issuing Jurisdiction ISO: ${result.aamvaBarcode?.issuingJurisdictionIso}
     Eye Color: ${result.aamvaBarcode?.eyeColor ?? "empty"}
     Hair Color: ${result.aamvaBarcode?.hairColor ?? "empty"}
     Height Inch: ${result.aamvaBarcode?.heightInch ?? 0}
     Height Cm: ${result.aamvaBarcode?.heightCm ?? 0}
     Weight Lb: ${result.aamvaBarcode?.weightLbs ?? 0}
     Weight Kg: ${result.aamvaBarcode?.weightKg ?? 0}
     Place of Birth: ${result.aamvaBarcode?.placeOfBirth ?? "empty"}
     Race: ${result.aamvaBarcode?.race ?? "empty"}
     Document Discriminator Number: ${result.aamvaBarcode?.documentDiscriminatorNumber ?? "empty"}
     Vehicle Class: ${result.aamvaBarcode?.vehicleClass ?? "empty"}
     Restrictions Code: ${result.aamvaBarcode?.restrictionsCode ?? "empty"}
     Endorsements Code: ${result.aamvaBarcode?.endorsementsCode ?? "empty"}
     Card Revision Date: ${result.aamvaBarcode?.cardRevisionDate?.date.humanReadable ?? "empty"}
     Middle Name: ${result.aamvaBarcode?.middleName ?? "empty"}
     Driver Name Suffix: ${result.aamvaBarcode?.driverNameSuffix ?? "empty"}
     Driver Name Prefix: ${result.aamvaBarcode?.driverNamePrefix ?? "empty"}
     Last Name Truncation: ${result.aamvaBarcode?.lastNameTruncation ?? "empty"}
     First Name Truncation: ${result.aamvaBarcode?.firstNameTruncation ?? "empty"}
     Middle Name Truncation: ${result.aamvaBarcode?.middleNameTruncation ?? "empty"}
     Alias Family Name: ${result.aamvaBarcode?.aliasFamilyName ?? "empty"}
     Alias Given Name: ${result.aamvaBarcode?.aliasGivenName ?? "empty"}
     Alias Suffix Name: ${result.aamvaBarcode?.aliasSuffixName ?? "empty"}
     \n""";
  }

  String _getDescriptionForUsUniformedServicesBarcodeResult(CapturedId result) {
    return """
     Version: ${result.usUniformedServicesBarcode?.version}
     Sponsor Flag: ${result.usUniformedServicesBarcode?.sponsorFlag}
     Person Designator Document: ${result.usUniformedServicesBarcode?.personDesignatorDocument}
     Family Sequence Number: ${result.usUniformedServicesBarcode?.familySequenceNumber}
     Deers Dependent Suffix Code: ${result.usUniformedServicesBarcode?.deersDependentSuffixCode}
     Deers Dependent Suffix Description: ${result.usUniformedServicesBarcode?.deersDependentSuffixDescription}
     Height: ${result.usUniformedServicesBarcode?.height}
     Weight: ${result.usUniformedServicesBarcode?.weight}
     Hair Color: ${result.usUniformedServicesBarcode?.hairColor}
     Eye Color: ${result.usUniformedServicesBarcode?.eyeColor}
     Direct Care Flag Code: ${result.usUniformedServicesBarcode?.directCareFlagCode}
     Direct Care Flag Description: ${result.usUniformedServicesBarcode?.directCareFlagDescription}
     Civilian Health Care Flag Code: ${result.usUniformedServicesBarcode?.civilianHealthCareFlagCode}
     Civilian Health Care Flag Description: ${result.usUniformedServicesBarcode?.civilianHealthCareFlagDescription}
     Commissary Flag Code: ${result.usUniformedServicesBarcode?.commissaryFlagCode}
     Commissary Flag Description: ${result.usUniformedServicesBarcode?.commissaryFlagDescription}
     MWR Flag Code: ${result.usUniformedServicesBarcode?.mwrFlagCode}
     MWR Flag Description: ${result.usUniformedServicesBarcode?.mwrFlagDescription}
     Exchange Flag Code: ${result.usUniformedServicesBarcode?.exchangeFlagCode}
     Exchange Flag Description: ${result.usUniformedServicesBarcode?.exchangeFlagDescription}
     Champus Effective Date: ${result.usUniformedServicesBarcode?.champusEffectiveDate?.date.humanReadable ?? "empty"}
     Champus Expiry Date: ${result.usUniformedServicesBarcode?.champusExpiryDate?.date.humanReadable ?? "empty"}
     Form Number: ${result.usUniformedServicesBarcode?.formNumber}
     Security Code: ${result.usUniformedServicesBarcode?.securityCode}
     Service Code: ${result.usUniformedServicesBarcode?.serviceCode}
     Status Code: ${result.usUniformedServicesBarcode?.statusCode}
     Status Code Description: ${result.usUniformedServicesBarcode?.statusCodeDescription}
     Branch Of Service: ${result.usUniformedServicesBarcode?.branchOfService}
     Rank: ${result.usUniformedServicesBarcode?.rank}
     Pay Grade: ${result.usUniformedServicesBarcode?.payGrade}
     Sponsor Name: ${result.usUniformedServicesBarcode?.sponsorName ?? "empty"}
     Sponsor Person Designator Identifier: ${result.usUniformedServicesBarcode?.sponsorPersonDesignatorIdentifier ?? 0}
     Relationship Code: ${result.usUniformedServicesBarcode?.relationshipCode ?? "empty"}
     Relationship Description: ${result.usUniformedServicesBarcode?.relationshipDescription ?? "empty"}
     Geneva Convention Category: ${result.usUniformedServicesBarcode?.genevaConventionCategory ?? "empty"}
     Blood Type: ${result.usUniformedServicesBarcode?.bloodType ?? "empty"}
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