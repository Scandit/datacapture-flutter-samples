/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:IdCaptureExtendedSample/bloc/bloc_base.dart';
import 'package:IdCaptureExtendedSample/home/model/Id_capture_mode.dart';
import 'package:IdCaptureExtendedSample/home/model/aamva_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/argentina_id_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/capture_event.dart';
import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/colombia_id_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/mrz_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/south_africa_dl_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/south_africa_id_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/us_uniformed_services_captured_id_result.dart';
import 'package:IdCaptureExtendedSample/home/model/viz_captured_id_result.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class IdCaptureBloc extends Bloc implements IdCaptureListener {
  IdCapture? _idCapture;

  late DataCaptureContext _dataCaptureContext;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;

  final CameraSettings _cameraSettings = IdCapture.recommendedCameraSettings;

  late DataCaptureView _dataCaptureView;

  Map<IdCaptureMode, List<IdDocumentType>> get _supportedDocuments => {
        IdCaptureMode.barcode: [
          IdDocumentType.aamvaBarcode,
          IdDocumentType.colombiaIdBarcode,
          IdDocumentType.usUsIdBarcode,
          IdDocumentType.argentinaIdBarcode,
          IdDocumentType.southAfricaDlBarcode,
          IdDocumentType.southAfricaIdBarcode,
        ],
        IdCaptureMode.mrz: [
          IdDocumentType.visaMrz,
          IdDocumentType.passportMrz,
          IdDocumentType.swissDlMrz,
          IdDocumentType.idCardMrz,
        ],
        IdCaptureMode.viz: [IdDocumentType.dlViz, IdDocumentType.idCardViz]
      };

  IdCaptureBloc() {
    _camera?.applySettings(_cameraSettings);

    // Create data capture context using your license key and set the camera as the frame source.
    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);
    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    // To visualize the on-going id capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(_dataCaptureContext);

    _createIdCapture();
  }

  StreamController<ResultEvent> _idCaptureController = StreamController();

  Stream<ResultEvent> get idCaptureController => _idCaptureController.stream;

  void _createIdCapture() {
    var currentIdCapture = _idCapture;

    if (currentIdCapture != null) {
      currentIdCapture.removeListener(this);
      _dataCaptureContext.removeMode(currentIdCapture);
    }

    var idCapture = IdCapture.forContext(_dataCaptureContext, _getSettingsForCurrentType());
    idCapture.addListener(this);
    IdCaptureOverlay.withIdCaptureForView(idCapture, _dataCaptureView);
    _idCapture = idCapture;
  }

  // Extract data from barcodes present on various personal identification document types.
  IdCaptureSettings _getBarcodeSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    settings.setShouldPassImageTypeToResult(IdImageType.face, true);
    var supportedDocuments = _supportedDocuments[IdCaptureMode.barcode];
    if (supportedDocuments != null && supportedDocuments.isNotEmpty)
      settings.supportedDocuments.addAll(supportedDocuments);
    return settings;
  }

  // Extract data from Machine Readable Zones (MRZ) present for example on IDs, passports or visas.
  IdCaptureSettings _getMrzSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    var supportedDocuments = _supportedDocuments[IdCaptureMode.mrz];
    if (supportedDocuments != null && supportedDocuments.isNotEmpty)
      settings.supportedDocuments.addAll(supportedDocuments);
    return settings;
  }

  // Extract data from personal identification document's human-readable texts
  // (like the holder's name or date of birth printed on an ID).
  IdCaptureSettings _getVizSettings() {
    IdCaptureSettings settings = new IdCaptureSettings();
    settings.supportedSides = SupportedSides.frontAndBack;
    settings.setShouldPassImageTypeToResult(IdImageType.face, true);
    settings.setShouldPassImageTypeToResult(IdImageType.idFront, true);
    settings.setShouldPassImageTypeToResult(IdImageType.idBack, true);
    var supportedDocuments = _supportedDocuments[IdCaptureMode.viz];
    if (supportedDocuments != null && supportedDocuments.isNotEmpty)
      settings.supportedDocuments.addAll(supportedDocuments);
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

  void skipBackside() {
    // Reset the state of IdCapture. This is necessary if you decide to skip the back side of
    // a document when the back side scan is supported. If you omit this call, IdCapture still
    // expects to capture the back side of the previous document instead of the new one.
    _idCapture?.reset();
    _emitResult();
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
    _idCapture?.removeListener(this);
    _idCaptureController.close();
    super.dispose();
  }

  CapturedId? _lastCapturedId = null;

  @override
  void didCaptureId(IdCapture idCapture, IdCaptureSession session) {
    var capturedId = session.newlyCapturedId;
    if (capturedId == null) return;
    _lastCapturedId = capturedId;
    disableIdCapture();

    if (capturedId.capturedResultType == CapturedResultType.vizResult &&
        capturedId.viz?.capturedSides == SupportedSides.frontOnly &&
        capturedId.viz?.isBackSideCaptureSupported == true) {
      _emitConfirmationBacksideScanning();
    } else {
      _emitResult();
    }
  }

  void _emitConfirmationBacksideScanning() {
    _idCaptureController.sink.add(ResultEvent(AskBackScan()));
  }

  void _emitResult() {
    var capturedId = _lastCapturedId;
    if (capturedId == null) return;

    CapturedIdResult result;

    switch (capturedId.capturedResultType) {
      case CapturedResultType.aamvaBarcodeResult:
        result = AamvaCapturedIdResult(capturedId);
        break;
      case CapturedResultType.colombiaIdBarcodeResult:
        result = ColombiaIdCapturedIdResult(capturedId);
        break;
      case CapturedResultType.argentinaIdBarcodeResult:
        result = ArgentinaIdCapturedIdResult(capturedId);
        break;
      case CapturedResultType.southAfricaIdBarcodeResult:
        result = SouthAfricaIdCapturedIdResult(capturedId);
        break;
      case CapturedResultType.southAfricaDlBarcodeResult:
        result = SouthAfricaDlCapturedIdResult(capturedId);
        break;
      case CapturedResultType.usUniformedServicesBarcodeResult:
        result = UsUniformedServicesCapturedIdResult(capturedId);
        break;
      case CapturedResultType.mrzResult:
        result = MrzCapturedIdResult(capturedId);
        break;
      case CapturedResultType.vizResult:
        result = VizCapturedIdResult(capturedId);
        break;
      default:
        throw new AssertionError('Unknown captured result type: ${capturedId.capturedResultType}');
    }

    _idCaptureController.sink.add(ResultEvent(result));
  }

  @override
  void didFailWithError(IdCapture idCapture, IdCaptureError error, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didLocalizeId(IdCapture idCapture, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }

  @override
  void didRejectId(IdCapture idCapture, IdCaptureSession session) {
    // In this sample we are not interested in this callback.
  }
}
