/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';

class FeedbackSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  bool get isSoundOn {
    return _settings.isSoundOn;
  }

  set isSoundOn(bool newValue) {
    _settings.isSoundOn = newValue;
  }

  bool get isVibrationOn {
    return _settings.isVibrationOn;
  }

  set isVibrationOn(bool newValue) {
    _settings.isVibrationOn = newValue;
  }
}
