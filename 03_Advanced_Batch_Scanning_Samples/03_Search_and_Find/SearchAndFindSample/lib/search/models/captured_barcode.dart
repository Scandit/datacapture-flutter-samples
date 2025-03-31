/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

@immutable
class CapturedBarcode {
  final Symbology _symbology;
  final String _data;

  CapturedBarcode(this._symbology, this._data);

  Symbology get symbology => _symbology;

  String get data => _data;
}
