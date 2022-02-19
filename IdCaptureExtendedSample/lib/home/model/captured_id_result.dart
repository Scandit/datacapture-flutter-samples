/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

abstract class CapturedIdResult {
  final CapturedId _capturedId;

  CapturedIdResult(this._capturedId);

  List<ResultEntry> getResult() {
    return [
      ResultEntry('Result Type', _capturedId.capturedResultType.name),
      ResultEntry('Document Type', _capturedId.documentType.name),
      ResultEntry('First Name', parseStringValue(_capturedId.firstName)),
      ResultEntry('Last Name', parseStringValue(_capturedId.lastName)),
      ResultEntry('Full Name', _capturedId.fullName),
      ResultEntry('Sex', parseStringValue(_capturedId.sex)),
      ResultEntry('Date of Birth', parseDateValue(_capturedId.dateOfBirth)),
      ResultEntry('Nationality', parseStringValue(_capturedId.nationality)),
      ResultEntry('Address', parseStringValue(_capturedId.address)),
      ResultEntry('Issuing Country ISO', parseStringValue(_capturedId.issuingCountryIso)),
      ResultEntry('Issuing Country', parseStringValue(_capturedId.issuingCountry)),
      ResultEntry('Document Number', parseStringValue(_capturedId.documentNumber)),
      ResultEntry('Date of Expiry', parseDateValue(_capturedId.dateOfExpiry)),
      ResultEntry('Date of Issue', parseDateValue(_capturedId.dateOfIssue)),
    ];
  }

  Image? get faceImage {
    return _capturedId.getImageForType(IdImageType.face);
  }

  Image? get idFrontImage {
    return _capturedId.getImageForType(IdImageType.idFront);
  }

  Image? get idBackImage {
    return _capturedId.getImageForType(IdImageType.idBack);
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

extension CapturedResultTypeDisplay on CapturedResultType {
  String get name {
    var enumName = toString().split('.').last;

    return "${enumName[0].toUpperCase()}${enumName.substring(1)}";
  }
}

extension DocumentTypeDisplay on DocumentType {
  String get name {
    var enumName = toString().split('.').last;

    return "${enumName[0].toUpperCase()}${enumName.substring(1)}";
  }
}
