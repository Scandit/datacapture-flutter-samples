/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/settings/model/recognition_area.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

const String licenseKey = 'AYjTKgwFKLhZGtmHmyNAawklGVUpLfmaJ2JN39hPFcbHRdb8Sh3UX45m7PRkJtORsQzsAeBZw7aAZ/VBZlp5ykVZZOOYUI8ZAxAsZ3tOrh5HXX2CzFyh2yNzGtUXQuR5eFHqhXNx8+mfbsvN2zErPt0+TW4TESKXSx4764U8HnIF/01crbTR4/qxeWvIgdmGJkoV2YZc4wfZjpQI2Uvd3/J2jFcv/WrVHgWZ/VAC2lHTzC3JdwtTNJKxxDpsqKp1sDlARxGjw4hlebrAUbft3aWMjbtpVn2T4D+tBN3GVuwlD9Uo7MN3Sto17fSVSD1JLymYPHP7zxsnByy9mCBhKqTf3YKCh8DughdNJpIIWaaoY6t6OTof+TxY25XAboYM1Ii3FdaK1MjK2x9bVujInqaIYzPRYRwQj6lPyVaYSiRRJTsR6l3RLXyorSeqM6Mjyspyb9Gl3ht1grXe8TzMwVUFLYwBlV1zYcKfCVxHIaPo8irO1X7+sImu0166pNeK962FxzUx+rJMsvEIhy8mzF//yRI8WBLZvuBS5AH8EJHBb5p6DcdLgNVf3AwQWw6S5ENIw1Nu+eS2p+nm7msRRWP5jbqo8TfwgoellmtHaljlvmQ47kXfZvo9feDd7qZtGvWuX22yZkb+3k0OEfNKZaBKLrfzKU6X5TlmMvyhU7mF6mMdkBwex+NuKhRl1fYVjzD1hk75j70/QgXyjMv9nJpSEIXEt//AVHZTG4lGvAT0l3hPOie/zS0ixEH11+LJvbzsZQXYngggsJ40oCbajRxnvrMEcJQ5Lcxnp/Ov8qTmApOqK+XmLAV/s+MdeeIatFNTk6o9xGar+cB8';

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
