/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class ArgentinaIdCapturedIdResult extends CapturedIdResult {
  late ArgentinaIdBarcodeResult _argentinaIdResult;

  ArgentinaIdCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _argentinaIdResult = capturedId.argentinaIdBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Document Copy', parseStringValue(_argentinaIdResult.documentCopy)));
    result.add(ResultEntry('Personal Id Number', parseStringValue(_argentinaIdResult.personalIdNumber)));

    return result;
  }
}
