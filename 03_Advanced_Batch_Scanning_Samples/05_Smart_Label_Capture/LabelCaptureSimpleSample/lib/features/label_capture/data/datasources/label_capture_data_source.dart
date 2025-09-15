/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';
import 'package:LabelCaptureSimpleSample/core/utils/constants.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/entities/scanned_result.dart';

abstract class LabelCaptureDataSource {
  Future<void> initialize();
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<void> pauseScanning();
  Future<void> resumeScanning();
  Stream<ScannedResult> get scanResults;
  DataCaptureContext get dataCaptureContext;
  LabelCaptureBasicOverlay buildLabelCaptureOverlay(BuildContext context);
  LabelCaptureValidationFlowOverlay buildValidationFlowOverlay(BuildContext context);
  void dispose();
}

class LabelCaptureDataSourceImpl implements LabelCaptureDataSource {
  late Camera _camera;
  late LabelCapture _labelCapture;
  late StreamController<ScannedResult> _scanResultsController;

  @override
  Stream<ScannedResult> get scanResults => _scanResultsController.stream;

  @override
  DataCaptureContext get dataCaptureContext => DataCaptureContext.sharedInstance;

  @override
  Future<void> initialize() async {
    _scanResultsController = StreamController<ScannedResult>.broadcast();

    // Create camera with label capture recommended settings
    _camera = Camera.defaultCamera!;
    _camera.applySettings(LabelCapture.recommendedCameraSettings);

    await dataCaptureContext.setFrameSource(_camera);

    // Create label capture with settings
    _labelCapture = LabelCapture(_buildLabelCaptureSettings());

    // Set the label capture mode as the current mode of the data capture context.
    await dataCaptureContext.setMode(_labelCapture);
  }

  @override
  Future<void> startScanning() async {
    await _camera.switchToDesiredState(FrameSourceState.on);
    _labelCapture.isEnabled = true;
  }

  @override
  Future<void> stopScanning() async {
    _labelCapture.isEnabled = false;
    await _camera.switchToDesiredState(FrameSourceState.off);
  }

  @override
  Future<void> pauseScanning() async {
    _labelCapture.isEnabled = false;
    await _camera.switchToDesiredState(FrameSourceState.off);
  }

  @override
  Future<void> resumeScanning() async {
    await _camera.switchToDesiredState(FrameSourceState.on);
    _labelCapture.isEnabled = true;
  }

  @override
  LabelCaptureBasicOverlay buildLabelCaptureOverlay(BuildContext context) {
    return LabelCaptureBasicOverlay(_labelCapture)..listener = _BasicOverlayListener(context);
  }

  @override
  LabelCaptureValidationFlowOverlay buildValidationFlowOverlay(BuildContext context) {
    final settings = LabelCaptureValidationFlowSettings.create();

    final overlay = LabelCaptureValidationFlowOverlay(_labelCapture);
    overlay.listener = _ValidationFlowListener(_scanResultsController);
    overlay.applySettings(settings);
    return overlay;
  }

  LabelCaptureSettings _buildLabelCaptureSettings() {
    // Create a custom barcode field for the main barcode
    final customBarcode = CustomBarcodeBuilder()
        .setSymbologies([
          Symbology.ean13Upca,
          Symbology.gs1DatabarExpanded,
          Symbology.code128,
        ])
        .isOptional(false)
        .build(Constants.fieldBarcode);

    // Create an expiry date text field with MDY format
    final expiryDateText = ExpiryDateTextBuilder()
        .setLabelDateFormat(LabelDateFormat(
          LabelDateComponentFormat.mdy,
          false, // acceptPartialDates = false
        ))
        .isOptional(true)
        .build(Constants.fieldExpiryDate);

    // Create unit price text field
    final unitPriceText = UnitPriceTextBuilder().isOptional(true).build(Constants.fieldUnitPrice);

    // Create weight text field
    final weightText = WeightTextBuilder().isOptional(true).build(Constants.fieldWeight);

    // Build the label definition with all fields
    final labelDefinition = LabelDefinitionBuilder()
        .addCustomBarcode(customBarcode)
        .addExpiryDateText(expiryDateText)
        .addUnitPriceText(unitPriceText)
        .addWeightText(weightText)
        .build(Constants.labelWeightPrice);

    // Create and return the label capture settings
    var settings = LabelCaptureSettings([labelDefinition]);

    // You can customize the label definition to adapt it to your use-case.
    // For example, you can use the following label definition for Smart Devices box Scanning.
    // final labelDefinition = LabelDefinitionBuilder()
    //     .addCustomBarcode(
    //       CustomBarcodeBuilder().setSymbology(Symbology.ean13Upca).isOptional(false).build('barcode'),
    //     )
    //     .addImeiOneBarcode(
    //       ImeiOneBarcodeBuilder().isOptional(true).build('imei_one'),
    //     )
    //     .addImeiTwoBarcode(
    //       ImeiTwoBarcodeBuilder().isOptional(true).build('imei_two'),
    //     )
    //     .addSerialNumberBarcode(
    //       SerialNumberBarcodeBuilder().isOptional(true).build('serial'),
    //     )
    //     .build('imei_label');
    // return LabelCaptureSettings([labelDefinition]);

    return settings;
  }

  @override
  void dispose() {
    _scanResultsController.close();
    _labelCapture.isEnabled = false;
    _camera.switchToDesiredState(FrameSourceState.off);
    dataCaptureContext.removeCurrentMode();
  }
}

class _BasicOverlayListener implements LabelCaptureBasicOverlayListener {
  final BuildContext context;

  _BasicOverlayListener(this.context);

  Color hexToColor(String hex) {
    // Remove the hash if present
    hex = hex.replaceAll('#', '');

    // Add alpha channel if not present (make it fully opaque)
    if (hex.length == 6) {
      hex = 'FF$hex';
    }

    return Color(int.parse(hex, radix: 16));
  }

  static const upcBrushColor = Color(0xFF2EC1CE);
  static const expiryDateBrushColor = Color(0xFFFA4446);
  static const weightBrushColor = Color(0xFFFBC02C);
  static const unitPriceBrushColor = Color(0xFF0A3390);

  final upcBrush = Brush(upcBrushColor.withAlpha(128), upcBrushColor, 1.0);
  final expiryDateBrush = Brush(expiryDateBrushColor.withAlpha(128), expiryDateBrushColor, 1.0);
  final weightBrush = Brush(weightBrushColor.withAlpha(128), weightBrushColor, 1.0);
  final unitPriceBrush = Brush(unitPriceBrushColor.withAlpha(128), unitPriceBrushColor, 1.0);

  @override
  Future<Brush?> brushForFieldOfLabel(LabelCaptureBasicOverlay overlay, LabelField field, CapturedLabel label) async {
    switch (field.name) {
      case Constants.fieldBarcode:
        return upcBrush;
      case Constants.fieldExpiryDate:
        return expiryDateBrush;
      case Constants.fieldWeight:
        return weightBrush;
      case Constants.fieldUnitPrice:
        return unitPriceBrush;
      default:
        return null;
    }
  }

  @override
  Future<Brush?> brushForLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label) async {
    return Brush(Colors.transparent, Colors.transparent, 0.0);
  }

  @override
  void didTapLabel(LabelCaptureBasicOverlay overlay, CapturedLabel label) {
    // Handle label tap if needed
  }
}

class _ValidationFlowListener implements LabelCaptureValidationFlowListener {
  final StreamController<ScannedResult> _scanResultsController;

  _ValidationFlowListener(this._scanResultsController);

  @override
  void didCaptureLabelWithFields(List<LabelField> fields) {
    final data = <String, String>{};

    for (final field in fields) {
      final date = field.asDate();
      if (date != null) {
        data[field.name] = _formatDateResult(date);
      } else {
        final fieldData = field.barcode?.data ?? field.text;
        if (fieldData != null && fieldData.isNotEmpty) {
          data[field.name] = fieldData;
        }
      }
    }
    _scanResultsController.add(ScannedResult(data: data));
  }

  String _formatDateResult(LabelDateResult date) {
    final calendar = DateTime(date.year!, date.month!, date.day!);
    return '${calendar.day} - ${calendar.month} - ${calendar.year}';
  }
}
