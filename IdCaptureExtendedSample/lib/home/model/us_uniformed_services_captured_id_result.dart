/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class UsUniformedServicesCapturedIdResult extends CapturedIdResult {
  late UsUniformedServicesBarcodeResult _usUniformedServicesResult;

  UsUniformedServicesCapturedIdResult(CapturedId capturedId) : super(capturedId) {
    _usUniformedServicesResult = capturedId.usUniformedServicesBarcode!;
  }

  @override
  List<ResultEntry> getResult() {
    var result = super.getResult();
    result.add(ResultEntry('Height', parseIntValue(_usUniformedServicesResult.height)));
    result.add(ResultEntry('Weight', parseIntValue(_usUniformedServicesResult.weight)));
    result.add(ResultEntry('Blood Type', parseStringValue(_usUniformedServicesResult.bloodType)));
    result.add(ResultEntry('Eye Color', parseStringValue(_usUniformedServicesResult.eyeColor)));
    result.add(ResultEntry('Hair Color', parseStringValue(_usUniformedServicesResult.hairColor)));
    result.add(ResultEntry('Relationship Code', parseStringValue(_usUniformedServicesResult.relationshipCode)));
    result.add(
        ResultEntry('Relationship Description', parseStringValue(_usUniformedServicesResult.relationshipDescription)));
    result.add(ResultEntry('Branch of Service', parseStringValue(_usUniformedServicesResult.branchOfService)));
    result.add(ResultEntry('Champus Effective Date', parseDateValue(_usUniformedServicesResult.champusEffectiveDate)));
    result.add(ResultEntry('Champus Expiry Date', parseDateValue(_usUniformedServicesResult.champusExpiryDate)));
    result.add(ResultEntry('Civilian Healthcare Flag Code',
        parseStringValue(_usUniformedServicesResult.civilianHealthCareFlagDescription)));
    result.add(ResultEntry('Civilian Healthcare Flag Description',
        parseStringValue(_usUniformedServicesResult.civilianHealthCareFlagDescription)));
    result.add(
        ResultEntry('Deers Dependent Suffix Code', parseIntValue(_usUniformedServicesResult.deersDependentSuffixCode)));
    result.add(ResultEntry('Deers Dependent Suffix Description',
        parseStringValue(_usUniformedServicesResult.deersDependentSuffixDescription)));
    result.add(ResultEntry('Direct Care Flag Code', parseStringValue(_usUniformedServicesResult.directCareFlagCode)));
    result.add(ResultEntry(
        'Direct Care Flag Description', parseStringValue(_usUniformedServicesResult.directCareFlagDescription)));
    result.add(ResultEntry('Family Sequence Number', parseIntValue(_usUniformedServicesResult.familySequenceNumber)));
    result.add(ResultEntry(
        'Geneva Convention Category', parseStringValue(_usUniformedServicesResult.genevaConventionCategory)));
    result.add(ResultEntry('Mwr Flag Code', parseStringValue(_usUniformedServicesResult.mwrFlagCode)));
    result.add(ResultEntry('Mwr Flag Description', parseStringValue(_usUniformedServicesResult.mwrFlagDescription)));
    result.add(ResultEntry('Form Number', parseStringValue(_usUniformedServicesResult.formNumber)));
    result.add(ResultEntry('Status Code', parseStringValue(_usUniformedServicesResult.statusCode)));
    result.add(
        ResultEntry('Status Code Description', parseStringValue(_usUniformedServicesResult.statusCodeDescription)));
    result.add(ResultEntry('Rank', _usUniformedServicesResult.rank));
    result.add(ResultEntry('Pay Grade', parseStringValue(_usUniformedServicesResult.payGrade)));
    result.add(
        ResultEntry('Person Designator Document', parseIntValue(_usUniformedServicesResult.personDesignatorDocument)));
    result.add(ResultEntry('Sponsor Name', parseStringValue(_usUniformedServicesResult.sponsorName)));
    result.add(ResultEntry('Sponsor Flag', parseStringValue(_usUniformedServicesResult.sponsorFlag)));
    result.add(ResultEntry('Sponsor Person Designator Identifier',
        parseIntValue(_usUniformedServicesResult.sponsorPersonDesignatorIdentifier)));
    result.add(ResultEntry('Security Code', parseStringValue(_usUniformedServicesResult.securityCode)));
    result.add(ResultEntry('Service Code', parseStringValue(_usUniformedServicesResult.serviceCode)));
    result.add(ResultEntry('Exchange Flag Code', parseStringValue(_usUniformedServicesResult.exchangeFlagCode)));
    result.add(
        ResultEntry('Exchange Flag Description', parseStringValue(_usUniformedServicesResult.exchangeFlagDescription)));
    result.add(ResultEntry('Commissary Flag Code', parseStringValue(_usUniformedServicesResult.commissaryFlagCode)));
    result.add(ResultEntry(
        'Commissary Flag Description', parseStringValue(_usUniformedServicesResult.commissaryFlagDescription)));
    result.add(ResultEntry('Version', parseIntValue(_usUniformedServicesResult.version)));

    return result;
  }
}
