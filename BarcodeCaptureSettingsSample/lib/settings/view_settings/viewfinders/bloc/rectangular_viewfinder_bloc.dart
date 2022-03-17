/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class RectangularViewfinderBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();
  final Color blueColor = Color(0xff2ec1ce);
  final Color blackColor = Color(0xff000000);
  final Color whiteColor = Colors.white;

  RectangularViewfinderStyle get currentStyle {
    return _settings.rectangularViewfinderStyle;
  }

  set currentStyle(RectangularViewfinderStyle newStyle) {
    _settings.rectangularViewfinderStyle = newStyle;
  }

  List<RectangularViewfinderStyle> get availableStyles {
    return RectangularViewfinderStyle.values;
  }

  RectangularViewfinderLineStyle get currentLineStyle {
    return _settings.rectangularViewfinderLineStyle;
  }

  set currentLineStyle(RectangularViewfinderLineStyle newLineStyle) {
    _settings.rectangularViewfinderLineStyle = newLineStyle;
  }

  List<RectangularViewfinderLineStyle> get availableLineStyles {
    return RectangularViewfinderLineStyle.values;
  }

  double get dimming {
    return _settings.rectangularViewfinderDimming;
  }

  set dimming(double newValue) {
    if (newValue < 0 || newValue > 1.0) return;

    _settings.rectangularViewfinderDimming = newValue;
  }

  List<ColorItem> get availableColors {
    return [
      ColorItem('Default', _settings.rectangularViewfinderDefaultColor,
          _settings.rectangularViewfinderColor.value == _settings.rectangularViewfinderDefaultColor.value),
      ColorItem('Blue', blueColor, _settings.rectangularViewfinderColor.value == blueColor.value),
      ColorItem('Black', blackColor, _settings.rectangularViewfinderColor.value == blackColor.value),
    ];
  }

  ColorItem get currentColor {
    return availableColors.firstWhere((element) => element.isSelected);
  }

  set currentColor(ColorItem newColor) {
    _settings.rectangularViewfinderColor = newColor.color;
  }

  List<ColorItem> get availableDisabledColors {
    return [
      ColorItem(
          'Default',
          _settings.rectangularViewfinderDisabledColor,
          _settings.rectangularViewfinderDisabledColor.value ==
              _settings.rectangularViewfinderDefaultDisabledColor.value),
      ColorItem('Black', blackColor, _settings.rectangularViewfinderDisabledColor.value == blackColor.value),
      ColorItem('White', whiteColor, _settings.rectangularViewfinderDisabledColor.value == whiteColor.value),
    ];
  }

  ColorItem get currentDisabledColor {
    return availableDisabledColors.firstWhere((element) => element.isSelected);
  }

  set currentDisabledColor(ColorItem newColor) {
    _settings.rectangularViewfinderDisabledColor = newColor.color;
  }

  bool get isAnimationEnabled {
    return _settings.rectangularViewfinderAnimationEnabled;
  }

  set isAnimationEnabled(bool newValue) {
    _settings.rectangularViewfinderAnimationEnabled = newValue;
  }

  bool get isLooping {
    return _settings.rectangularViewfinderAnimationIsLooping;
  }

  set isLooping(bool newValue) {
    _settings.rectangularViewfinderAnimationIsLooping = newValue;
  }

  SizingMode get currentSizingMode {
    return _settings.rectangularViewfinderSizingMode;
  }

  set currentSizingMode(SizingMode newMode) {
    _settings.rectangularViewfinderSizingMode = newMode;
  }

  List<SizingMode> get availableSizingModes {
    return SizingMode.values;
  }

  String get widthDisplayText {
    return '${_settings.rectangularViewfinderWidth.value.toStringAsFixed(2)} (${_settings.rectangularViewfinderWidth.unit.name})';
  }

  String get heigthDisplayText {
    return '${_settings.rectangularViewfinderHeight.value.toStringAsFixed(2)} (${_settings.rectangularViewfinderHeight.unit.name})';
  }

  double get heightAspect {
    return _settings.rectangularViewfinderHeightAspect;
  }

  set heightAspect(double newValue) {
    _settings.rectangularViewfinderHeightAspect = newValue;
  }

  double get widthAspect {
    return _settings.rectangularViewfinderWidthAspect;
  }

  set widthAspect(double newValue) {
    _settings.rectangularViewfinderWidthAspect = newValue;
  }

  double get shorterDimension {
    return _settings.rectangularViewfinderShorterDimension;
  }

  set shorterDimension(double newValue) {
    _settings.rectangularViewfinderShorterDimension = newValue;
  }

  double get longerDimensionAspect {
    return _settings.rectangularViewfinderLongerDimensionAspect;
  }

  set longerDimensionAspect(double newValue) {
    _settings.rectangularViewfinderLongerDimensionAspect = newValue;
  }
}

class RectangularViewfinderWidthBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  RectangularViewfinderWidthBloc() : super('Width');

  @override
  MeasureUnit get measureUnit {
    return _settings.rectangularViewfinderWidth.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.rectangularViewfinderWidth = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.rectangularViewfinderWidth.value;
  }

  @override
  set value(double newValue) {
    _settings.rectangularViewfinderWidth = DoubleWithUnit(newValue, measureUnit);
  }
}

class RectangularViewfinderHeightBloc extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();

  RectangularViewfinderHeightBloc() : super('Height');

  @override
  MeasureUnit get measureUnit {
    return _settings.rectangularViewfinderHeight.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _settings.rectangularViewfinderHeight = DoubleWithUnit(value, newUnit);
  }

  @override
  double get value {
    return _settings.rectangularViewfinderHeight.value;
  }

  @override
  set value(double newValue) {
    _settings.rectangularViewfinderHeight = DoubleWithUnit(newValue, measureUnit);
  }
}
