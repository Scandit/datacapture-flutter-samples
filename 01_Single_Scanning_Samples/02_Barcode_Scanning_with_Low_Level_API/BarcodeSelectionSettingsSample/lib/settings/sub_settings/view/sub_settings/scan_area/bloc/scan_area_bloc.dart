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

class ScanAreaSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  String get topMarginDisplayText {
    return '${_settings.scanAreaTopMargin.value.toStringAsFixed(2)} (${_settings.scanAreaTopMargin.unit.name})';
  }

  String get bottomMarginDisplayText {
    return '${_settings.scanAreaBottomMargin.value.toStringAsFixed(2)} (${_settings.scanAreaBottomMargin.unit.name})';
  }

  String get leftMarginDisplayText {
    return '${_settings.scanAreaLeftMargin.value.toStringAsFixed(2)} (${_settings.scanAreaLeftMargin.unit.name})';
  }

  String get rightMarginDisplayText {
    return '${_settings.scanAreaRightMargin.value.toStringAsFixed(2)} (${_settings.scanAreaRightMargin.unit.name})';
  }

  bool get shouldShowScanAreaGuides {
    return _settings.shouldShowScanAreaGuides;
  }

  set shouldShowScanAreaGuides(bool newValue) {
    _settings.shouldShowScanAreaGuides = newValue;
  }
}

class ScanAreaTopMargin extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  ScanAreaTopMargin() : super('Top');

  @override
  MeasureUnit get measureUnit {
    return _settings.scanAreaTopMargin.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.scanAreaTopMargin = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.scanAreaTopMargin.value;
  }

  @override
  set value(double newValue) {
    _settings.scanAreaTopMargin = DoubleWithUnit(newValue, measureUnit);
  }
}

class ScanAreaBottomMargin extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  ScanAreaBottomMargin() : super('Bottom');

  @override
  MeasureUnit get measureUnit {
    return _settings.scanAreaBottomMargin.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.scanAreaBottomMargin = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.scanAreaBottomMargin.value;
  }

  @override
  set value(double newValue) {
    _settings.scanAreaBottomMargin = DoubleWithUnit(newValue, measureUnit);
  }
}

class ScanAreaLeftMargin extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  ScanAreaLeftMargin() : super('Left');

  @override
  MeasureUnit get measureUnit {
    return _settings.scanAreaLeftMargin.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.scanAreaLeftMargin = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.scanAreaLeftMargin.value;
  }

  @override
  set value(double newValue) {
    _settings.scanAreaLeftMargin = DoubleWithUnit(newValue, measureUnit);
  }
}

class ScanAreaRightMargin extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  ScanAreaRightMargin() : super('Right');

  @override
  MeasureUnit get measureUnit {
    return _settings.scanAreaRightMargin.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.scanAreaRightMargin = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.scanAreaRightMargin.value;
  }

  @override
  set value(double newValue) {
    _settings.scanAreaRightMargin = DoubleWithUnit(newValue, measureUnit);
  }
}
