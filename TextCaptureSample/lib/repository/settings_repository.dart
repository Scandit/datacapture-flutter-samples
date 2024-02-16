/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/settings/model/recognition_area.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

const String licenseKey = 'AfUkdmKlRiP5FdlOFQnOhu4V3j5LFKttPGTWXFd7CkuRaTAstDqq78RrBm2ZG9LRu1T8CNgP6oLScGrUoEwfmP1TUXonIGCl2g9Fo5NYtmK/aEV8FX/YcdRKfWS5bJrTcWGDHdcsJxT6Me5C3RMdWZkdqeR5GEjDzT6dO4ZPWOBbNLjpkgZ0/MjtYQPKqSV+bSZC7+ekFaXovSKWfXV89BXtta/6sZHFJOMKxyvzh6zw5yA+NDR67OXoWKCrrNq4AOuBlt1ZelIHCqjQgTy/SZG110eJr5e4pth38Bx0fXE8FGX92BoxwJr1EG+P5CEJF8EFMy2zf87aJQYuzHmg0nM7czcNqLUd9F23uxntZYjKlwgWmmSzev/ozaumEvbW9RVW1bUQmV8pQ1SWILBuzQPeAw8iWOWgnTH18tH7cT+fUJumvM2rn7LWx9JYLAKBKRuwe2sDh3l5eqobZKdarIRsKVgXa4pw+gkYKuplzTo+Bzh70rbmtgq3IJ8hSpdoZITzfUQSwXkrgdQa5Cmrpxz9gXManBRt01h3eFXG7znZU9w0+uzzV/b5e6MQcPncODrCQOq0kfEBYgRoLAwVCOKnxyWQkqRbUpsTN2wy2MTg10flYhR/zf1eXdiUjgPUhWj8LtmgxJELYky7uMu46abfCkAw73e+12iJmlf9/tmTFk34La9ZQiF/BYps5h327ZW8qobay+Esx1i9dsaFKYt/nCN8jZdUYD/df+/vApyK4PMbph9EPRe5u0alg8BqpEExnkQsy1W7r85yngO/rxSXsY6rTMoTXb/87ul8uQnsrD41ZLtFdzo0OlbNTeNOI1mJz/E6/SOLbRRK';

class SettingsRepository {
  static final SettingsRepository _singleton = SettingsRepository._internal()..init();

  factory SettingsRepository() {
    return _singleton;
  }

  SettingsRepository._internal();

  // Create data capture context using your license key.
  late DataCaptureContext _dataCaptureContext;

  // Use the world-facing (back) camera.
  Camera? _camera = Camera.defaultCamera;

  final CameraSettings _cameraSettings = TextCapture.recommendedCameraSettings;

  late TextCapture _textCapture;

  late DataCaptureView _dataCaptureView;

  late TextCaptureOverlay _overlay;

  DataCaptureContext get dataCaptureContext {
    return _dataCaptureContext;
  }

  DataCaptureView get dataCaptureView {
    return _dataCaptureView;
  }

  TextCapture get textCapture {
    return _textCapture;
  }

  Camera? get camera {
    return _camera;
  }

  TextType _textType = TextType(Mode.gs1Ai);

  TextType get textType {
    return _textType;
  }

  set textType(TextType newType) {
    _textType = newType;
    applyNewSettings();
    setupViewfinder();
  }

  RecognitionArea _recognitionArea = RecognitionArea(Position.center);

  RecognitionArea get recognitionArea {
    return _recognitionArea;
  }

  set recognitionArea(RecognitionArea newRecognitionArea) {
    _recognitionArea = newRecognitionArea;
    setupPosition();
  }

  void init() {
    _camera?.applySettings(_cameraSettings);

    // Create data capture context using your license key and set the camera as the frame source.
    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);
    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    // Initialize settings from the default text type
    var settings = getSettings();

    // Create new text capture mode with the initial settings
    _textCapture = TextCapture.forContext(_dataCaptureContext, settings);

    // To visualize the on-going text capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(dataCaptureContext);

    // Add a text capture overlay to the data capture view to render the location of captured texts on top of
    // the video preview. This is optional, but recommended for better visual feedback.
    _overlay = TextCaptureOverlay.withTextCaptureForView(_textCapture, _dataCaptureView);

    setupViewfinder();
    setupPosition();
  }

  LocationSelection get locationSelection {
    var locationWidth = (_textType.mode == Mode.gs1Ai) ? 0.9 : 0.6;
    return RectangularLocationSelection.withWidthAndAspect(DoubleWithUnit(locationWidth, MeasureUnit.fraction), 0.2);
  }

  void setupViewfinder() {
    var viewfinderWidth = (_textType.mode == Mode.gs1Ai) ? 0.9 : 0.6;

    var viewfinder = RectangularViewfinder.withStyleAndLineStyle(
      RectangularViewfinderStyle.square,
      RectangularViewfinderLineStyle.light,
    );
    viewfinder.dimming = 0.2;
    viewfinder.setWidthAndAspectRatio(new DoubleWithUnit(viewfinderWidth, MeasureUnit.fraction), 0.2);
    _overlay.viewfinder = viewfinder;
  }

  void setupPosition() {
    // Set the point of interest of the capture view, which will automatically move the center of the viewfinder
    // and the location selection area to this point.
    var pointOfInterest = PointWithUnit(
        DoubleWithUnit(0.5, MeasureUnit.fraction), DoubleWithUnit(_recognitionArea.centerY, MeasureUnit.fraction));
    dataCaptureView.pointOfInterest = pointOfInterest;
  }

  void applyNewSettings() {
    textCapture.applySettings(getSettings());
  }

  TextCaptureSettings getSettings() {
    return TextCaptureSettings.fromJSON({'regex': _textType.regex})..locationSelection = locationSelection;
  }
}
