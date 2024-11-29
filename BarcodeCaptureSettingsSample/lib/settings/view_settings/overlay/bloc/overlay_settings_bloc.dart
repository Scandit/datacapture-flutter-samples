/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/model/brush_item.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/model/overlay_style_item.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class OverlaySettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();
  final Brush _redBrush = Brush(Colors.transparent, Colors.red, 1);
  final Brush _greenBrush = Brush(Colors.transparent, Colors.green, 1);
  final OverlayStyleItem _frameStyleItem = OverlayStyleItem(BarcodeCaptureOverlayStyle.frame, 'Frame');

  late BrushItem _selectedBrush;
  late OverlayStyleItem _selectedStyle;

  OverlaySettingsBloc() {
    if (_settings.currentBrush.strokeColor.jsonValue == _redBrush.strokeColor.jsonValue) {
      _selectedBrush = BrushItem('Red', _redBrush);
    } else if (_settings.currentBrush.strokeColor.jsonValue == _greenBrush.strokeColor.jsonValue) {
      _selectedBrush = BrushItem('Green', _greenBrush);
    } else {
      var defaultBrush = BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
              _settings.barcodeCapture, null, _settings.overlayStyle)
          .brush;
      _selectedBrush = BrushItem('Default', defaultBrush);
    }

    _selectedStyle = _frameStyleItem;
  }

  List<BrushItem> get availableBrushes {
    var defaultBrush =
        BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(_settings.barcodeCapture, null, _settings.overlayStyle)
            .brush;
    return [
      BrushItem('Default', defaultBrush),
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

  List<OverlayStyleItem> get availableStyles {
    return [_frameStyleItem];
  }

  OverlayStyleItem get selectedStyle {
    return _selectedStyle;
  }

  set selectedStyle(OverlayStyleItem overlayStyleItem) {
    _selectedStyle = overlayStyleItem;
    _settings.overlayStyle = overlayStyleItem.style;
  }
}
