/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class AamvaCapturedIdResult extends CapturedIdResult {
  late AamvaBarcodeResult _aamvaResult;

  AamvaCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _aamvaResult = capturedId.aamvaBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('AAMVA Version', parseIntValue(_aamvaResult.aamvaVersion)));
    result.add(ResultEntry('Jurisdiction Version', parseIntValue(_aamvaResult.jurisdictionVersion)));
    result.add(ResultEntry('IIN', parseStringValue(_aamvaResult.iIN)));
    result.add(ResultEntry('Issuing Jurisdiction', parseStringValue(_aamvaResult.issuingJurisdiction)));
    result.add(ResultEntry('Issuing Jurisdiction ISO', parseStringValue(_aamvaResult.issuingJurisdictionIso)));
    result.add(ResultEntry('Eye Color', parseStringValue(_aamvaResult.eyeColor)));
    result.add(ResultEntry('Hair Color', parseStringValue(_aamvaResult.hairColor)));
    result.add(ResultEntry('Height (inch)', parseIntValue(_aamvaResult.heightInch)));
    result.add(ResultEntry('Height (cm)', parseIntValue(_aamvaResult.heightCm)));
    result.add(ResultEntry('Weight (lbs)', parseIntValue(_aamvaResult.weightLbs)));
    result.add(ResultEntry('Weight (kg)', parseIntValue(_aamvaResult.weightKg)));
    result.add(ResultEntry('Place Of Birth', parseStringValue(_aamvaResult.placeOfBirth)));
    result.add(ResultEntry('Race', parseStringValue(_aamvaResult.race)));
    result
        .add(ResultEntry('Document Discriminator Number', parseStringValue(_aamvaResult.documentDiscriminatorNumber)));
    result.add(ResultEntry('Vehicle Class', parseStringValue(_aamvaResult.vehicleClass)));
    result.add(ResultEntry('Restrictions Code', parseStringValue(_aamvaResult.restrictionsCode)));
    result.add(ResultEntry('Endorsements Code', parseStringValue(_aamvaResult.endorsementsCode)));
    result.add(ResultEntry('Card Revision Date', parseDateValue(_aamvaResult.cardRevisionDate)));
    result.add(ResultEntry('Middle Name', parseStringValue(_aamvaResult.middleName)));
    result.add(ResultEntry('Driver Name Suffix', parseStringValue(_aamvaResult.driverNameSuffix)));
    result.add(ResultEntry('Driver Name Prefix', parseStringValue(_aamvaResult.driverNamePrefix)));
    result.add(ResultEntry('Last Name Truncation', parseStringValue(_aamvaResult.lastNameTruncation)));
    result.add(ResultEntry('First Name Truncation', parseStringValue(_aamvaResult.firstNameTruncation)));
    result.add(ResultEntry('Middle Name Truncation', parseStringValue(_aamvaResult.middleNameTruncation)));
    result.add(ResultEntry('Alias Family Name', parseStringValue(_aamvaResult.aliasFamilyName)));
    result.add(ResultEntry('Alias Given Name', parseStringValue(_aamvaResult.aliasGivenName)));
    result.add(ResultEntry('Alias Suffix Name', parseStringValue(_aamvaResult.aliasSuffixName)));

    return result;
  }
}
