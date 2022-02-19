/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class MrzCapturedIdResult extends CapturedIdResult {
  late MrzResult _mrzResult;

  MrzCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _mrzResult = capturedId.mrz!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Document Code', parseStringValue(_mrzResult.documentCode)));
    result.add(ResultEntry('Names Are Truncated', parseStringValue(_mrzResult.namesAreTruncated.toString())));
    result.add(ResultEntry('Optional', parseStringValue(_mrzResult.optional)));
    result.add(ResultEntry('Optional1', parseStringValue(_mrzResult.optional1)));

    return result;
  }
}
