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

class HighlightsBloc extends Bloc implements BarcodeArListener, BarcodeArViewUiListener {
  final BarcodeArConfigProvider _config = BarcodeArConfigProvider();
  late BarcodeAr _barcodeAr;
  final Set<String> _tappedBarcodes = {};

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
    final barcodeData = barcode.data ?? '';
    final isTapped = _tappedBarcodes.contains(barcodeData);

    final selectedBrush = Brush(
      const Color(0x660000FF),
      const Color(0xFF0000FF),
      1.0,
    );
    final normalBrush = Brush(
      const Color(0x6600FFFF),
      const Color(0xFF00FFFF),
      1.0,
    );

    final highlight = BarcodeArRectangleHighlight(barcode)..brush = isTapped ? selectedBrush : normalBrush;

    if (isTapped) {
      highlight.icon =
          ScanditIconBuilder().withIcon(ScanditIconType.checkmark).withIconColor(const Color(0xFFFFFFFF)).build();
    }

    return highlight;
  }

  @override
  void didTapHighlightForBarcode(BarcodeAr barcodeAr, Barcode barcode, BarcodeArHighlight highlight) {
    if (highlight is! BarcodeArRectangleHighlight) return;

    final barcodeData = barcode.data;
    if (barcodeData == null) return;

    final selectedBrush = Brush(
      const Color(0x660000FF),
      const Color(0xFF0000FF),
      1.0,
    );
    final normalBrush = Brush(
      const Color(0x6600FFFF),
      const Color(0xFF00FFFF),
      1.0,
    );

    if (_tappedBarcodes.contains(barcodeData)) {
      highlight.brush = normalBrush;
      highlight.icon = null;
      _tappedBarcodes.remove(barcodeData);
    } else {
      highlight.brush = selectedBrush;
      highlight.icon =
          ScanditIconBuilder().withIcon(ScanditIconType.checkmark).withIconColor(const Color(0xFFFFFFFF)).build();
      _tappedBarcodes.add(barcodeData);
    }
  }
}
