/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/model/symbology_item.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class SymbologiesSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  Iterable<SymbologyItem> get symbologies {
    return Symbology.values.map((symbology) => SymbologyItem(symbology, _settings.isSymbologyEnabled(symbology)));
  }

  void enableAll() {
    _settings.enableSymbologies(Symbology.values);
  }

  void disableAll() {
    Symbology.values.forEach((symbology) {
      _settings.enableSymbology(symbology, false);
    });
  }
}
