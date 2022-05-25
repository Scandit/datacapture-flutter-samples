/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';

class CodeDuplicateFilterSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  double get codeDuplicateFilter {
    return _settings.codeDuplicateFilter / 1000;
  }

  set codeDuplicateFilter(double newValue) {
    _settings.codeDuplicateFilter = (newValue * 1000).toInt();
  }
}
