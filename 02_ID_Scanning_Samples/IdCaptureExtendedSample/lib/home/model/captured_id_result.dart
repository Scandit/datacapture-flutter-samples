/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class CapturedIdResult {
  final CapturedId _capturedId;

  CapturedIdResult(this._capturedId);

  List<ResultEntry> getResult() {
    return [
      ResultEntry('Full Name', _capturedId.fullName),
      ResultEntry('Date of Birth', parseDateValue(_capturedId.dateOfBirth)),
      ResultEntry('Date of Expiry', parseDateValue(_capturedId.dateOfExpiry)),
      ResultEntry('Document Number', parseStringValue(_capturedId.documentNumber)),
      ResultEntry('Nationality', parseStringValue(_capturedId.nationality)),
    ];
  }

  Image? get faceImage {
    return _capturedId.images.face;
  }

  Image? get croppedDocument {
    return _capturedId.images.getCroppedDocument(IdSide.front);
  }

  String parseStringValue(String? value) {
    if (value == null || value.isEmpty) {
      return '<empty>';
    }
    return value;
  }

  String parseDateValue(DateResult? value) {
    if (value == null) {
      return '<empty>';
    }
    return '${value.year}-${value.month}-${value.day}';
  }

  String parseIntValue(int? value) {
    if (value == null) {
      return '<empty>';
    }
    return value.toString();
  }
}

class ResultEntry {
  String _key;
  String _value;

  ResultEntry(this._key, this._value);

  String get key {
    return _key;
  }

  String get value {
    return _value;
  }
}
