/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:USDLVerificationSample/bloc/bloc_base.dart';
import 'package:intl/intl.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class USDLVerificationBloc extends Bloc implements IdCaptureListener {
  late IdCapture _idCapture;

  // Create data capture context using your license key and set the camera as the frame source.
  final DataCaptureContext _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;

  final CameraSettings _cameraSettings = IdCapture.recommendedCameraSettings;

  late DataCaptureView _dataCaptureView;

  final _onIdCapturedEvent = StreamController<CapturedId>();

  Stream<CapturedId> get onIdCaptured => _onIdCapturedEvent.stream;

  // The verifier that compares the human-readable data from the front side of the document with
  // the data encoded in the barcode, and signals any suspicious differences.
  late AamvaVizBarcodeComparisonVerifier _comparisonVerifier;

  // The verifier that checks the validity of a Driver's License.
  late AamvaBarcodeVerifier _barcodeVerifier;

  USDLVerificationBloc() {
    _camera?.applySettings(_cameraSettings);

    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(_dataCaptureContext);

    // The Id capturing process is configured through id capture settings
    // and are then applied to the id capture instance that manages id recognition.
    var settings = IdCaptureSettings();

    // We are interested in both front and back sides of US DL.
    settings.supportedDocuments.addAll([IdDocumentType.dlViz, IdDocumentType.idCardViz]);
    settings.supportedSides = SupportedSides.frontAndBack;

    // Create new Id capture mode with the settings from above.
    _idCapture = IdCapture.forContext(_dataCaptureContext, settings)..addListener(this);

    // Add a Id capture overlay to the data capture view to render the location of captured ids on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    var overlay = IdCaptureOverlay.withIdCaptureForView(_idCapture, _dataCaptureView);
    overlay.idLayoutStyle = IdLayoutStyle.square;

    _comparisonVerifier = AamvaVizBarcodeComparisonVerifier.create();
    AamvaBarcodeVerifier.create(_dataCaptureContext).then((value) => _barcodeVerifier = value);
  }

  DataCaptureView get dataCaptureView {
    return _dataCaptureView;
  }

  void switchCameraOff() {
    _camera?.switchToDesiredState(FrameSourceState.off);
  }

  void switchCameraOn() {
    _camera?.switchToDesiredState(FrameSourceState.on);
  }

  void enableIdCapture() {
    switchCameraOn();
    _idCapture.isEnabled = true;
  }

  void disableIdCapture() {
    _idCapture.isEnabled = false;
    switchCameraOff();
  }

  void resetIdCapture() {
    disableIdCapture();
    _idCapture.reset();
  }

  @override
  void dispose() {
    switchCameraOff();
    disableIdCapture();
    _idCapture.removeListener(this);
    _onIdCapturedEvent.close();
    super.dispose();
  }

  // Whenever a driver's license is captured, this method checks whether the scanning is complete
  // and if the license is issued in the United States. If so, the driver's license is verified.
  // If the license is not issued in the United States, a dialog is shown to warn the user.
  @override
  void didCaptureId(IdCapture idCapture, IdCaptureSession session) {
    var capturedId = session.newlyCapturedId;
    if (capturedId == null) return;

    _onIdCapturedEvent.add(capturedId);
  }

  bool isUSDocument(CapturedId capturedId) {
    return capturedId.issuingCountryIso == "USA";
  }

  bool isBackScanNeeded(CapturedId capturedId) {
    return capturedId.capturedResultType == CapturedResultType.vizResult &&
        capturedId.viz?.capturedSides == SupportedSides.frontOnly &&
        capturedId.viz?.isBackSideCaptureSupported == true;
  }

  Future<AamvaVizBarcodeComparisonResult> compareFrontAndBack(CapturedId capturedId) {
    return _comparisonVerifier.verify(capturedId);
  }

  Future<AamvaBarcodeVerificationResult> verifyIdOnBarcode(CapturedId capturedId) {
    return _barcodeVerifier.verify(capturedId);
  }

  String getResultMessage(
      CapturedId capturedId, bool isDocumentExpired, bool didFrontAndBackMatch, bool didVerificationSucceed) {
    return """
    ${isDocumentExpired ? "Document is expired." : "Document is not expired."}
    ${didFrontAndBackMatch ? "Information on front and back match." : "Information on front and back do not match."}
    ${didVerificationSucceed ? "Verification checks passed." : "Verification checks failed"}

    
    Name: ${capturedId.firstName ?? "empty"}
    Last Name: ${capturedId.lastName ?? "empty"}
    Full Name: ${capturedId.fullName}
    Sex: ${capturedId.sex ?? "empty"}
    Date of Birth: ${capturedId.dateOfBirth?.date.humanReadable ?? "empty"}
    Nationality: ${capturedId.nationality ?? "empty"}
    Address: ${capturedId.address ?? "empty"}
    Document Type: ${capturedId.documentType}
    Captured Result Type: ${capturedId.capturedResultType}
    Issuing Country: ${capturedId.issuingCountry ?? "empty"}
    Issuing Country ISO: ${capturedId.issuingCountryIso ?? "empty"}
    Document Number: ${capturedId.documentNumber ?? "empty"}
    Date of Expiry: ${capturedId.dateOfExpiry?.date.humanReadable ?? "empty"}
    Date of Issue: ${capturedId.dateOfIssue?.date.humanReadable ?? "empty"}
    \n""";
  }

  @override
  void didLocalizeId(IdCapture idCapture, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didRejectId(IdCapture idCapture, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didTimedOut(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didFailWithError(IdCapture idCapture, IdCaptureError error, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }
}

extension DateTimeExtension on DateTime {
  String get humanReadable {
    return DateFormat.yMMMd().format(this);
  }
}
