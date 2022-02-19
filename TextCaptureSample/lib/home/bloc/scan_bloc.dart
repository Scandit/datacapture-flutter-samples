/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';

import 'package:TextCaptureSample/bloc/bloc_base.dart';
import 'package:TextCaptureSample/repository/settings_repository.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';
import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_parser/scandit_flutter_datacapture_parser.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

class ScanBloc extends Bloc implements TextCaptureListener {
  final SettingsRepository _settings = SettingsRepository();

  StreamController<String> _textCaptureResultController = StreamController();

  Stream<String> get textCaptureResultController => _textCaptureResultController.stream;

  StreamController<String> _textCaptureErrorController = StreamController();

  Stream<String> get textCaptureErrorController => _textCaptureErrorController.stream;

  late Parser _parser;

  ScanBloc() {
    // Register a listener to get informed whenever new text got recognized.
    _settings.textCapture.addListener(this);

    // Create a new parser instance that manages parsing when in GS1 mode.
    Parser.forContextAndFormat(_settings.dataCaptureContext, ParserDataFormat.gs1Ai).then((parser) {
      _parser = parser;
      _parser.setOptions({'allowHumanReadableCodes': true});
    });
  }

  DataCaptureView get dataCaptureView {
    return _settings.dataCaptureView;
  }

  void switchCameraOff() {
    _settings.camera?.switchToDesiredState(FrameSourceState.off);
  }

  void switchCameraOn() {
    _settings.camera?.switchToDesiredState(FrameSourceState.on);
  }

  void enableTextCapture() {
    _settings.textCapture.isEnabled = true;
  }

  void disableTextCapture() {
    _settings.textCapture.isEnabled = false;
  }

  @override
  void didCaptureText(TextCapture textCapture, TextCaptureSession session) {
    var text = session.newlyCapturedTexts[0];

    if (_settings.textType.mode == Mode.gs1Ai) {
      // Parse GS1 results with the parser instance previously created.
      _parser.parseString(text.value).then((parsedData) {
        var result = parsedData.fields.map((field) => '${field.name}: ${jsonEncode(field.parsed)}').join('\n');
        _textCaptureResultController.sink.add(result);
      }).onError((error, stackTrace) {
        // In case of PlatformException, there was probably an error parsing the string.
        if (error is PlatformException) {
          _textCaptureErrorController.sink.add(error.message ?? 'Error parsing captured text.');
        } else {
          enableTextCapture();
        }
      });
    } else {
      _textCaptureResultController.sink.add(text.value);
    }
    disableTextCapture();
  }

  @override
  void dispose() {
    _settings.textCapture.removeListener(this);
    _textCaptureResultController.close();
    _textCaptureErrorController.close();
    super.dispose();
  }
}
