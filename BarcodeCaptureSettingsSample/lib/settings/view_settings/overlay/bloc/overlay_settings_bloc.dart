/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/model/brush_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class OverlaySettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();
  final Brush _redBrush =
      Brush(ColorDeserializer.fromRgbaHex('#000033FF'), ColorDeserializer.fromRgbaHex('#FF0000FF'), 1);
  final Brush _greenBrush =
      Brush(ColorDeserializer.fromRgbaHex('#FF003300'), ColorDeserializer.fromRgbaHex('#FF0000FF'), 1);

  late BrushItem _selectedBrush;

  OverlaySettingsBloc() {
    if (_settings.currentBrush.fillColor.jsonValue == _redBrush.fillColor.jsonValue) {
      _selectedBrush = BrushItem('Red', _redBrush);
    } else if (_settings.currentBrush.fillColor.jsonValue == _greenBrush.fillColor.jsonValue) {
      _selectedBrush = BrushItem('Green', _greenBrush);
    } else {
      _selectedBrush = BrushItem('Default', _settings.defaultBrush);
    }
  }

  List<BrushItem> get availableBrushes {
    return [
      BrushItem('Default', _settings.defaultBrush),
      BrushItem('Red', _redBrush),
      BrushItem('Green', _greenBrush),
    ];
  }

  BrushItem get selectedBrush {
    return _selectedBrush;
  }

  set selectedBrush(BrushItem brushItem) {
    _selectedBrush = brushItem;
    _settings.currentBrush = brushItem.brush;
  }
}
