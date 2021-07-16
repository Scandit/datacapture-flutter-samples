/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class GesturesBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  bool get isTapToFocusEnabled {
    return _settings.focusGesture != null;
  }

  set isTapToFocusEnabled(bool newValue) {
    _settings.focusGesture = newValue ? TapToFocus() : null;
  }

  bool get isSwipeToZoomEnabled {
    return _settings.zoomGesture != null;
  }

  set isSwipeToZoomEnabled(bool newValue) {
    _settings.zoomGesture = newValue ? SwipeToZoom() : null;
  }
}
