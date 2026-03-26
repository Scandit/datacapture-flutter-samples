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

class StatusIconsBloc extends Bloc implements BarcodeArListener {
  final BarcodeArConfigProvider _config = BarcodeArConfigProvider();
  late BarcodeAr _barcodeAr;

  final Map<String, String> _barcodeStatus = {}; // 'closeToExpiry', 'expired'

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
    return BarcodeArRectangleHighlight(barcode);
  }

  Future<BarcodeArAnnotation> annotationForBarcode(Barcode barcode) async {
    final barcodeData = barcode.data;
    if (barcodeData == null) {
      return BarcodeArStatusIconAnnotation(barcode);
    }

    if (!_barcodeStatus.containsKey(barcodeData)) {
      _barcodeStatus[barcodeData] = _barcodeStatus.length % 2 == 0 ? 'closeToExpiry' : 'expired';
    }

    final annotation = BarcodeArStatusIconAnnotation(barcode);
    final status = _barcodeStatus[barcodeData];

    final redColor = const Color(0xFFD92121);
    final yellowColor = const Color(0xFFFBC02C);
    final blackColor = const Color(0xFF000000);
    final whiteColor = const Color(0xFFFFFFFF);

    if (status == 'closeToExpiry') {
      annotation.text = 'Close to expiry';
      annotation.icon = ScanditIconBuilder()
          .withBackgroundShape(ScanditIconShape.circle)
          .withBackgroundColor(yellowColor)
          .withIcon(ScanditIconType.exclamationMark)
          .withIconColor(blackColor)
          .build();
    } else if (status == 'expired') {
      annotation.text = 'Item expired';
      annotation.icon = ScanditIconBuilder()
          .withBackgroundShape(ScanditIconShape.circle)
          .withBackgroundColor(redColor)
          .withIcon(ScanditIconType.exclamationMark)
          .withIconColor(whiteColor)
          .build();
    }

    return annotation;
  }
}
