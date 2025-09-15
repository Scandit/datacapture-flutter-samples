/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../bloc/bloc_base.dart';
import '../../managers/data_capture_context_manager.dart';
import '../provider/discount_data_provider.dart';

class BarcodeArBloc extends Bloc implements BarcodeArListener, BarcodeArInfoAnnotationListener {
  final DataCaptureContextManager _dcManager = DataCaptureContextManager();

  final DiscountDataProvider _discountDataProvider = DiscountDataProvider();

  late BarcodeAr _barcodeAr;

  BarcodeAr get barcodeAr => _barcodeAr;

  DataCaptureContext get dataCaptureContext => _dcManager.dataCaptureContext;

  late BarcodeArViewSettings _barcodeArViewSettings;

  BarcodeArViewSettings get barcodeArViewSettings => _barcodeArViewSettings;

  late CameraSettings _cameraSettings;

  CameraSettings get cameraSettings => _cameraSettings;

  @override
  void init() {
    _barcodeArViewSettings = BarcodeArViewSettings();

    _cameraSettings = BarcodeAr.recommendedCameraSettings;

    // The settings instance initially has all types of barcodes (symbologies) disabled.
    // For the purpose of this sample we enable a generous set of symbologies.
    // In your own app ensure that you only enable the symbologies that your app requires
    // as every additional enabled symbology has an impact on processing times.
    var barcodeArSettings = BarcodeArSettings()
      ..enableSymbologies({
        Symbology.ean13Upca,
        Symbology.ean8,
        Symbology.upce,
        Symbology.code39,
        Symbology.code128,
        Symbology.qr,
        Symbology.dataMatrix,
      });

    _barcodeAr = BarcodeAr(barcodeArSettings);
  }

  void startCapturing() {
    _dcManager.camera.switchToDesiredState(FrameSourceState.on);
  }

  void stopCapturing() {
    _dcManager.camera.switchToDesiredState(FrameSourceState.off);
  }

  @override
  void dispose() {
    _barcodeAr.removeListener(this);
  }

  @override
  Future<void> didUpdateSession(
      BarcodeAr barcodeAr, BarcodeArSession session, Future<FrameData> Function() getFrameData) {
    // Not relevant for this sample
    return Future.value();
  }

  Future<BarcodeArAnnotation> annotationForBarcode(Barcode barcode) async {
    // Get discount data for the barcode
    final discount = _discountDataProvider.getDataForBarcode(barcode);

    // Create and configure the header section of the annotation
    final header = BarcodeArInfoAnnotationHeader()
      ..backgroundColor = discount.color
      ..text = discount.percentage;

    // Create and configure the body section of the annotation
    final bodyComponent = BarcodeArInfoAnnotationBodyComponent()..text = discount.getDisplayText(true);

    // Create the annotation itself and attach the header and body
    final annotation = BarcodeArInfoAnnotation(barcode)
      ..header = header
      ..body = [bodyComponent]
      ..width = BarcodeArInfoAnnotationWidthPreset.large
      ..backgroundColor = Color(0xE6FFFFFF)
      ..isEntireAnnotationTappable = true
      ..listener = this;

    return annotation;
  }

  Future<BarcodeArHighlight> highlightForBarcode(Barcode barcode) async {
    // Returns a circular dot highlight that will be displayed over each detected barcode
    final highlight = BarcodeArCircleHighlight(barcode, BarcodeArCircleHighlightPreset.dot)
      ..brush = Brush(Colors.white, Colors.white, 1.0);
    return highlight;
  }

  @override
  void didTapInfoAnnotation(BarcodeArInfoAnnotation annotation) {
    final discount = _discountDataProvider.getDataForBarcode(annotation.barcode);
    annotation.body.first.text = discount.getDisplayText(false);
  }

  @override
  void didTapInfoAnnotationFooter(BarcodeArInfoAnnotation annotation) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationHeader(BarcodeArInfoAnnotation annotation) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationLeftIcon(BarcodeArInfoAnnotation annotation, int componentIndex) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationRightIcon(BarcodeArInfoAnnotation annotation, int componentIndex) {
    // Not relevant for this sample
  }
}
