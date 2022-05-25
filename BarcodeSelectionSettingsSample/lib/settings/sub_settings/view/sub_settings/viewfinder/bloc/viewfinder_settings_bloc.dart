/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/model/picker_item.dart';

class ViewfinderSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  PickerItem get frameColor {
    return availableFrameColors.firstWhere((element) => element.isSelected);
  }

  set frameColor(PickerItem newColor) {
    _settings.frameColor = newColor.value;
  }

  List<PickerItem> get availableFrameColors {
    return [
      PickerItem(
          'Default', _settings.defaultFrameColor, _settings.frameColor.value == _settings.defaultFrameColor.value),
      PickerItem('Blue', _settings.scanditBlueColor, _settings.frameColor.value == _settings.scanditBlueColor.value),
    ];
  }

  PickerItem get dotColor {
    return availableDotColors.firstWhere((element) => element.isSelected);
  }

  set dotColor(PickerItem newColor) {
    _settings.dotColor = newColor.value;
  }

  List<PickerItem> get availableDotColors {
    return [
      PickerItem('Default', _settings.defaultDotColor, _settings.dotColor.value == _settings.defaultDotColor.value),
      PickerItem('Blue', _settings.scanditBlueColor, _settings.dotColor.value == _settings.scanditBlueColor.value),
    ];
  }
}
