/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:math';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

extension Size on Quadrilateral {
  double width() {
    return max((topRight.x - topLeft.x).abs(), (bottomRight.x - bottomLeft.x).abs());
  }
}
