/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/settings/model/recognition_area.dart';
import 'package:TextCaptureSample/settings/model/text_type.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

const String licenseKey = 'Aa2k0xbKMtvDJWNgLU02Cr8aLxUjNtOuqXCjHUxVAUf/d66Y5Tm74sJ+8L0rGQUZ20e52VlMY9I7YW4W13kWbvp36R8jbqQy6yZUGS50G5n4fRItJD6525RcbTYZQjoIGHQqle9jj08ra19ZUy9RliVlOn3hHz4WrGO8vORyATmFXJpULzk0I5RpiT84ckXhG2Ri8jtIzoISX3zsoiLtXVRGjjrkbuGZzGbKA180JKEpdfSQwVyupLti5yNYHAeKihS6IOklCTz8CM1BfRC4zBdIDjbVEJPFgAsLvMU0rTyJhHkB5Ds4wfHbKNFhW0T2XkYLKkvZ7X/HnEVD5oz9Kl4T4rtRkepJfsXUWHUgVugjLO5vqwhMcHNV5XpK2Pk/SLrzGF1PDRu8f4ZhBLrWKknWq+5TSK8GWi4wmGpVvbxqHhLljzOzplYs8I5TtphZ3otJNLs10lhk1YN9cmdaxpdUuF4k0WDU1Qfco75p5G+MBlsAVVFrs0xMF9fSMJkQ+4UU+G+py5781HPkpw4kaGwmJhGrzA/Lbhf4tL+XfynseLw42oygpfVabYEYRHSQx+1j5RpFSR6V9t4jlKsJu2xgYz0A96I82gIHItRRxZkT2oEsZCgYlgCiQsFcsFdo9N9bzDL9mVR5Nj0RPIVvKc01AVtKvXLx86g2rNPv45eBaJFrdsWmv97V8+Pv6M9d+Wr1qcTeT1BY8fvWUEDmU1HF6eCJ1A6cDAM+Nq4sAP9D2lH7D6rHwK+x07F56bMZibLeDoGKanE8PhhamhxBVemE/ByCoMoItBtSbpeBubHVsSHlGF3/AAKi6flY6j0htptgPOM8eOwGXx6YvVxu3KOMF+2RBIQai8LP0YEuhVJ0ST7WX5seeVSu5RMKUx/euHoQB6qID+ydzkXGzYZLTPPskmJSWqrboJQPIjZ/ruCtJepZ/+Lr7g5nCyb01w==';

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
