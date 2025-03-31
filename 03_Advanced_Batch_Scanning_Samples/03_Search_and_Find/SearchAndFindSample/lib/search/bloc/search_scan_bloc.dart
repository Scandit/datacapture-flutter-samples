/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:SearchAndFindSample/bloc/bloc_base.dart';
import 'package:SearchAndFindSample/models/data_capture_manager.dart';
import 'package:SearchAndFindSample/search/models/captured_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';

class SearchScanBloc extends Bloc implements BarcodeCaptureListener {
  DataCaptureManager _dataCaptureManager = DataCaptureManager();

  late BarcodeCapture _barcodeCapture;

  final _onBarcodeCaptured = StreamController<CapturedBarcode>();

  Stream<CapturedBarcode> get onBarcodeCaptured => _onBarcodeCaptured.stream;

  DataCaptureContext get dataCaptureContext => _dataCaptureManager.dataCaptureContext;

  BarcodeCapture get barcodeCapture => _barcodeCapture;

  var _settings = new BarcodeCaptureSettings();

  SearchScanBloc() {
    // The barcode capturing process is configured through barcode capture settings
    // which are then applied to the barcode capture instance that manages barcode recognition.
    _settings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.code128,
      Symbology.code39,
      Symbology.dataMatrix
    });

    // In order not to pick up barcodes outside of the view finder,
    // restrict the code location selection to match the laser line's center.
    _settings.locationSelection = RadiusLocationSelection(new DoubleWithUnit(0, MeasureUnit.fraction));

    // Setting the code duplicate filter to one second means that the scanner won't report
    // the same code as recognized for one second once it's recognized.
    _settings.codeDuplicateFilter = Duration(seconds: 1);
  }

  void setupScanning() {
    // Remove all modes added from the other screens
    dataCaptureContext.removeAllModes();

    // Create new barcode capture mode with the settings from above.
    _barcodeCapture = BarcodeCapture.forContext(_dataCaptureManager.dataCaptureContext, _settings);

    // listen for barcode capture events
    _barcodeCapture.addListener(this);

    _dataCaptureManager.camera?.applySettings(BarcodeCapture.recommendedCameraSettings);

    dataCaptureContext.addMode(barcodeCapture);

    _barcodeCapture = barcodeCapture;
  }

  Future<void> disposeCurrentScanning() {
    _barcodeCapture.removeListener(this);
    _barcodeCapture.isEnabled = false;
    dataCaptureContext.removeMode(_barcodeCapture);
    return _dataCaptureManager.camera?.switchToDesiredState(FrameSourceState.off) ?? Future.value(null);
  }

  Future<void> resumeScanning() {
    enableCapture();
    return _dataCaptureManager.camera?.switchToDesiredState(FrameSourceState.on) ?? Future.value(null);
  }

  Future<void> pauseScanning() {
    disableCapture();
    return _dataCaptureManager.camera?.switchToDesiredState(FrameSourceState.off) ?? Future.value(null);
  }

  void enableCapture() {
    _barcodeCapture.isEnabled = true;
  }

  void disableCapture() {
    _barcodeCapture.isEnabled = false;
  }

  @override
  Future<void> didScan(
      BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> getFrameData()) async {
    var barcode = session.newlyRecognizedBarcode;
    if (barcode == null) return;

    // In this sample we decided to ignore barcodes withot data
    if (barcode.data == null) return;

    // Emit new barcode is captured
    _onBarcodeCaptured.add(CapturedBarcode(barcode.symbology, barcode.data!));

    print("captured ${barcode.data}");
  }

  @override
  Future<void> didUpdateSession(
      BarcodeCapture barcodeCapture, BarcodeCaptureSession session, Future<FrameData> getFrameData()) async {
    // not relevant in this sample
  }

  @override
  void dispose() {
    _onBarcodeCaptured.close();
    barcodeCapture.removeListener(this);
    dataCaptureContext.removeMode(barcodeCapture);
    super.dispose();
  }
}
