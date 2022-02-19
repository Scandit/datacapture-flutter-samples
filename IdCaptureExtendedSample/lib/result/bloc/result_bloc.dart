/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/bloc/bloc_base.dart';
import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:flutter/widgets.dart';

class ResultBloc extends Bloc {
  final CapturedIdResult _captureResult;

  ResultBloc(this._captureResult);

  List<ResultEntry> get items => _captureResult.getResult();

  Image? get faceImage {
    return _captureResult.faceImage;
  }

  Image? get idFrontImage {
    return _captureResult.idFrontImage;
  }

  Image? get idBackImage {
    return _captureResult.idBackImage;
  }
}
