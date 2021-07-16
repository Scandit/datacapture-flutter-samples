/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class LogoBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  Anchor get currentAnchor {
    return _settings.currentLogoAnchor;
  }

  set currentAnchor(Anchor newValue) {
    _settings.currentLogoAnchor = newValue;
  }

  List<Anchor> get availableAnchors {
    return Anchor.values;
  }

  String get offsetXDisplayText {
    return '${_settings.logoOffsetX.value.toStringAsFixed(2)} (${_settings.logoOffsetX.unit.name})';
  }

  String get offsetYDisplayText {
    return '${_settings.logoOffsetY.value.toStringAsFixed(2)} (${_settings.logoOffsetY.unit.name})';
  }
}

class LogoOffsetXBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  LogoOffsetXBloc() : super('X');

  @override
  MeasureUnit get measureUnit {
    return _settings.logoOffsetX.unit;
  }

  @override
  set measureUnit(MeasureUnit newValue) {
    _settings.logoOffsetX = DoubleWithUnit(value, newValue);
  }

  @override
  double get value {
    return _settings.logoOffsetX.value;
  }

  @override
  set value(double newValue) {
    _settings.logoOffsetX = DoubleWithUnit(newValue, measureUnit);
  }
}

class LogoOffsetYBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  LogoOffsetYBloc() : super('Y');

  @override
  MeasureUnit get measureUnit {
    return _settings.logoOffsetY.unit;
  }

  @override
  set measureUnit(MeasureUnit newValue) {
    _settings.logoOffsetY = DoubleWithUnit(value, newValue);
  }

  @override
  double get value {
    return _settings.logoOffsetY.value;
  }

  @override
  set value(double newValue) {
    _settings.logoOffsetY = DoubleWithUnit(newValue, measureUnit);
  }
}
