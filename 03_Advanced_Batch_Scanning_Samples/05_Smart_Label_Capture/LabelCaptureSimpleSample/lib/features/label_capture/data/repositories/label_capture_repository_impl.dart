/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:permission_handler/permission_handler.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/entities/scanned_result.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/repositories/label_capture_repository.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/data/datasources/label_capture_data_source.dart';
import 'package:LabelCaptureSimpleSample/core/error/failures.dart';

class LabelCaptureRepositoryImpl implements LabelCaptureRepository {
  final LabelCaptureDataSource dataSource;

  LabelCaptureRepositoryImpl({required this.dataSource});

  @override
  Future<void> startScanning() async {
    try {
      await dataSource.startScanning();
    } catch (e) {
      throw LabelCaptureFailure(e.toString());
    }
  }

  @override
  Future<void> stopScanning() async {
    try {
      await dataSource.stopScanning();
    } catch (e) {
      throw LabelCaptureFailure(e.toString());
    }
  }

  @override
  Future<void> pauseScanning() async {
    try {
      await dataSource.pauseScanning();
    } catch (e) {
      throw LabelCaptureFailure(e.toString());
    }
  }

  @override
  Future<void> resumeScanning() async {
    try {
      await dataSource.resumeScanning();
    } catch (e) {
      throw LabelCaptureFailure(e.toString());
    }
  }

  @override
  Stream<ScannedResult> get scanResults {
    return dataSource.scanResults;
  }

  @override
  Future<bool> hasCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw const PermissionFailure('Camera permission denied');
    }
  }
}
