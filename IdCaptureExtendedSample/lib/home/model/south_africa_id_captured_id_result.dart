/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class SouthAfricaIdCapturedIdResult extends CapturedIdResult {
  late SouthAfricaIdBarcodeResult _southAfricaIdResult;

  SouthAfricaIdCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _southAfricaIdResult = capturedId.southAfricaIdBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Personal Id Number', parseStringValue(_southAfricaIdResult.personalIdNumber)));
    result.add(ResultEntry('Citizenship Status', parseStringValue(_southAfricaIdResult.citizenshipStatus)));
    result.add(ResultEntry('Country of Birth', parseStringValue(_southAfricaIdResult.countryOfBirth)));
    result.add(ResultEntry('Country of Birth ISO', parseStringValue(_southAfricaIdResult.countryOfBirthIso)));

    return result;
  }
}
