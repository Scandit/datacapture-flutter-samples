/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/model/picker_item.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart' as core;

class OverlaySettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  BarcodeSelectionBasicOverlayStyle get style {
    return _settings.overlayStyle;
  }

  set style(BarcodeSelectionBasicOverlayStyle newStyle) {
    _settings.overlayStyle = newStyle;
  }

  List<PickerItem> get availableStyles {
    return BarcodeSelectionBasicOverlayStyle.values
        .map((e) => PickerItem(e.name, e, e == _settings.overlayStyle))
        .toList();
  }

  PickerItem get frozeBackgroundColor {
    return availableFrozenBackgroundColors.firstWhere((element) => element.isSelected);
  }

  set frozeBackgroundColor(PickerItem newColor) {
    _settings.frozenBackgroundColor = newColor.value;
  }

  List<PickerItem> get availableFrozenBackgroundColors {
    return [
      PickerItem('Default', _settings.defaultFrozenBackgroundColor,
          _settings.frozenBackgroundColor.value == _settings.defaultFrozenBackgroundColor.value),
      PickerItem('Blue', _settings.scanditBlueColor,
          _settings.frozenBackgroundColor.value == _settings.scanditBlueColor.value),
      PickerItem('Transparent', Colors.transparent, _settings.frozenBackgroundColor.value == Colors.transparent.value),
    ];
  }

  List<PickerItem> get availableTrackedBrushColors {
    return [
      PickerItem('Default', _settings.defaultTrackedBrush.fillColor,
          _settings.trackedBrush.fillColor.value == _settings.defaultTrackedBrush.fillColor.value),
      PickerItem('Blue', _settings.scanditBlueColor,
          _settings.trackedBrush.fillColor.value == _settings.scanditBlueColor.value),
    ];
  }

  PickerItem get trackedBrushColor {
    return availableTrackedBrushColors.firstWhere((element) => element.isSelected);
  }

  set trackedBrushColor(PickerItem newColor) {
    if (newColor.name == 'Default') {
      _settings.trackedBrush = _settings.defaultTrackedBrush;
    } else {
      _settings.trackedBrush =
          core.Brush(_settings.scanditBlueColor, _settings.scanditBlueColor, _settings.defaultTrackedBrush.strokeWidth);
    }
  }

  List<PickerItem> get availableAimedBrushColors {
    return [
      PickerItem('Default', _settings.defaultAimedBrush.fillColor,
          _settings.aimedBrush.fillColor.value == _settings.defaultAimedBrush.fillColor.value),
      PickerItem(
          'Blue', _settings.scanditBlueColor, _settings.aimedBrush.fillColor.value == _settings.scanditBlueColor.value),
    ];
  }

  PickerItem get aimedBrushColor {
    return availableAimedBrushColors.firstWhere((element) => element.isSelected);
  }

  set aimedBrushColor(PickerItem newColor) {
    if (newColor.name == 'Default') {
      _settings.aimedBrush = _settings.defaultTrackedBrush;
    } else {
      _settings.aimedBrush =
          core.Brush(_settings.scanditBlueColor, _settings.scanditBlueColor, _settings.defaultTrackedBrush.strokeWidth);
    }
  }

  List<PickerItem> get availableSelectingBrushColors {
    return [
      PickerItem('Default', _settings.defaultSelectingBrush.fillColor,
          _settings.selectingBrush.fillColor.value == _settings.defaultSelectingBrush.fillColor.value),
      PickerItem('Blue', _settings.scanditBlueColor,
          _settings.selectingBrush.fillColor.value == _settings.scanditBlueColor.value),
    ];
  }

  PickerItem get selectingBrushColor {
    return availableSelectingBrushColors.firstWhere((element) => element.isSelected);
  }

  set selectingBrushColor(PickerItem newColor) {
    if (newColor.name == 'Default') {
      _settings.selectingBrush = _settings.defaultSelectingBrush;
    } else {
      _settings.selectingBrush = core.Brush(
          _settings.scanditBlueColor, _settings.scanditBlueColor, _settings.defaultSelectingBrush.strokeWidth);
    }
  }

  List<PickerItem> get availableSelectedBrushColors {
    return [
      PickerItem('Default', _settings.defaultSelectedBrush.fillColor,
          _settings.selectedBrush.fillColor.value == _settings.defaultSelectedBrush.fillColor.value),
      PickerItem('Blue', _settings.scanditBlueColor,
          _settings.selectedBrush.fillColor.value == _settings.scanditBlueColor.value),
    ];
  }

  PickerItem get selectedBrushColor {
    return availableSelectedBrushColors.firstWhere((element) => element.isSelected);
  }

  set selectedBrushColor(PickerItem newColor) {
    if (newColor.name == 'Default') {
      _settings.selectedBrush = _settings.defaultSelectedBrush;
    } else {
      _settings.selectedBrush = core.Brush(
          _settings.scanditBlueColor, _settings.scanditBlueColor, _settings.defaultSelectingBrush.strokeWidth);
    }
  }

  bool get shouldShowHints {
    return _settings.shouldShowHints;
  }

  set shouldShowHints(bool newValue) {
    _settings.shouldShowHints = newValue;
  }
}
