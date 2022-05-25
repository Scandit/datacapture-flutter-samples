/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/model/extension_item.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class SymbologyDetailsSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  final Symbology symbology;
  final SymbologyDescription description;

  SymbologyDetailsSettingsBloc(this.symbology) : description = SymbologyDescription.forSymbology(symbology);

  String get title {
    return description.readableName;
  }

  bool get isEnabled {
    return _settings.isSymbologyEnabled(symbology);
  }

  set isEnabled(bool newValue) {
    _settings.enableSymbology(symbology, newValue);
  }

  bool get isRangeSettingsAvailable {
    return description.activeSymbolCountRange.minimum != description.activeSymbolCountRange.maximum;
  }

  bool get areExtensionsAvailable {
    return description.supportedExtensions.isNotEmpty;
  }

  Set<String> get supportedExtensions {
    return description.supportedExtensions;
  }

  bool get colorInvertedSettingsAvailable {
    return description.isColorInvertible;
  }

  bool get isColorInvertedEnabled {
    return _settings.isColorInvertedEnabled(symbology);
  }

  set isColorInvertedEnabled(bool newValue) {
    _settings.setColorInverted(symbology, newValue);
  }

  Set<ExtensionItem> get extensions {
    return description.supportedExtensions
        .map((e) => ExtensionItem(e, _settings.isExtensionEnabled(symbology, e)))
        .toSet();
  }

  void setExtensionEnabled(String extension, bool enabled) {
    _settings.setExtensionEnabled(symbology, extension, enabled);
  }

  int get minimumSymbolCount {
    return _settings.getMinSymbolCount(symbology);
  }

  set minimumSymbolCount(int minSymbolCount) {
    _settings.setMinSymbolCount(symbology, minSymbolCount);
  }

  List<int> get availableMinRanges {
    List<int> result = [];
    if (!isRangeSettingsAvailable) return result;

    Range range = description.activeSymbolCountRange;

    // We allow selection from the minimum symbol count allowed by the symbology until the
    // currently selected maximum symbol count.
    int minAllowedSymbolCount = range.minimum;
    int maxAllowedSymbolCount = _settings.getMaxSymbolCount(symbology);

    int step = range.step;

    for (int i = minAllowedSymbolCount; i <= maxAllowedSymbolCount; i += step) {
      result.add(i);
    }
    return result;
  }

  int get maximumSymbolCount {
    return _settings.getMaxSymbolCount(symbology);
  }

  set maximumSymbolCount(int maxSymbolCount) {
    _settings.setMaxSymbolCount(symbology, maxSymbolCount);
  }

  List<int> get availableMaxRanges {
    List<int> result = [];
    if (!isRangeSettingsAvailable) return result;

    var range = description.activeSymbolCountRange;

    // We allow selection from the currently selected minimum symbol count until the maximum
    // allowed by the symbology.
    int minAllowedSymbolCount = _settings.getMinSymbolCount(this.symbology);
    int maxAllowedSymbolCount = range.maximum;
    int step = range.step;

    for (int i = minAllowedSymbolCount; i <= maxAllowedSymbolCount; i += step) {
      result.add(i);
    }

    return result;
  }
}
