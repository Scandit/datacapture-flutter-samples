/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';

class SingleBarcodeAutoDetectionSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  bool get singleBarcodeAutoDetection {
    return _settings.singleBarcodeAutoDetection;
  }

  set singleBarcodeAutoDetection(bool newValue) {
    _settings.singleBarcodeAutoDetection = newValue;
  }
}
