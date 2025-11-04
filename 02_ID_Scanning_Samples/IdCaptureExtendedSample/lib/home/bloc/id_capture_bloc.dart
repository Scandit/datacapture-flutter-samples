/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:IdCaptureExtendedSample/bloc/bloc_base.dart';
import 'package:IdCaptureExtendedSample/home/model/Id_capture_mode.dart';
import 'package:IdCaptureExtendedSample/home/model/barcode_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/capture_event.dart';
import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/mrz_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/viz_captured_id_result.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class IdCaptureBloc extends Bloc implements IdCaptureListener {
  IdCapture? _idCapture;
  IdCaptureOverlay? _overlay;

  late DataCaptureContext _dataCaptureContext;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;

  final CameraSettings _cameraSettings = IdCapture.createRecommendedCameraSettings();

  late DataCaptureView _dataCaptureView;

  List<IdCaptureDocument> _acceptedDocuments = [
    new IdCard(IdCaptureRegion.any),
    new DriverLicense(IdCaptureRegion.any),
    new Passport(IdCaptureRegion.any),
  ];

  IdCaptureBloc() {
    _camera?.applySettings(_cameraSettings);

    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);
    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(_dataCaptureContext);

    _createIdCapture();
  }

  StreamController<ResultEvent> _idCapturedController = StreamController();

  Stream<ResultEvent> get onItemCaptured => _idCapturedController.stream;

  StreamController<String> _idRejectedController = StreamController();

  Stream<String> get onIdRejected => _idRejectedController.stream;

  void _createIdCapture() {
    var currentIdCapture = _idCapture;
    var currentOverlay = _overlay;

    if (currentIdCapture != null) {
      currentIdCapture.removeListener(this);
      _dataCaptureContext.removeCurrentMode();
      if (currentOverlay != null) {
        _dataCaptureView.removeOverlay(currentOverlay);
      }
    }

    var idCapture = IdCapture(_getSettingsForCurrentType());
    idCapture.addListener(this);
    _overlay = IdCaptureOverlay(idCapture);
    _idCapture = idCapture;

    // Set the id capture mode as the current mode of the data capture context.
    _dataCaptureContext.setMode(idCapture);

    _dataCaptureView.addOverlay(_overlay!);
  }

  // Extract data from barcodes present on various personal identification document types.
  IdCaptureSettings _getBarcodeSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    settings.setShouldPassImageTypeToResult(IdImageType.face, true);
    settings.acceptedDocuments.addAll(_acceptedDocuments);
    settings.scanner = IdCaptureScanner(physicalDocumentScanner: SingleSideScanner(true, false, false));
    return settings;
  }

  // Extract data from Machine Readable Zones (MRZ) present for example on IDs, passports or visas.
  IdCaptureSettings _getMrzSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    settings.acceptedDocuments.addAll(_acceptedDocuments);
    settings.scanner = IdCaptureScanner(physicalDocumentScanner: SingleSideScanner(false, true, false));
    return settings;
  }

  // Extract data from personal identification document's human-readable texts
  // (like the holder's name or date of birth printed on an ID).
  IdCaptureSettings _getVizSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    settings.acceptedDocuments.addAll(_acceptedDocuments);
    settings.scanner = IdCaptureScanner(physicalDocumentScanner: SingleSideScanner(false, false, true));
    settings.setShouldPassImageTypeToResult(IdImageType.face, true);
    settings.setShouldPassImageTypeToResult(IdImageType.croppedDocument, true);
    return settings;
  }

  IdCaptureSettings _getSettingsForCurrentType() {
    switch (_currentMode) {
      case IdCaptureMode.barcode:
        return _getBarcodeSettings();
      case IdCaptureMode.mrz:
        return _getMrzSettings();
      case IdCaptureMode.viz:
        return _getVizSettings();
    }
  }

  DataCaptureView get dataCaptureView {
    return _dataCaptureView;
  }

  IdCaptureMode _currentMode = IdCaptureMode.barcode;

  int get currentModeIndex {
    return IdCaptureMode.values.indexOf(_currentMode);
  }

  set currentModeIndex(int newIndex) {
    _currentMode = IdCaptureMode.values.elementAt(newIndex);
    _createIdCapture();
  }

  void continueBackside() {
    enableIdCapture();
  }

  void switchCameraOff() {
    _camera?.switchToDesiredState(FrameSourceState.off);
  }

  void switchCameraOn() {
    _camera?.switchToDesiredState(FrameSourceState.on);
  }

  void enableIdCapture() {
    switchCameraOn();
    _idCapture?.isEnabled = true;
  }

  void disableIdCapture() {
    _idCapture?.isEnabled = false;
    switchCameraOff();
  }

  @override
  void dispose() {
    switchCameraOff();
    disableIdCapture();
    _idCapture?.removeListener(this);
    _idCapturedController.close();
    _idRejectedController.close();
    super.dispose();
  }

  @override
  Future<void> didCaptureId(IdCapture idCapture, CapturedId capturedId) async {
    _emitResult(capturedId);
  }

  void _emitResult(CapturedId capturedId) {
    CapturedIdResult result;

    if (capturedId.barcode != null) {
      result = BarcodeCapturedIdResult(capturedId);
    } else if (capturedId.mrz != null) {
      result = MrzCapturedIdResult(capturedId);
    } else if (capturedId.viz != null) {
      result = VizCapturedIdResult(capturedId);
    } else {
      result = CapturedIdResult(capturedId);
    }

    disableIdCapture();

    _idCapturedController.sink.add(ResultEvent(result));
  }

  @override
  Future<void> didRejectId(IdCapture idCapture, CapturedId? rejectedId, RejectionReason reason) async {
    disableIdCapture();
    _idRejectedController.sink.add(_getRejectionReasonMessage(reason));
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
