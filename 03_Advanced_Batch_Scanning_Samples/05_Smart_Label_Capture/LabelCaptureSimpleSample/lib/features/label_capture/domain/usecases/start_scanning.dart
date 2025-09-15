/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:LabelCaptureSimpleSample/features/label_capture/domain/repositories/label_capture_repository.dart';

class StartScanning {
  final LabelCaptureRepository repository;

  StartScanning(this.repository);

  Future<void> call() async {
    await repository.startScanning();
  }
}
