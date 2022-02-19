/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class ColombiaIdCapturedIdResult extends CapturedIdResult {
  late ColombiaIdBarcodeResult _colombiaIdResult;

  ColombiaIdCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _colombiaIdResult = capturedId.colombiaIdBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Blood Type', parseStringValue(_colombiaIdResult.bloodType)));

    return result;
  }
}
