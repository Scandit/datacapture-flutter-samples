/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:LabelCaptureSimpleSample/features/label_capture/domain/entities/scanned_result.dart';

abstract class LabelCaptureState {
  const LabelCaptureState();
}

class LabelCaptureInitial extends LabelCaptureState {
  const LabelCaptureInitial();
}

class LabelCaptureLoading extends LabelCaptureState {
  const LabelCaptureLoading();
}

class LabelCaptureScanning extends LabelCaptureState {
  const LabelCaptureScanning();
}

class LabelCapturePaused extends LabelCaptureState {
  const LabelCapturePaused();
}

class LabelCaptureStopped extends LabelCaptureState {
  const LabelCaptureStopped();
}

class LabelCaptureResultCaptured extends LabelCaptureState {
  final ScannedResult result;

  const LabelCaptureResultCaptured(this.result);
}

class LabelCaptureError extends LabelCaptureState {
  final String message;

  const LabelCaptureError(this.message);
}

class LabelCapturePermissionDenied extends LabelCaptureState {
  const LabelCapturePermissionDenied();
}
