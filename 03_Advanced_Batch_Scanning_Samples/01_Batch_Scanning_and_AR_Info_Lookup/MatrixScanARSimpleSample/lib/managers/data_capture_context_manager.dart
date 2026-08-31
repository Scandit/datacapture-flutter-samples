/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../sample_bootstrap.dart';

class DataCaptureContextManager {
  DataCaptureContextManager._privateConstructor();

  static final DataCaptureContextManager _instance = DataCaptureContextManager._privateConstructor();

  factory DataCaptureContextManager() {
    return _instance;
  }

  late DataCaptureContext _dataCaptureContext;

  final Camera _camera = Camera.defaultCamera!;

  Future<void> initialize() async {
    await ensureSampleDataCaptureContext();
    _dataCaptureContext = DataCaptureContext.sharedInstance;

    // Set the camera as the frame source.
    _dataCaptureContext.setFrameSource(_camera);
  }

  DataCaptureContext get dataCaptureContext => _dataCaptureContext;

  Camera get camera => _camera;
}
