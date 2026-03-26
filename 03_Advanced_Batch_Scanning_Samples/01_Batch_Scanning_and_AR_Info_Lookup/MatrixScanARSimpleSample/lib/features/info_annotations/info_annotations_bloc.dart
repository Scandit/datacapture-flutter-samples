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

class InfoAnnotationsBloc extends Bloc implements BarcodeArListener, BarcodeArInfoAnnotationListener {
  final BarcodeArConfigProvider _config = BarcodeArConfigProvider();
  late BarcodeAr _barcodeAr;

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
    return BarcodeArCircleHighlight(barcode, BarcodeArCircleHighlightPreset.dot)
      ..brush = Brush(const Color(0xFF00FFFF), const Color(0xFF00FFFF), 1.0);
  }

  Future<BarcodeArAnnotation> annotationForBarcode(Barcode barcode) async {
    final checkMarkIcon =
        ScanditIconBuilder().withIcon(ScanditIconType.checkmark).withIconColor(const Color(0xFF000000)).build();

    // Create closeup annotation
    final closeup = BarcodeArInfoAnnotation(barcode)
      ..backgroundColor = const Color(0xFFFFFFFF)
      ..width = BarcodeArInfoAnnotationWidthPreset.large
      ..isEntireAnnotationTappable = true
      ..listener = this;

    final header = BarcodeArInfoAnnotationHeader()
      ..text = 'Header'
      ..icon = checkMarkIcon
      ..backgroundColor = const Color(0xFF00FFFF);
    closeup.header = header;

    final first = BarcodeArInfoAnnotationBodyComponent()..text = 'This is text in a large container.';
    final second = BarcodeArInfoAnnotationBodyComponent()..text = 'It can have multiple lines.';
    final third = BarcodeArInfoAnnotationBodyComponent()
      ..leftIcon = checkMarkIcon
      ..text = 'Point';
    final fourth = BarcodeArInfoAnnotationBodyComponent()
      ..leftIcon = checkMarkIcon
      ..text = 'Point';
    closeup.body = [first, second, third, fourth];

    final footer = BarcodeArInfoAnnotationFooter()
      ..text = 'Tap to change color'
      ..backgroundColor = const Color(0xFF121619);
    closeup.footer = footer;

    // Create faraway annotation
    final faraway = BarcodeArInfoAnnotation(barcode)..width = BarcodeArInfoAnnotationWidthPreset.medium;

    final farawayBody = BarcodeArInfoAnnotationBodyComponent()..text = 'Body text';
    faraway.body = [farawayBody];

    // Create responsive annotation
    return BarcodeArResponsiveAnnotation(barcode, closeup, faraway)..threshold = 0.05;
  }

  @override
  void didTapInfoAnnotation(BarcodeArInfoAnnotation annotation) {
    final exclamationMarkIcon =
        ScanditIconBuilder().withIcon(ScanditIconType.exclamationMark).withIconColor(const Color(0xFF000000)).build();

    final checkMarkIcon =
        ScanditIconBuilder().withIcon(ScanditIconType.checkmark).withIconColor(const Color(0xFF000000)).build();

    if (annotation.header?.icon?.icon == ScanditIconType.exclamationMark) {
      annotation.header?.backgroundColor = const Color(0xFF00FFFF);
      annotation.header?.icon = checkMarkIcon;
    } else {
      annotation.header?.backgroundColor = const Color(0xFFFF0000);
      annotation.header?.icon = exclamationMarkIcon;
    }
  }

  @override
  void didTapInfoAnnotationFooter(BarcodeArInfoAnnotation annotation) {}

  @override
  void didTapInfoAnnotationHeader(BarcodeArInfoAnnotation annotation) {}

  @override
  void didTapInfoAnnotationLeftIcon(BarcodeArInfoAnnotation annotation, int componentIndex) {}

  @override
  void didTapInfoAnnotationRightIcon(BarcodeArInfoAnnotation annotation, int componentIndex) {}
}
