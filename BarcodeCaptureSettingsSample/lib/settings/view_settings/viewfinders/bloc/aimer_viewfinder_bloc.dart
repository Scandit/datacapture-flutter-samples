/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';

class AimerViewfinderBloc extends Bloc {
  SettingsRepository _settings = SettingsRepository();
  final Color blueColor = Color(0xff2ec1ce);
  final Color redColor = Color(0xffff0000);

  List<ColorItem> get availableFrameColors {
    return [
      ColorItem('Default', _settings.aimerDefaultFrameColor,
          _settings.aimerFrameColor.value == _settings.aimerDefaultFrameColor.value),
      ColorItem('Blue', blueColor, _settings.aimerFrameColor.value == blueColor.value),
      ColorItem('Red', redColor, _settings.aimerFrameColor.value == redColor.value),
    ];
  }

  ColorItem get currentFrameColor {
    return availableFrameColors.firstWhere((element) => element.isSelected);
  }

  set currentFrameColor(ColorItem newColor) {
    _settings.aimerFrameColor = newColor.color;
  }

  List<ColorItem> get availableDotColors {
    return [
      ColorItem('Default', _settings.aimerDefaultDotColor,
          _settings.aimerDotColor.value == _settings.aimerDefaultDotColor.value),
      ColorItem('Blue', blueColor, _settings.aimerDotColor.value == blueColor.value),
      ColorItem('Red', redColor, _settings.aimerDotColor.value == redColor.value),
    ];
  }

  ColorItem get currentDotColor {
    return availableDotColors.firstWhere((element) => element.isSelected);
  }

  set currentDotColor(ColorItem newColor) {
    _settings.aimerDotColor = newColor.color;
  }
}
