/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:LabelCaptureSimpleSample/features/label_capture/domain/entities/scanned_result.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/repositories/label_capture_repository.dart';

class GetScanResults {
  final LabelCaptureRepository repository;

  GetScanResults(this.repository);

  Stream<ScannedResult> call() {
    return repository.scanResults;
  }
}
