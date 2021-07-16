/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/laserline_style_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';

class LaserlineViewfinderBloc extends Bloc {
  SettingsRepository _settings = SettingsRepository();
  final Color blueColor = Color(0xff2ec1ce);
  final Color redColor = Color(0xffff0000);
  final Color whiteColor = Color(0xffffffff);

  Iterable<LaserlineStyleItem> get availableStyles {
    return LaserlineViewfinderStyle.values.map((e) => LaserlineStyleItem(e));
  }

  LaserlineStyleItem get currentStyle {
    return LaserlineStyleItem(_settings.laserlineStyle);
  }

  set currentStyle(LaserlineStyleItem newStyle) {
    _settings.laserlineStyle = newStyle.style;
  }

  String get widthDisplayText {
    return '${_settings.laserlineWidth.value.toStringAsFixed(2)} (${_settings.laserlineWidth.unit.name})';
  }

  List<ColorItem> get availableEnabledColors {
    return [
      ColorItem('Default', _settings.laserlineEnabledColor,
          _settings.laserlineEnabledColor.value == _settings.laserlineDefaultDisabledColor.value),
      ColorItem('Red', redColor, _settings.laserlineEnabledColor.value == redColor.value),
      ColorItem('White', whiteColor, _settings.laserlineEnabledColor.value == whiteColor.value),
    ];
  }

  ColorItem get currentEnabledColor {
    return availableEnabledColors.firstWhere((element) => element.isSelected);
  }

  set currentEnabledColor(ColorItem newColor) {
    _settings.laserlineEnabledColor = newColor.color;
  }

  List<ColorItem> get availableDisabledColors {
    return [
      ColorItem('Default', _settings.laserlineDisabledColor,
          _settings.laserlineDisabledColor.value == _settings.laserlineDefaultDisabledColor.value),
      ColorItem('Blue', blueColor, _settings.laserlineDisabledColor.value == blueColor.value),
      ColorItem('Red', redColor, _settings.laserlineDisabledColor.value == redColor.value),
    ];
  }

  ColorItem get currentDisabledColor {
    return availableDisabledColors.firstWhere((element) => element.isSelected,
        orElse: () => ColorItem('Default', _settings.laserlineDisabledColor, true));
  }

  set currentDisabledColor(ColorItem newColor) {
    _settings.laserlineDisabledColor = newColor.color;
  }
}

class LaserlineWidthBloc extends DoubleWithUnitBloc {
  SettingsRepository _settings = SettingsRepository();

  LaserlineWidthBloc() : super('Width');

  @override
  MeasureUnit get measureUnit {
    return _settings.laserlineWidth.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.laserlineWidth = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.laserlineWidth.value;
  }

  @override
  set value(double newValue) {
    _settings.laserlineWidth = DoubleWithUnit(newValue, measureUnit);
  }
}
