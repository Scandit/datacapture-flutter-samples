/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class CameraSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  CameraPosition? get cameraPosition {
    return _settings.camera?.position;
  }

  Future<void> setCameraPosition(CameraPosition newPosition) {
    return _settings.setCameraPosition(newPosition);
  }

  bool get isTorchOn {
    return _settings.desiredTorchState == TorchState.on;
  }

  set isTorchOn(bool newState) {
    if (newState) {
      _settings.desiredTorchState = TorchState.on;
    } else {
      _settings.desiredTorchState = TorchState.off;
    }
  }

  VideoResolution get videoResolution {
    return _settings.videoResolution;
  }

  set videoResolution(VideoResolution newVideoResolution) {
    _settings.videoResolution = newVideoResolution;
  }

  double get zoomFactor {
    return _settings.zoomFactor;
  }

  set zoomFactor(double newValue) {
    _settings.zoomFactor = newValue;
  }

  double get zoomGestureZoomFactor {
    return _settings.zoomGestureZoomFactor;
  }

  set zoomGestureZoomFactor(double newValue) {
    _settings.zoomGestureZoomFactor = newValue;
  }

  FocusGestureStrategy get focusGestureStrategy {
    return _settings.focusGestureStrategy;
  }

  set focusGestureStrategy(FocusGestureStrategy newValue) {
    _settings.focusGestureStrategy = newValue;
  }

  List<FocusGestureStrategy> get availableFocusGestureStrategies {
    return FocusGestureStrategy.values;
  }

  List<VideoResolution> get availableVideoResolutions {
    return VideoResolution.values;
  }

  Iterable<CameraPosition> get availableCameraPositions {
    return CameraPosition.values.where((element) => element != CameraPosition.unspecified);
  }
}
