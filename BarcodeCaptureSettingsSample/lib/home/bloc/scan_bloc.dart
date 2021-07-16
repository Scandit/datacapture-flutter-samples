/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class ScanBloc extends Bloc implements BarcodeCaptureListener {
  final SettingsRepository _settings = SettingsRepository();

  StreamController<String> _continuousScanResultController = StreamController();

  Stream<String> get continuousScanResult => _continuousScanResultController.stream;

  StreamController<String> _singleScanResultController = StreamController();

  Stream<String> get singleScanResult => _singleScanResultController.stream;

  ScanBloc() {
    _settings.barcodeCapture.addListener(this);
  }

  DataCaptureView get dataCaptureView {
    return _settings.dataCaptureView;
  }

  void switchCameraOff() {
    _settings.camera?.switchToDesiredState(FrameSourceState.off);
  }

  void switchCameraOn() {
    _settings.camera?.switchToDesiredState(FrameSourceState.on);
  }

  void enableBarcodeCapture() {
    _settings.barcodeCapture.isEnabled = true;
  }

  void disableBarcodeCapture() {
    _settings.barcodeCapture.isEnabled = false;
  }

  @override
  void didScan(BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {
    if (!_settings.continuousScan) {
      disableBarcodeCapture();
    }

    var barcode = session.newlyRecognizedBarcodes[0];
    var symbology = SymbologyDescription.forSymbology(barcode.symbology);

    var scannedMessage = 'Scanned: ${barcode.data} (${symbology.readableName})';

    if (_settings.continuousScan) {
      _continuousScanResultController.sink.add(scannedMessage);
    } else {
      _singleScanResultController.sink.add(scannedMessage);
    }
  }

  @override
  void didUpdateSession(BarcodeCapture barcodeCapture, BarcodeCaptureSession session) {}

  @override
  void dispose() {
    _settings.barcodeCapture.removeListener(this);
    super.dispose();
  }
}
