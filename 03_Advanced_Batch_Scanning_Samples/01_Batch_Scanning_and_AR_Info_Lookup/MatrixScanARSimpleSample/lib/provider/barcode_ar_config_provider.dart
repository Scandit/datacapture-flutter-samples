/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../managers/data_capture_context_manager.dart';

/// Shared provider for common BarcodeAR configuration and lifecycle management.
///
/// This provider eliminates duplication across feature BLoCs by centralizing:
/// - DataCaptureContext management
/// - Camera settings configuration
/// - BarcodeAr settings and symbologies
/// - Common lifecycle methods (start/stop capturing)
class BarcodeArConfigProvider {
  static final BarcodeArConfigProvider _instance = BarcodeArConfigProvider._internal();

  factory BarcodeArConfigProvider() => _instance;

  BarcodeArConfigProvider._internal();

  final DataCaptureContextManager _dcManager = DataCaptureContextManager();

  /// Access to the shared DataCaptureContext
  DataCaptureContext get dataCaptureContext => _dcManager.dataCaptureContext;

  /// Access to the camera instance
  Camera get camera => _dcManager.camera;

  /// Creates BarcodeArViewSettings with default configuration
  BarcodeArViewSettings createViewSettings() {
    return BarcodeArViewSettings();
  }

  /// Creates recommended camera settings for BarcodeAR
  CameraSettings createCameraSettings() {
    return BarcodeAr.createRecommendedCameraSettings();
  }

  /// Creates a BarcodeAr instance with commonly used symbologies
  ///
  /// Enables: EAN13/UPCA, EAN8, UPCE, Code39, Code128, QR, DataMatrix
  BarcodeAr createBarcodeAr() {
    var settings = BarcodeArSettings()
      ..enableSymbologies({
        Symbology.ean13Upca,
        Symbology.ean8,
        Symbology.upce,
        Symbology.code39,
        Symbology.code128,
        Symbology.qr,
        Symbology.dataMatrix,
      });

    return BarcodeAr(settings);
  }

  /// Starts camera capture
  void startCapturing() {
    camera.switchToDesiredState(FrameSourceState.on);
  }

  /// Stops camera capture
  void stopCapturing() {
    camera.switchToDesiredState(FrameSourceState.off);
  }
}
