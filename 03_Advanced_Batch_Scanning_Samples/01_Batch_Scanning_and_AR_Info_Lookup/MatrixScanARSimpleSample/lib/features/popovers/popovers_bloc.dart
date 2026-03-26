/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../bloc/bloc_base.dart';
import '../../provider/barcode_ar_config_provider.dart';

class PopoversBloc extends Bloc implements BarcodeArListener, BarcodeArPopoverAnnotationListener {
  final BarcodeArConfigProvider _config = BarcodeArConfigProvider();
  late BarcodeAr _barcodeAr;

  final Map<String, String> _barcodeStatus = {}; // 'wrong', 'accepted', 'rejected'
  final Map<String, BarcodeArCircleHighlight> _highlights = {};

  BarcodeAr get barcodeAr => _barcodeAr;
  DataCaptureContext get dataCaptureContext => _config.dataCaptureContext;

  late BarcodeArViewSettings _barcodeArViewSettings;
  BarcodeArViewSettings get barcodeArViewSettings => _barcodeArViewSettings;

  late CameraSettings _cameraSettings;
  CameraSettings get cameraSettings => _cameraSettings;

  @override
  void init() {
    _barcodeArViewSettings = _config.createViewSettings();
    _cameraSettings = _config.createCameraSettings();
    _barcodeAr = _config.createBarcodeAr();
  }

  void startCapturing() {
    _config.startCapturing();
  }

  void stopCapturing() {
    _config.stopCapturing();
  }

  @override
  void dispose() {
    _barcodeAr.removeListener(this);
  }

  @override
  Future<void> didUpdateSession(
      BarcodeAr barcodeAr, BarcodeArSession session, Future<FrameData> Function() getFrameData) {
    return Future.value();
  }

  Future<BarcodeArHighlight> highlightForBarcode(Barcode barcode) async {
    final barcodeData = barcode.data;
    if (barcodeData == null) return BarcodeArCircleHighlight(barcode, BarcodeArCircleHighlightPreset.icon);

    if (!_barcodeStatus.containsKey(barcodeData)) {
      _barcodeStatus[barcodeData] = _barcodeStatus.length % 2 == 0 ? 'wrong' : 'accepted';
    }

    BarcodeArCircleHighlight? highlight = _highlights[barcodeData];
    if (highlight == null) {
      highlight = BarcodeArCircleHighlight(barcode, BarcodeArCircleHighlightPreset.icon);
      _highlights[barcodeData] = highlight;
    }

    final status = _barcodeStatus[barcodeData];
    _updateHighlightForStatus(highlight, status);

    return highlight;
  }

  Future<BarcodeArAnnotation?> annotationForBarcode(Barcode barcode) async {
    final barcodeData = barcode.data;
    if (barcodeData == null) return null;

    if (_barcodeStatus[barcodeData] != 'wrong') {
      return null;
    }

    final redColor = const Color(0xFFD92121);
    final greenColor = const Color(0xFF0D853D);
    final whiteColor = const Color(0xFFFFFFFF);

    final rejectButtonIcon = ScanditIconBuilder()
        .withIcon(ScanditIconType.xMark)
        .withIconColor(whiteColor)
        .withBackgroundShape(ScanditIconShape.circle)
        .withBackgroundColor(redColor)
        .build();

    final acceptButtonIcon = ScanditIconBuilder()
        .withIcon(ScanditIconType.checkmark)
        .withIconColor(whiteColor)
        .withBackgroundShape(ScanditIconShape.circle)
        .withBackgroundColor(greenColor)
        .build();

    final rejectButton = BarcodeArPopoverAnnotationButton(rejectButtonIcon, 'Reject');
    final acceptButton = BarcodeArPopoverAnnotationButton(acceptButtonIcon, 'Accept');

    return BarcodeArPopoverAnnotation(barcode, [rejectButton, acceptButton])
      ..annotationTrigger = BarcodeArAnnotationTrigger.highlightTap
      ..listener = this;
  }

  @override
  void didTapPopoverButton(
      BarcodeArPopoverAnnotation popover, BarcodeArPopoverAnnotationButton button, int buttonIndex) {
    final barcodeData = popover.barcode.data;
    if (barcodeData == null) return;

    if (buttonIndex == 0) {
      _barcodeStatus[barcodeData] = 'rejected';
    } else if (buttonIndex == 1) {
      _barcodeStatus[barcodeData] = 'accepted';
    }

    final highlight = _highlights[barcodeData];
    if (highlight != null) {
      _updateHighlightForStatus(highlight, _barcodeStatus[barcodeData]);
    }
  }

  @override
  void didTapPopover(BarcodeArPopoverAnnotation popover) {}

  void _updateHighlightForStatus(BarcodeArCircleHighlight highlight, String? status) {
    final redColor = const Color(0xFFD92121);
    final greenColor = const Color(0xFF0D853D);
    final whiteColor = const Color(0xFFFFFFFF);

    if (status == 'accepted') {
      highlight.brush = Brush(greenColor, greenColor, 1.0);
      highlight.icon = ScanditIconBuilder().withIcon(ScanditIconType.checkmark).withIconColor(whiteColor).build();
    } else if (status == 'wrong') {
      highlight.brush = Brush(redColor, redColor, 1.0);
      highlight.icon = ScanditIconBuilder().withIcon(ScanditIconType.exclamationMark).withIconColor(whiteColor).build();
    } else if (status == 'rejected') {
      highlight.brush = Brush(redColor, redColor, 1.0);
      highlight.icon = ScanditIconBuilder().withIcon(ScanditIconType.xMark).withIconColor(whiteColor).build();
    }
  }
}
