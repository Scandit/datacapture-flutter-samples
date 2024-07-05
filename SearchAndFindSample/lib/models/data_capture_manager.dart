/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class DataCaptureManager {
  static final DataCaptureManager _singleton = DataCaptureManager._internal();

  factory DataCaptureManager() {
    return _singleton;
  }

  late DataCaptureContext _captureContext;

  DataCaptureContext get dataCaptureContext => _captureContext;

  Camera? _camera = Camera.defaultCamera;

  Camera? get camera => _camera;

  DataCaptureManager._internal() {
    _captureContext = DataCaptureContext.forLicenseKey(licenseKey);

    setCamera();
  }

  void setCamera() {
    if (camera != null) {
      _captureContext.setFrameSource(camera!);
    }
  }
}
