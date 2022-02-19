/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class SouthAfricaDlCapturedIdResult extends CapturedIdResult {
  late SouthAfricaDlBarcodeResult _southAfricaDlResult;

  SouthAfricaDlCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _southAfricaDlResult = capturedId.southAfricaDlBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Personal Id Number', parseStringValue(_southAfricaDlResult.personalIdNumber)));
    result.add(ResultEntry('Personal Id Number Type', parseStringValue(_southAfricaDlResult.personalIdNumberType)));
    result.add(ResultEntry('Document Copy', parseIntValue(_southAfricaDlResult.documentCopy)));
    result.add(ResultEntry('License Country of Issue', parseStringValue(_southAfricaDlResult.licenseCountryOfIssue)));
    result
        .add(ResultEntry('Driver Restriction Codes', parseListOfIntValue(_southAfricaDlResult.driverRestrictionCodes)));
    result.add(ResultEntry('Professional Driving Permit',
        parseProfessionalDrivingPermitValue(_southAfricaDlResult.professionalDrivingPermit)));
    result.add(
        ResultEntry('Vehicle Restrictions', parseVehicleRestrictionValue(_southAfricaDlResult.vehicleRestrictions)));
    result.add(ResultEntry('Version', parseIntValue(_southAfricaDlResult.version)));

    return result;
  }

  String parseListOfIntValue(List<int> value) {
    if (value.isEmpty) {
      return '<empty>';
    }
    return value.join(',');
  }

  String parseProfessionalDrivingPermitValue(ProfessionalDrivingPermit? value) {
    if (value == null) {
      return '<empty>';
    }
    return 'Codes: ${value.codes.join(',')} \nDate of Expiry: ${parseDateValue(value.dateOfExpiry)}';
  }

  String parseVehicleRestrictionValue(List<VehicleRestriction> value) {
    if (value.isEmpty) {
      return '<empty>';
    }
    String result = '';
    for (var vh in value) {
      result += 'Vehicle Code: ${parseStringValue(vh.vehicleCode)}\n';
      result += 'Vehicle Restriction: ${parseStringValue(vh.vehicleRestriction)}\n';
      result += 'Date of Issue: ${parseDateValue(vh.dateOfIssue)}\n';
    }

    return result;
  }
}
