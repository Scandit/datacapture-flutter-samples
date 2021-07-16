/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:scandit_flutter_datacapture_core/src/common.dart';

class RectangularLocationSelectionBloc extends Bloc {}

class RectangularLocationSelectionWidthBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  RectangularLocationSelectionWidthBloc() : super('Width');

  @override
  MeasureUnit get measureUnit {
    return _settings.rectangularLocationSelectionWidthUnit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.rectangularLocationSelectionWidthUnit = newUnit;
  }

  @override
  double get value {
    return _settings.rectangularLocationSelectionWidthValue;
  }

  @override
  set value(double newValue) {
    _settings.rectangularLocationSelectionWidthValue = newValue;
  }
}

class RectangularLocationSelectionHeightBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  RectangularLocationSelectionHeightBloc() : super('Height');

  @override
  MeasureUnit get measureUnit {
    return _settings.rectangularLocationSelectionHeightUnit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.rectangularLocationSelectionHeightUnit = newUnit;
  }

  @override
  double get value {
    return _settings.rectangularLocationSelectionHeightValue;
  }

  @override
  set value(double newValue) {
    _settings.rectangularLocationSelectionHeightValue = newValue;
  }
}
