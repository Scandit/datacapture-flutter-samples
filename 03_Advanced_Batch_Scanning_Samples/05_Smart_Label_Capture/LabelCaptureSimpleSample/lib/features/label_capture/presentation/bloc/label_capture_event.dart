/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

abstract class LabelCaptureEvent {
  const LabelCaptureEvent();
}

class LabelCaptureInitialize extends LabelCaptureEvent {
  const LabelCaptureInitialize();
}

class LabelCaptureStartScanning extends LabelCaptureEvent {
  const LabelCaptureStartScanning();
}

class LabelCaptureStopScanning extends LabelCaptureEvent {
  const LabelCaptureStopScanning();
}

class LabelCapturePauseScanning extends LabelCaptureEvent {
  const LabelCapturePauseScanning();
}

class LabelCaptureResumeScanning extends LabelCaptureEvent {
  const LabelCaptureResumeScanning();
}

class LabelCaptureRequestPermission extends LabelCaptureEvent {
  const LabelCaptureRequestPermission();
}

class LabelCaptureResultDialogDismissed extends LabelCaptureEvent {
  const LabelCaptureResultDialogDismissed();
}

class LabelCaptureResultReceived extends LabelCaptureEvent {
  final dynamic result;

  const LabelCaptureResultReceived(this.result);
}
