/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_check.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../../bloc/bloc_base.dart';
import '../../managers/data_capture_context_manager.dart';
import '../provider/discount_data_provider.dart';

class BarcodeCheckBloc extends Bloc implements BarcodeCheckListener, BarcodeCheckInfoAnnotationListener {
  final DataCaptureContextManager _dcManager = DataCaptureContextManager();

  final DiscountDataProvider _discountDataProvider = DiscountDataProvider();

  late BarcodeCheck _barcodeCheck;

  BarcodeCheck get barcodeCheck => _barcodeCheck;

  DataCaptureContext get dataCaptureContext => _dcManager.dataCaptureContext;

  late BarcodeCheckViewSettings _barcodeCheckViewSettings;

  BarcodeCheckViewSettings get barcodeCheckViewSettings => _barcodeCheckViewSettings;

  late CameraSettings _cameraSettings;

  CameraSettings get cameraSettings => _cameraSettings;

  @override
  void init() {
    _barcodeCheckViewSettings = BarcodeCheckViewSettings();

    _cameraSettings = BarcodeCheck.recommendedCameraSettings;

    // The settings instance initially has all types of barcodes (symbologies) disabled.
    // For the purpose of this sample we enable a generous set of symbologies.
    // In your own app ensure that you only enable the symbologies that your app requires
    // as every additional enabled symbology has an impact on processing times.
    var barcodeCheckSettings = BarcodeCheckSettings()
      ..enableSymbologies({
        Symbology.ean13Upca,
        Symbology.ean8,
        Symbology.upce,
        Symbology.code39,
        Symbology.code128,
        Symbology.qr,
        Symbology.dataMatrix,
      });

    _barcodeCheck = BarcodeCheck.forContext(_dcManager.dataCaptureContext, barcodeCheckSettings);
  }

  void startCapturing() {
    _dcManager.camera.switchToDesiredState(FrameSourceState.on);
  }

  void stopCapturing() {
    _dcManager.camera.switchToDesiredState(FrameSourceState.off);
  }

  @override
  void dispose() {
    _barcodeCheck.removeListener(this);
  }

  @override
  Future<void> didUpdateSession(
      BarcodeCheck barcodeCheck, BarcodeCheckSession session, Future<FrameData> Function() getFrameData) {
    // Not relevant for this sample
    return Future.value();
  }

  Future<BarcodeCheckAnnotation> annotationForBarcode(Barcode barcode) async {
    // Get discount data for the barcode
    final discount = _discountDataProvider.getDataForBarcode(barcode);

    // Create and configure the header section of the annotation
    final header = BarcodeCheckInfoAnnotationHeader()
      ..backgroundColor = discount.color
      ..text = discount.percentage;

    // Create and configure the body section of the annotation
    final bodyComponent = BarcodeCheckInfoAnnotationBodyComponent()..text = discount.getDisplayText(true);

    // Create the annotation itself and attach the header and body
    final annotation = BarcodeCheckInfoAnnotation(barcode)
      ..header = header
      ..body = [bodyComponent]
      ..width = BarcodeCheckInfoAnnotationWidthPreset.large
      ..backgroundColor = Color(0xE6FFFFFF)
      ..isEntireAnnotationTappable = true
      ..listener = this;

    return annotation;
  }

  Future<BarcodeCheckHighlight> highlightForBarcode(Barcode barcode) async {
    // Returns a circular dot highlight that will be displayed over each detected barcode
    final highlight = BarcodeCheckCircleHighlight(barcode, BarcodeCheckCircleHighlightPreset.dot)
      ..brush = Brush(Colors.white, Colors.white, 1.0);
    return highlight;
  }

  @override
  void didTapInfoAnnotation(BarcodeCheckInfoAnnotation annotation) {
    final discount = _discountDataProvider.getDataForBarcode(annotation.barcode);
    annotation.body.first.text = discount.getDisplayText(false);
  }

  @override
  void didTapInfoAnnotationFooter(BarcodeCheckInfoAnnotation annotation) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationHeader(BarcodeCheckInfoAnnotation annotation) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationLeftIcon(BarcodeCheckInfoAnnotation annotation, int componentIndex) {
    // Not relevant for this sample
  }

  @override
  void didTapInfoAnnotationRightIcon(BarcodeCheckInfoAnnotation annotation, int componentIndex) {
    // Not relevant for this sample
  }
}
