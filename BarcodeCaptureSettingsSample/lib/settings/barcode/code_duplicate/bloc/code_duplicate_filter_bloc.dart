/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';

class CodeDuplicateFilterBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  int get codeDuplicateFilter {
    return _settings.codeDuplicateFilter;
  }

  set codeDuplicateFilter(int newValue) {
    _settings.codeDuplicateFilter = newValue;
  }
}
