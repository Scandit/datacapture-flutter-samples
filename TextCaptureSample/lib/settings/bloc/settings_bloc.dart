/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/bloc/bloc_base.dart';
import 'package:TextCaptureSample/repository/settings_repository.dart';
import 'package:TextCaptureSample/settings/model/recognition_area.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';

class SettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  final _modes = [
    TextType(Mode.gs1Ai),
    TextType(Mode.lot),
  ];

  List<TextType> get modes => _modes;

  TextType get currentMode {
    return _settings.textType;
  }

  set currentMode(TextType newMode) {
    _settings.textType = newMode;
  }

  final _scanPositions = [
    RecognitionArea(Position.top),
    RecognitionArea(Position.center),
    RecognitionArea(Position.bottom),
  ];

  List<RecognitionArea> get scanPositions => _scanPositions;

  RecognitionArea get currentScanPosition {
    return _settings.recognitionArea;
  }

  set currentScanPosition(RecognitionArea newScanPosition) {
    _settings.recognitionArea = newScanPosition;
  }
}
