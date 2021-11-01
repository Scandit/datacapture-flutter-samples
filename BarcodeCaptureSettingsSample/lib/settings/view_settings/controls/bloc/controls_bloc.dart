/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';

class ControlsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  bool get isTorchControlEnabled {
    return _settings.torchControlEnabled;
  }

  set isTorchControlEnabled(bool newValue) {
    _settings.torchControlEnabled = newValue;
  }

  bool get isZoomSwitchControlEnabled {
    return _settings.zoomSwitchControlEnabled;
  }

  set isZoomSwitchControlEnabled(bool newValue) {
    _settings.zoomSwitchControlEnabled = newValue;
  }
}
