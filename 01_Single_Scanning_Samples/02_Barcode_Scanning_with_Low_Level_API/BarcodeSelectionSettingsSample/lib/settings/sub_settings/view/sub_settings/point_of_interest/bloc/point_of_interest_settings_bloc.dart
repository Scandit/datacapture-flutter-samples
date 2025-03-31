/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class PointOfInterestSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  String get pointXDisplayText {
    return '${_settings.pointOfInterestX.value.toStringAsFixed(2)} (${_settings.pointOfInterestX.unit.name})';
  }

  String get pointYDisplayText {
    return '${_settings.pointOfInterestY.value.toStringAsFixed(2)} (${_settings.pointOfInterestY.unit.name})';
  }
}

class PointOfInterestX extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  PointOfInterestX() : super('X');

  @override
  MeasureUnit get measureUnit {
    return _settings.pointOfInterestX.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.pointOfInterestX = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.pointOfInterestX.value;
  }

  @override
  set value(double newValue) {
    _settings.pointOfInterestX = DoubleWithUnit(newValue, measureUnit);
  }
}

class PointOfInterestY extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  PointOfInterestY() : super('Y');

  @override
  MeasureUnit get measureUnit {
    return _settings.pointOfInterestY.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.pointOfInterestY = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.pointOfInterestY.value;
  }

  @override
  set value(double newValue) {
    _settings.pointOfInterestY = DoubleWithUnit(newValue, measureUnit);
  }
}
