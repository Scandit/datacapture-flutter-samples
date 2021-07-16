/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';

class LaserlineStyleItem {
  final LaserlineViewfinderStyle style;

  LaserlineStyleItem(this.style);

  String get displayName {
    return style.name;
  }
}
