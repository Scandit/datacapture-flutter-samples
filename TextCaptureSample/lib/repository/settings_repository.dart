/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/settings/model/recognition_area.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

const String licenseKey = 'AbvELRLKNvXhGsHO0zMIIg85n3IiQdKMA2p5yeVDSOSZSZg/BhX401FXc+2UHPun8Rp2LRpw26tYdgnIJlXiLAtmXfjDZNQzZmrZY2R0QaJaXJC34UtcQE12hEpIYhu+AmjA5cROhJN3CHPoHDns+ho12ibrRAoFrAocoBIwCVzuTRHr0U6pmCKoa/Mn3sNPdINHh97m1X9Al9xjh3VOTNimP6ZjrHLVWEJSOdp2QYOnqn5izP1329PVcZhn8gqlGCRh+LJytbKJYI/KIRbMy3bNOyq5kNnr2IlOqaoXRgYdz2IU+jIWw8Cby9XoSB1zkphiYMmlCUqrDzxLUmTAXF4rSWobiM+OxnoImDqISpunJBQz0a5DSeT5Zf0lwwvXQLX4ghkgXozyYYfYvIKsqxJLZoza8g1BFsJ1i3fb0JYP2Ju209OMN2NTJifAu9ZJjQKGWS76Rmr/jre13jCqGgx5SX9F2lA2ZpF2AEb6rmYYmMtL9CPwWvstM+W295WvscH+gCBccZ9q3rxfIsak6cV2T50/2uBWfJJka6kL9UOjMOG3BOGKx+O+KWT/twwvOC+GcvC8s1qMwGNNM6G+/m7fG5Xtl5wtp3QhpzPJbBHSmlkYbxXQx0SpuWBmvxygyKOi3lUzz3gRzOdykWRXzrhiMAp5bb1y6n6g4O2v2TVgzWWF8vwZ6F60ehYDUq7pbusgT4Fl3fV7fYPgLxMMvXKduMmUlWyGv3CWL9LfvoY/hLl7RxoyUryTMmSfRVBcsKs+MWYJGh1iIvWk1UhOChb9IGI2PzUsHz7+OikuYMjKhR8LZZYalXpPiEVfT66yy75M5DODcjXRoFZU';

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
