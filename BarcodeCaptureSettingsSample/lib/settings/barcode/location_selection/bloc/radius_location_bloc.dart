/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:scandit_flutter_datacapture_core/src/common.dart';

class RadiusLocationSelectionSizeBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  RadiusLocationSelectionSizeBloc() : super("Size");

  @override
  MeasureUnit get measureUnit {
    return _settings.radiusLocationSelectionUnit;
  }

  @override
  set measureUnit(MeasureUnit newValue) {
    _settings.radiusLocationSelectionUnit = newValue;
  }

  @override
  double get value {
    return _settings.radiusLocationSelectionValue;
  }

  @override
  set value(double newValue) {
    _settings.radiusLocationSelectionValue = newValue;
  }
}
