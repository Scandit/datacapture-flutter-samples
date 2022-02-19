/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class VizCapturedIdResult extends CapturedIdResult {
  late VizResult _vizResult;

  VizCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _vizResult = capturedId.viz!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Issuing Authority', parseStringValue(_vizResult.issuingAuthority)));
    result.add(ResultEntry('Issuing Jurisdiction', parseStringValue(_vizResult.issuingJurisdiction)));
    result.add(ResultEntry('Additional Name Information', parseStringValue(_vizResult.additionalNameInformation)));
    result
        .add(ResultEntry('Additional Address Information', parseStringValue(_vizResult.additionalAddressInformation)));
    result.add(ResultEntry('Place of Birth', parseStringValue(_vizResult.placeOfBirth)));
    result.add(ResultEntry('Race', parseStringValue(_vizResult.race)));
    result.add(ResultEntry('Religion', parseStringValue(_vizResult.religion)));
    result.add(ResultEntry('Profession', parseStringValue(_vizResult.profession)));
    result.add(ResultEntry('Marital Status', parseStringValue(_vizResult.maritalStatus)));
    result.add(ResultEntry('Residential Status', parseStringValue(_vizResult.residentialStatus)));
    result.add(ResultEntry('Employer', parseStringValue(_vizResult.employer)));
    result.add(ResultEntry('Personal Id Number', parseStringValue(_vizResult.personalIdNumber)));
    result.add(ResultEntry('Document Additional Number', parseStringValue(_vizResult.documentAdditionalNumber)));

    return result;
  }
}
