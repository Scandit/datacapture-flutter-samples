/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

@immutable
class BarcodeToFind {
  final Symbology _symbology;
  final String _data;

  BarcodeToFind(this._symbology, this._data);

  Symbology get symbology => _symbology;

  String get data => _data;
}
