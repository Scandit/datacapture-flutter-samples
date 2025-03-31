/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class ScanResult {
  final Symbology symbology;
  final String data;

  ScanResult(this.symbology, this.data);
}
