/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum IdCaptureMode { barcode, mrz, viz }

extension IdCaptureModeNamePretty on IdCaptureMode {
  String get name {
    switch (this) {
      case IdCaptureMode.barcode:
        return "Barcode";
      case IdCaptureMode.mrz:
        return "MRZ";
      case IdCaptureMode.viz:
        return "VIZ";
      default:
        return toString().split('.').last;
    }
  }
}
