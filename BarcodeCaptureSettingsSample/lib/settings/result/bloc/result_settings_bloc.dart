/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';

class ResultSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  bool get continuousScan {
    return _settings.continuousScan;
  }

  set continuousScan(bool newValue) {
    _settings.continuousScan = newValue;
  }
}
