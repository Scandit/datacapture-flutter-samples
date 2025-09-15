/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:LabelCaptureSimpleSample/features/label_capture/domain/entities/scanned_result.dart';

abstract class LabelCaptureRepository {
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<void> pauseScanning();
  Future<void> resumeScanning();
  Stream<ScannedResult> get scanResults;
  Future<bool> hasCameraPermission();
  Future<void> requestCameraPermission();
}
