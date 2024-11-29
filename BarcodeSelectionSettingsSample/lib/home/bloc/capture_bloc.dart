/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class CaptureBloc extends Bloc implements BarcodeSelectionListener {
  final SettingsRepository _settings = SettingsRepository();

  StreamController<String> _selectionController = StreamController();

  Stream<String> get barcodeSelectedStream => _selectionController.stream;

  CaptureBloc() {
    _settings.barcodeSelection.addListener(this);
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
    _settings.barcodeSelection.isEnabled = true;
  }

  void disableBarcodeCapture() {
    _settings.barcodeSelection.isEnabled = false;
  }

  @override
  Future<void> didUpdateSelection(
      BarcodeSelection barcodeSelection, BarcodeSelectionSession session, Future<FrameData?> getFrameData()) async {
    // Check if we have selected a barcode, if that's the case, add the result to the stream.
    var newlySelectedBarcodes = session.newlySelectedBarcodes;
    if (newlySelectedBarcodes.isEmpty) return;

    // Get the human readable name of the symbology and assemble the result to be shown.
    var barcode = newlySelectedBarcodes.first;
    var symbologyReadableName = SymbologyDescription.forSymbology(barcode.symbology).readableName;

    session.getCount(barcode).then((value) {
      _selectionController.sink.add('${symbologyReadableName}: ${barcode.data} \nTimes: ${value}');
    });
  }

  @override
  Future<void> didUpdateSession(
      BarcodeSelection barcodeSelection, BarcodeSelectionSession session, Future<FrameData?> getFrameData()) async {}

  @override
  void dispose() {
    switchCameraOff();
    disableBarcodeCapture();
    _settings.barcodeSelection.removeListener(this);
    _selectionController.close();
    super.dispose();
  }
}
