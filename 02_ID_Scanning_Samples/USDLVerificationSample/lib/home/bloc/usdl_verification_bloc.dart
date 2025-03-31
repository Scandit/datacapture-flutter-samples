/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:USDLVerificationSample/bloc/bloc_base.dart';
import 'package:flutter/material.dart';
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

  final _onIdRejectedEvent = StreamController<String>();

  Stream<String> get onIdRejected => _onIdRejectedEvent.stream;

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
    settings.acceptedDocuments.addAll([
      DriverLicense(IdCaptureRegion.us),
    ]);
    settings.scannerType = FullDocumentScanner();

    // Create new Id capture mode with the settings from above.
    _idCapture = IdCapture.forContext(_dataCaptureContext, settings)..addListener(this);

    // Add a Id capture overlay to the data capture view to render the location of captured ids on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    var overlay = IdCaptureOverlay.withIdCaptureForView(_idCapture, _dataCaptureView);
    overlay.idLayoutStyle = IdLayoutStyle.square;

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
  Future<void> didCaptureId(IdCapture idCapture, CapturedId rejectedId) async {
    _onIdCapturedEvent.add(rejectedId);
  }

  Future<AamvaBarcodeVerificationResult> verifyIdOnBarcode(CapturedId capturedId) {
    return _barcodeVerifier.verify(capturedId);
  }

  List<Text> getResultMessage(CapturedId capturedId, bool didVerificationSucceed) {
    List<Text> result = [];

    if (capturedId.isExpired == true) {
      result.add(Text(
        'Document is expired.',
        style: TextStyle(color: Colors.red, fontSize: 16),
      ));
    } else {
      result.add(Text(
        'Document is not expired.',
        style: TextStyle(color: Colors.green, fontSize: 16),
      ));

      if (didVerificationSucceed) {
        result.add(Text(
          'Verification checks passed.',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ));
      } else {
        result.add(Text(
          'Verification checks failed.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ));
      }
    }

    result.add(Text(
      'Full Name: ${capturedId.fullName}',
      style: TextStyle(fontSize: 16),
    ));
    result.add(Text(
      'Date of Birth: ${capturedId.dateOfBirth?.utcDate.humanReadable ?? "empty"}',
      style: TextStyle(fontSize: 16),
    ));
    result.add(Text(
      'Date of Expiry: ${capturedId.dateOfExpiry?.utcDate.humanReadable ?? "empty"}',
      style: TextStyle(fontSize: 16),
    ));
    result.add(Text(
      'Document Number: ${capturedId.documentNumber ?? "empty"}',
      style: TextStyle(fontSize: 16),
    ));
    result.add(Text(
      'Nationality: ${capturedId.nationality ?? "empty"}',
      style: TextStyle(fontSize: 16),
    ));
    return result;
  }

  @override
  Future<void> didRejectId(IdCapture idCapture, CapturedId? capturedId, RejectionReason reason) async {
    disableIdCapture();
    _onIdRejectedEvent.sink.add(_getRejectionReasonMessage(reason));
  }

  String _getRejectionReasonMessage(RejectionReason reason) {
    switch (reason) {
      case RejectionReason.notAcceptedDocumentType:
        return 'Document not supported. Try scanning another document';
      case RejectionReason.timeout:
        return 'Document capture failed. Make sure the document is well lit and free of glare. Alternatively, try scanning another document';
      default:
        return 'Document capture was rejected. Reason=${reason}';
    }
  }
}

extension DateTimeExtension on DateTime {
  String get humanReadable {
    return DateFormat.yMMMd().format(this);
  }
}
