/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// Publish (standalone) variant of the sample entry contract, written by
// scripts/generate-samples.py. It replaces the DebugApp's no-op variant with
// the real SDK/license initialization, using the license placeholder below.

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

Future<void> ensureSampleDataCaptureContext() async {
  await DataCaptureContext.initialize('-- ENTER YOUR SCANDIT LICENSE KEY HERE --');
}

String sampleAssetPath(String relativePath) => relativePath;
