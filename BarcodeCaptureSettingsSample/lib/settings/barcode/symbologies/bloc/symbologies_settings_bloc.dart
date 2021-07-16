/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/symbologies/model/symbology_item.dart';
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
