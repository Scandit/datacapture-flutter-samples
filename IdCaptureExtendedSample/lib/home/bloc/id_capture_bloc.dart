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

class IdCaptureBloc extends Bloc implements IdCaptureAdvancedAsyncListener {
  IdCapture? _idCapture;
  IdCaptureOverlay? _overlay;

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
    var currentOverlay = _overlay;

    if (currentIdCapture != null) {
      currentIdCapture.removeAdvancedAsyncListener(this);
      _dataCaptureContext.removeMode(currentIdCapture);
      if (currentOverlay != null) {
        _dataCaptureView.removeOverlay(currentOverlay);
      }
    }

    var idCapture = IdCapture.forContext(_dataCaptureContext, _getSettingsForCurrentType());
    idCapture.addAdvancedAsyncListener(this);
    _overlay = IdCaptureOverlay.withIdCaptureForView(idCapture, _dataCaptureView);
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
    _idCapture?.removeAdvancedAsyncListener(this);
    _idCaptureController.close();
    super.dispose();
  }

  @override
  Future<void> didCaptureId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    var capturedId = session.newlyCapturedId;
    if (capturedId == null) return;

    if (capturedId.capturedResultType != CapturedResultType.vizResult ||
        capturedId.viz?.capturedSides != SupportedSides.frontOnly ||
        capturedId.viz?.isBackSideCaptureSupported == false) {
      _emitResult(capturedId);
    }
  }

  void _emitResult(CapturedId capturedId) {
    CapturedIdResult result;

    if (capturedId.capturedResultTypes.contains(CapturedResultType.aamvaBarcodeResult)) {
      result = AamvaCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.colombiaIdBarcodeResult)) {
      result = ColombiaIdCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.argentinaIdBarcodeResult)) {
      result = ArgentinaIdCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.southAfricaIdBarcodeResult)) {
      result = SouthAfricaIdCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.southAfricaDlBarcodeResult)) {
      result = SouthAfricaDlCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.usUniformedServicesBarcodeResult)) {
      result = UsUniformedServicesCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.mrzResult)) {
      result = MrzCapturedIdResult(capturedId);
    } else if (capturedId.capturedResultTypes.contains(CapturedResultType.vizResult)) {
      result = VizCapturedIdResult(capturedId);
    } else {
      result = CapturedIdResult(capturedId);
    }

    disableIdCapture();

    _idCaptureController.sink.add(ResultEvent(result));
  }

  @override
  Future<void> didLocalizeId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    // In this sample we are not interested in this callback.
  }

  @override
  Future<void> didRejectId(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    // In this sample we are not interested in this callback.
  }

  @override
  Future<void> didTimedOut(IdCapture idCapture, IdCaptureSession session, Future<FrameData> getFrameData()) async {
    // In this sample we are not interested in this callback.
  }
}
