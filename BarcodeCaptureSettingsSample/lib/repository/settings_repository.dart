/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:ui';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'dart:math';

const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

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

  // The barcode capture process is configured through barcode capture settings
  // which are then applied to the barcode capture instance that manages barcode capture.
  final BarcodeCaptureSettings _barcodeCaptureSettings = BarcodeCaptureSettings();

  final CameraSettings _cameraSettings = BarcodeCapture.recommendedCameraSettings;

  late BarcodeCapture _barcodeCapture;

  late DataCaptureView _dataCaptureView;

  late BarcodeCaptureOverlay _overlay;

  DataCaptureContext get dataCaptureContext {
    return _dataCaptureContext;
  }

  DataCaptureView get dataCaptureView {
    return _dataCaptureView;
  }

  BarcodeCapture get barcodeCapture {
    return _barcodeCapture;
  }

  // CAMERA SETTINGS - Start

  Camera? get camera {
    return _camera;
  }

  Future<void> setCameraPosition(CameraPosition newPosition) async {
    if (this._camera?.position == newPosition) return;

    var camera = Camera.atPosition(newPosition);
    if (camera != null) {
      await camera.applySettings(_cameraSettings);
      await _dataCaptureContext.setFrameSource(camera);
      _camera = camera;
    }
  }

  TorchState get desiredTorchState {
    return _camera?.desiredTorchState ?? TorchState.off;
  }

  set desiredTorchState(TorchState newState) {
    _camera?.desiredTorchState = newState;
  }

  VideoResolution get videoResolution {
    return _cameraSettings.preferredResolution;
  }

  set videoResolution(VideoResolution newVideoResolution) {
    _cameraSettings.preferredResolution = newVideoResolution;
    applyCameraSettings();
  }

  double get zoomFactor {
    return _cameraSettings.zoomFactor;
  }

  set zoomFactor(double newValue) {
    _cameraSettings.zoomFactor = newValue;
    applyCameraSettings();
  }

  double get zoomGestureZoomFactor {
    return _cameraSettings.zoomGestureZoomFactor;
  }

  set zoomGestureZoomFactor(double newValue) {
    _cameraSettings.zoomGestureZoomFactor = newValue;
    applyCameraSettings();
  }

  FocusGestureStrategy get focusGestureStrategy {
    return _cameraSettings.focusGestureStrategy;
  }

  set focusGestureStrategy(FocusGestureStrategy newValue) {
    _cameraSettings.focusGestureStrategy = newValue;
    applyCameraSettings();
  }

  // CAMERA SETTINGS - END

  // SYMBOLOGIES SETTINGS - START

  bool isSymbologyEnabled(Symbology symbology) {
    return getSymbologySettings(symbology).isEnabled;
  }

  void enableSymbology(Symbology symbology, bool enabled) {
    _barcodeCaptureSettings.enableSymbology(symbology, enabled);
  }

  void enableSymbologies(List<Symbology> symbologies) {
    _barcodeCaptureSettings.enableSymbologies(symbologies.toSet());
  }

  bool isExtensionEnabled(Symbology symbology, String extension) {
    return getSymbologySettings(symbology).enabledExtensions.contains(extension);
  }

  void setExtensionEnabled(Symbology symbology, String extension, bool enabled) {
    getSymbologySettings(symbology).setExtensionEnabled(extension, enabled: enabled);
    applyBarcodeCaptureSettings();
  }

  bool isColorInvertedEnabled(Symbology symbology) {
    return getSymbologySettings(symbology).isColorInvertedEnabled;
  }

  void setColorInverted(Symbology symbology, bool colorInvertible) {
    getSymbologySettings(symbology).isColorInvertedEnabled = colorInvertible;
    applyBarcodeCaptureSettings();
  }

  int getMinSymbolCount(Symbology symbology) {
    var activeCount = getSymbologySettings(symbology).activeSymbolCounts;
    return activeCount.length > 0 ? activeCount.reduce(min) : 0;
  }

  void setMinSymbolCount(Symbology symbology, int minSymbolCount) {
    var settings = getSymbologySettings(symbology);
    var maxSymbolCount = settings.activeSymbolCounts.reduce(max);
    setSymbolCount(settings, minSymbolCount, maxSymbolCount);
  }

  int getMaxSymbolCount(Symbology symbology) {
    var activeCount = getSymbologySettings(symbology).activeSymbolCounts;
    return activeCount.length > 0 ? activeCount.reduce(max) : 0;
  }

  void setMaxSymbolCount(Symbology symbology, int maxSymbolCount) {
    var settings = getSymbologySettings(symbology);
    var minSymbolCount = settings.activeSymbolCounts.reduce(min);
    setSymbolCount(settings, minSymbolCount, maxSymbolCount);
  }

  void setSymbolCount(SymbologySettings settings, int minSymbolCount, int maxSymbolCount) {
    List<int> symbolCount = [];

    if (minSymbolCount >= maxSymbolCount) {
      symbolCount.add(maxSymbolCount);
    } else {
      for (var i = minSymbolCount; i <= maxSymbolCount; i++) {
        symbolCount.add(i);
      }
    }
    settings.activeSymbolCounts = symbolCount.toSet();
    applyBarcodeCaptureSettings();
  }

  // SYMBOLOGIES SETTINGS - END

  // LOCATION SELECTION - START

  LocationSelection? get currentLocationSelection {
    return _barcodeCaptureSettings.locationSelection;
  }

  set currentLocationSelection(LocationSelection? newValue) {
    _barcodeCaptureSettings.locationSelection = newValue;
    applyBarcodeCaptureSettings();
  }

  DoubleWithUnit get radiusLocationSize {
    return DoubleWithUnit(radiusLocationSelectionValue, radiusLocationSelectionUnit);
  }

  double _radiusLocationSelectionValue = 0;

  double get radiusLocationSelectionValue {
    return _radiusLocationSelectionValue;
  }

  set radiusLocationSelectionValue(double newValue) {
    _radiusLocationSelectionValue = newValue;
  }

  MeasureUnit _radiusLocationSelectionUnit = MeasureUnit.dip;

  MeasureUnit get radiusLocationSelectionUnit {
    return _radiusLocationSelectionUnit;
  }

  set radiusLocationSelectionUnit(MeasureUnit newValue) {
    _radiusLocationSelectionUnit = newValue;
  }

  SizingMode rectangularLocationSelectionSizeMode = SizingMode.widthAndHeight;

  DoubleWithUnit _rectangularLocationSelectionWidth = DoubleWithUnit(0, MeasureUnit.dip);

  DoubleWithUnit get rectangularLocationSelectionWidth {
    return _rectangularLocationSelectionWidth;
  }

  double get rectangularLocationSelectionWidthValue {
    return _rectangularLocationSelectionWidth.value;
  }

  set rectangularLocationSelectionWidthValue(double newValue) {
    _rectangularLocationSelectionWidth = DoubleWithUnit(newValue, rectangularLocationSelectionWidthUnit);
  }

  MeasureUnit get rectangularLocationSelectionWidthUnit {
    return _rectangularLocationSelectionWidth.unit;
  }

  set rectangularLocationSelectionWidthUnit(MeasureUnit newUnit) {
    _rectangularLocationSelectionWidth = DoubleWithUnit(rectangularLocationSelectionWidthValue, newUnit);
  }

  DoubleWithUnit _rectangularLocationSelectionHeight = DoubleWithUnit(0, MeasureUnit.dip);

  DoubleWithUnit get rectangularLocationSelectionHeight {
    return _rectangularLocationSelectionHeight;
  }

  double get rectangularLocationSelectionHeightValue {
    return _rectangularLocationSelectionHeight.value;
  }

  set rectangularLocationSelectionHeightValue(double newValue) {
    _rectangularLocationSelectionHeight = DoubleWithUnit(newValue, rectangularLocationSelectionHeightUnit);
  }

  MeasureUnit get rectangularLocationSelectionHeightUnit {
    return _rectangularLocationSelectionHeight.unit;
  }

  set rectangularLocationSelectionHeightUnit(MeasureUnit newUnit) {
    _rectangularLocationSelectionHeight = DoubleWithUnit(rectangularLocationSelectionHeightValue, newUnit);
  }

  double rectangularLocationSelectionWidthAspect = 0;
  double rectangularLocationSelectionHeightAspect = 0;

  // LOCATION SELECTION - END

  // FEEDBACK - START

  bool get isSoundOn {
    return _barcodeCapture.feedback.success.sound != null;
  }

  set isSoundOn(bool newValue) {
    var vibration = _barcodeCapture.feedback.success.vibration;
    _barcodeCapture.feedback = BarcodeCaptureFeedback()
      ..success = Feedback(vibration, newValue ? Sound.defaultSound : null);
  }

  bool get isVibrationOn {
    return _barcodeCapture.feedback.success.vibration != null;
  }

  set isVibrationOn(bool newValue) {
    var sound = _barcodeCapture.feedback.success.sound;
    _barcodeCapture.feedback = BarcodeCaptureFeedback()
      ..success = Feedback(newValue ? Vibration.defaultVibration : null, sound);
  }

  // FEEDBACK - END

  // OVERLAY - START

  Brush get defaultBrush {
    return BarcodeCaptureOverlay.defaultBrush;
  }

  Brush get currentBrush {
    return _overlay.brush;
  }

  set currentBrush(Brush newBrush) {
    _overlay.brush = newBrush;
  }

  // OVERLAY - END

  // RESULT - START

  bool continuousScan = false;

  // RESULT - END

  // CODE DUPLICATE FILTER - START

  int get codeDuplicateFilter {
    return _barcodeCaptureSettings.codeDuplicateFilter.inSeconds;
  }

  set codeDuplicateFilter(int newValue) {
    _barcodeCaptureSettings.codeDuplicateFilter = Duration(seconds: newValue);
    applyBarcodeCaptureSettings();
  }

  // CODE DUPLICATE FILTER - END

  // COMPOSITE TYPES - START

  void enableCompositeType(CompositeType compositeType) {
    for (var symbology in _barcodeCaptureSettings.enabledSymbologies) {
      _barcodeCaptureSettings.enableSymbology(symbology, false);
    }

    _barcodeCaptureSettings.enabledCompositeTypes.add(compositeType);
    _barcodeCaptureSettings.enableSymbologiesForCompositeTypes(_barcodeCaptureSettings.enabledCompositeTypes);
    applyBarcodeCaptureSettings();
  }

  void disableCompositeType(CompositeType compositeType) {
    for (var symbology in _barcodeCaptureSettings.enabledSymbologies) {
      _barcodeCaptureSettings.enableSymbology(symbology, false);
    }
    _barcodeCaptureSettings.enabledCompositeTypes.remove(compositeType);
    _barcodeCaptureSettings.enableSymbologiesForCompositeTypes(_barcodeCaptureSettings.enabledCompositeTypes);
    applyBarcodeCaptureSettings();
  }

  bool isCompositeTypeEnabled(CompositeType compositeType) {
    return _barcodeCaptureSettings.enabledCompositeTypes.contains(compositeType);
  }

  // COMPOSITE TYPES - END

  // SCAN AREA - START

  DoubleWithUnit get scanAreaTopMargin {
    return _dataCaptureView.scanAreaMargins.top;
  }

  set scanAreaTopMargin(DoubleWithUnit topMargin) {
    _dataCaptureView.scanAreaMargins =
        MarginsWithUnit(scanAreaLeftMargin, topMargin, scanAreaRightMargin, scanAreaBottomMargin);
  }

  DoubleWithUnit get scanAreaBottomMargin {
    return _dataCaptureView.scanAreaMargins.bottom;
  }

  set scanAreaBottomMargin(DoubleWithUnit bottomMargin) {
    _dataCaptureView.scanAreaMargins =
        MarginsWithUnit(scanAreaLeftMargin, scanAreaTopMargin, scanAreaRightMargin, bottomMargin);
  }

  DoubleWithUnit get scanAreaLeftMargin {
    return _dataCaptureView.scanAreaMargins.left;
  }

  set scanAreaLeftMargin(DoubleWithUnit leftMargin) {
    _dataCaptureView.scanAreaMargins =
        MarginsWithUnit(leftMargin, scanAreaTopMargin, scanAreaRightMargin, scanAreaBottomMargin);
  }

  DoubleWithUnit get scanAreaRightMargin {
    return _dataCaptureView.scanAreaMargins.right;
  }

  set scanAreaRightMargin(DoubleWithUnit rightMargin) {
    _dataCaptureView.scanAreaMargins =
        MarginsWithUnit(scanAreaLeftMargin, scanAreaTopMargin, rightMargin, scanAreaBottomMargin);
  }

  bool get shouldShowScanAreaGuides {
    return _overlay.shouldShowScanAreaGuides;
  }

  set shouldShowScanAreaGuides(bool newValue) {
    _overlay.shouldShowScanAreaGuides = newValue;
  }

  // SCAN AREA - END

  // POINT OF INTEREST- START

  DoubleWithUnit get pointOfInterestX {
    return _dataCaptureView.pointOfInterest.x;
  }

  set pointOfInterestX(DoubleWithUnit newValue) {
    _dataCaptureView.pointOfInterest = PointWithUnit(newValue, pointOfInterestY);
  }

  DoubleWithUnit get pointOfInterestY {
    return _dataCaptureView.pointOfInterest.y;
  }

  set pointOfInterestY(DoubleWithUnit newValue) {
    _dataCaptureView.pointOfInterest = PointWithUnit(pointOfInterestX, newValue);
  }

  // POINT OF INTEREST - END

  // VIEWFINDER - START

  Viewfinder? get currentViewfinder {
    return _overlay.viewfinder;
  }

  set currentViewfinder(Viewfinder? newViewfinder) {
    _overlay.viewfinder = newViewfinder;
  }

  Color get aimerDotColor {
    return _aimerViewfinder.dotColor;
  }

  final Color aimerDefaultDotColor = AimerViewfinder().dotColor;

  set aimerDotColor(Color newColor) {
    _aimerViewfinder.dotColor = newColor;
  }

  final Color aimerDefaultFrameColor = AimerViewfinder().frameColor;

  Color get aimerFrameColor {
    return _aimerViewfinder.frameColor;
  }

  set aimerFrameColor(Color newColor) {
    _aimerViewfinder.frameColor = newColor;
  }

  LaserlineViewfinderStyle get laserlineStyle {
    return _laserlineViewfinder.style;
  }

  set laserlineStyle(LaserlineViewfinderStyle newStyle) {
    currentViewfinder = LaserlineViewfinder.withStyle(newStyle);
  }

  DoubleWithUnit get laserlineWidth {
    return _laserlineViewfinder.width;
  }

  set laserlineWidth(DoubleWithUnit newValue) {
    _laserlineViewfinder.width = newValue;
  }

  final Color laserlineDefaultEnabledColor = LaserlineViewfinder().enabledColor;

  Color get laserlineEnabledColor {
    return _laserlineViewfinder.enabledColor;
  }

  set laserlineEnabledColor(Color newColor) {
    _laserlineViewfinder.enabledColor = newColor;
  }

  final Color laserlineDefaultDisabledColor = LaserlineViewfinder().disabledColor;

  Color get laserlineDisabledColor {
    return _laserlineViewfinder.disabledColor;
  }

  set laserlineDisabledColor(Color newColor) {
    _laserlineViewfinder.disabledColor = newColor;
  }

  RectangularViewfinderStyle get rectangularViewfinderStyle {
    return _rectangularViewfinder.style;
  }

  set rectangularViewfinderStyle(RectangularViewfinderStyle newStyle) {
    currentViewfinder = RectangularViewfinder.withStyle(newStyle);
  }

  RectangularViewfinderLineStyle get rectangularViewfinderLineStyle {
    return _rectangularViewfinder.lineStyle;
  }

  set rectangularViewfinderLineStyle(RectangularViewfinderLineStyle newStyle) {
    currentViewfinder = RectangularViewfinder.withStyleAndLineStyle(rectangularViewfinderStyle, newStyle);
  }

  double get rectangularViewfinderDimming {
    return _rectangularViewfinder.dimming;
  }

  set rectangularViewfinderDimming(double newValue) {
    _rectangularViewfinder.dimming = newValue;
  }

  Color get rectangularViewfinderColor {
    return _rectangularViewfinder.color;
  }

  set rectangularViewfinderColor(Color newColor) {
    _rectangularViewfinder.color = newColor;
  }

  bool get rectangularViewfinderAnimationEnabled {
    return _rectangularViewfinder.animation != null;
  }

  set rectangularViewfinderAnimationEnabled(bool enabled) {
    _rectangularViewfinder.animation = enabled ? RectangularViewfinderAnimation(isLooping: false) : null;
  }

  bool get rectangularViewfinderAnimationIsLooping {
    return _rectangularViewfinder.animation?.isLooping == true;
  }

  set rectangularViewfinderAnimationIsLooping(bool isLooping) {
    _rectangularViewfinder.animation = RectangularViewfinderAnimation(isLooping: isLooping);
  }

  SizingMode get rectangularViewfinderSizingMode {
    return _rectangularViewfinder.sizeWithUnitAndAspect.sizingMode;
  }

  set rectangularViewfinderSizingMode(SizingMode newMode) {
    _setRectangularViewfiniderSize(newMode);
  }

  void _setRectangularViewfiniderSize(SizingMode mode) {
    switch (mode) {
      case SizingMode.widthAndHeight:
        _rectangularViewfinder.setSize(SizeWithUnit(rectangularViewfinderWidth, rectangularViewfinderHeight));
        break;
      case SizingMode.widthAndAspectRatio:
        _rectangularViewfinder.setWidthAndAspectRatio(rectangularViewfinderWidth, rectangularViewfinderHeightAspect);
        break;
      case SizingMode.heightAndAspectRatio:
        _rectangularViewfinder.setHeightAndAspectRatio(rectangularViewfinderHeight, rectangularViewfinderWidthAspect);
        break;
      case SizingMode.shorterDimensionAndAspectRatio:
        _rectangularViewfinder.setShorterDimensionAndAspectRatio(
            _rectangularViewfinderShorterDimension, _rectangularViewfinderLongerDimensionAspect);
        break;
    }
  }

  DoubleWithUnit _rectangularViewfinderWidth =
      RectangularViewfinder().sizeWithUnitAndAspect.widthAndHeight?.width ?? DoubleWithUnit.zero;

  DoubleWithUnit _rectangularViewfinderHieght =
      RectangularViewfinder().sizeWithUnitAndAspect.widthAndHeight?.height ?? DoubleWithUnit.zero;

  double _rectangularViewfinderWidthAspect = 0;
  double _rectangularViewfinderHeightAspect = 0;
  double _rectangularViewfinderShorterDimension = 0;
  double _rectangularViewfinderLongerDimensionAspect = 0;

  DoubleWithUnit get rectangularViewfinderWidth {
    return _rectangularViewfinderWidth;
  }

  set rectangularViewfinderWidth(DoubleWithUnit newWidth) {
    _rectangularViewfinderWidth = newWidth;
    _setRectangularViewfiniderSize(rectangularViewfinderSizingMode);
  }

  double get rectangularViewfinderWidthAspect {
    return _rectangularViewfinderWidthAspect;
  }

  set rectangularViewfinderWidthAspect(double newValue) {
    _rectangularViewfinderWidthAspect = newValue;
    _setRectangularViewfiniderSize(rectangularViewfinderSizingMode);
  }

  double get rectangularViewfinderHeightAspect {
    return _rectangularViewfinderHeightAspect;
  }

  set rectangularViewfinderHeightAspect(double newValue) {
    _rectangularViewfinderHeightAspect = newValue;
    _setRectangularViewfiniderSize(rectangularViewfinderSizingMode);
  }

  DoubleWithUnit get rectangularViewfinderHeight {
    return _rectangularViewfinderHieght;
  }

  set rectangularViewfinderHeight(DoubleWithUnit newHeight) {
    _rectangularViewfinderHieght = newHeight;
    _setRectangularViewfiniderSize(rectangularLocationSelectionSizeMode);
  }

  double get rectangularViewfinderShorterDimension {
    return _rectangularViewfinderShorterDimension;
  }

  set rectangularViewfinderShorterDimension(double newValue) {
    _rectangularViewfinderShorterDimension = newValue;
    _setRectangularViewfiniderSize(rectangularLocationSelectionSizeMode);
  }

  double get rectangularViewfinderLongerDimensionAspect {
    return _rectangularViewfinderLongerDimensionAspect;
  }

  set rectangularViewfinderLongerDimensionAspect(double newValue) {
    _rectangularViewfinderLongerDimensionAspect = newValue;
    _setRectangularViewfiniderSize(rectangularLocationSelectionSizeMode);
  }

  final Color rectangularViewfinderDefaultColor = RectangularViewfinder().color;

  AimerViewfinder get _aimerViewfinder {
    return _overlay.viewfinder as AimerViewfinder;
  }

  LaserlineViewfinder get _laserlineViewfinder {
    return _overlay.viewfinder as LaserlineViewfinder;
  }

  RectangularViewfinder get _rectangularViewfinder {
    return _overlay.viewfinder as RectangularViewfinder;
  }

  // VIEWFINDER - END

  // LOGO - START

  Anchor get currentLogoAnchor {
    return _dataCaptureView.logoAnchor;
  }

  set currentLogoAnchor(Anchor newAnchor) {
    _dataCaptureView.logoAnchor = newAnchor;
  }

  DoubleWithUnit get logoOffsetX {
    return _dataCaptureView.logoOffset.x;
  }

  set logoOffsetX(DoubleWithUnit newValue) {
    _dataCaptureView.logoOffset = PointWithUnit(newValue, logoOffsetY);
  }

  DoubleWithUnit get logoOffsetY {
    return _dataCaptureView.logoOffset.y;
  }

  set logoOffsetY(DoubleWithUnit newValue) {
    _dataCaptureView.logoOffset = PointWithUnit(logoOffsetX, newValue);
  }

  // LOGO - END

  // GESTURES - START

  FocusGesture? get focusGesture {
    return _dataCaptureView.focusGesture;
  }

  set focusGesture(FocusGesture? newValue) {
    _dataCaptureView.focusGesture = newValue;
  }

  ZoomGesture? get zoomGesture {
    return _dataCaptureView.zoomGesture;
  }

  set zoomGesture(ZoomGesture? newValue) {
    _dataCaptureView.zoomGesture = newValue;
  }

  // GESTURES - END

  // CONTROLS - START

  TorchSwitchControl? _torchControl = null;

  bool get torchControlEnabled {
    return _torchControl != null;
  }

  set torchControlEnabled(bool newValue) {
    if (newValue) {
      var torchControl = TorchSwitchControl();
      _dataCaptureView.addControl(torchControl);
      _torchControl = torchControl;
    } else {
      if (_torchControl != null) {
        _dataCaptureView.removeControl(_torchControl!);
        _torchControl = null;
      }
    }
  }

  // CONTROLS - END

  SymbologySettings getSymbologySettings(Symbology symbology) {
    return _barcodeCaptureSettings.settingsForSymbology(symbology);
  }

  void applyCameraSettings() {
    _camera?.applySettings(_cameraSettings);
  }

  void applyBarcodeCaptureSettings() {
    _barcodeCapture.applySettings(_barcodeCaptureSettings);
  }

  void init() {
    _camera?.applySettings(_cameraSettings);

    // Create data capture context using your license key and set the camera as the frame source.
    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);
    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    // Create new barcode capture mode with the initial settings
    _barcodeCapture = BarcodeCapture.forContext(_dataCaptureContext, _barcodeCaptureSettings);

    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(dataCaptureContext);

    _overlay = BarcodeCaptureOverlay.withBarcodeCaptureForView(_barcodeCapture, _dataCaptureView)
      ..brush = this.defaultBrush;
  }
}
