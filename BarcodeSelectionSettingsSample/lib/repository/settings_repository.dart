/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:math';
import 'dart:ui';

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// There is a Scandit sample license key set below here.
// This license key is enabled for sample evaluation only.
// If you want to build your own application, get your license key by signing up for a trial at https://ssl.scandit.com/dashboard/sign-up?p=test
const String licenseKey = 'AQIzpSC5AyYeKA6KZgjthjEmMbJBFJEpiUUjkCJu72AUVSWyGjN0xNt0OVgASxKO6FwLejYDRFGraFReiUwL8wp3a8mgX0elHhmx0JhY/QYrbQHJjGIhQAhjcW1cYr+ogWCDUmhM2KuWPlJXBkSGmbwinMAqKusC5zQHGoY6JDKJXbzv97CRhGdjlfgjhTZErgfs+P/fLp0cCCAmP+TTZ6jiyA/my9Ojy7ugt7DKay2ZAkezAO8OwAtnl0GUIflPz6KI68hRPaAV18wwS030+riqfDIcFQ+3BAfqRMpJxrYfKZOvvwyTAbC+5ZzgFmwd9YR0vbFToSmHDemEyRVufdMw0s+jqCHsCY5ox8jBfV1RkmDQxCckkJoS3rhPmLgEyiTm+gI0y30swn2orZ4aaml+aoA55vhN4jY+ZAkMkmhipAXK/TMzyHo4iUDA4/v3TgiJbodw27iI/+f6YxIpA+/nAEItRH7C3vuxAdo8lmk5q0QeCkc6QA0FhQa6S/cu8yrehTi+Lb8khFmt3gkwEubowGdg3cg8KoBsDgY59lAKWy55rmVznq7REv6ugw1KwgW724K4s5ILfgQ2NcV/jFgeTReaTSVYUWKZGXdJmDrteX7tgmdfkpjaCrijgSGwYRaATxVKitCYIPyfuipsSHdC0iLqCoJ8CIc2UclvimPXDzDLk83uIRFjgspykVm+eIsKiMuxrW6OlB7o7NWPcJtEcyO74Mq6scB8+bWP5eJFIPazUcZEtxG2u3UpWz7+EoBADwbUI9G63HcTwt2bi8JZo16pfGxsWti3DJ1HWooGSIVvyZ2jePvhBcuu+EbtOucgdPDvDTCTpm/V';

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

  // The barcode selection process is configured through barcode selection settings
  // which are then applied to the barcode selection instance that manages barcode selection.
  final BarcodeSelectionSettings _barcodeSelectionSettings = BarcodeSelectionSettings();

  final CameraSettings _cameraSettings = BarcodeCapture.recommendedCameraSettings;

  late BarcodeSelection _barcodeSelection;

  late DataCaptureView _dataCaptureView;

  late BarcodeSelectionBasicOverlay _overlay;

  DataCaptureContext get dataCaptureContext {
    return _dataCaptureContext;
  }

  DataCaptureView get dataCaptureView {
    return _dataCaptureView;
  }

  BarcodeSelection get barcodeSelection {
    return _barcodeSelection;
  }

  Camera? get camera {
    return _camera;
  }

  final scanditBlueColor = Color(0x8039c1cc);

  // CAMERA SETTINGS - Start

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

  FocusRange get focusRange {
    return _cameraSettings.focusRange;
  }

  set focusRange(FocusRange newValue) {
    _cameraSettings.focusRange = newValue;
    applyCameraSettings();
  }

  // CAMERA SETTINGS - End

  // SYMBOLOGIES SETTINGS - Start

  bool isSymbologyEnabled(Symbology symbology) {
    return getSymbologySettings(symbology).isEnabled;
  }

  void enableSymbology(Symbology symbology, bool enabled) {
    _barcodeSelectionSettings.enableSymbology(symbology, enabled);
  }

  void enableSymbologies(List<Symbology> symbologies) {
    _barcodeSelectionSettings.enableSymbologies(symbologies.toSet());
  }

  bool isExtensionEnabled(Symbology symbology, String extension) {
    return getSymbologySettings(symbology).enabledExtensions.contains(extension);
  }

  void setExtensionEnabled(Symbology symbology, String extension, bool enabled) {
    getSymbologySettings(symbology).setExtensionEnabled(extension, enabled: enabled);
    applyBarcodeSelectionSettings();
  }

  bool isColorInvertedEnabled(Symbology symbology) {
    return getSymbologySettings(symbology).isColorInvertedEnabled;
  }

  void setColorInverted(Symbology symbology, bool colorInvertible) {
    getSymbologySettings(symbology).isColorInvertedEnabled = colorInvertible;
    applyBarcodeSelectionSettings();
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
    applyBarcodeSelectionSettings();
  }

  // SYMBOLOGIES SETTINGS - End

  // SELECTION TYPE SETTINGS - Start

  BarcodeSelectionType get selectionType {
    return _barcodeSelectionSettings.selectionType;
  }

  set selectionType(BarcodeSelectionType newSelectionType) {
    _barcodeSelectionSettings.selectionType = newSelectionType;
    applyBarcodeSelectionSettings();
  }

  // SELECTION TYPE SETTINGS - End

  // SINGLE BARCODE AUTO DETECTION SETTINGS - Start

  bool get singleBarcodeAutoDetection {
    return _barcodeSelectionSettings.singleBarcodeAutoDetection;
  }

  set singleBarcodeAutoDetection(bool newValue) {
    _barcodeSelectionSettings.singleBarcodeAutoDetection = newValue;
    applyBarcodeSelectionSettings();
  }

  // SINGLE BARCODE AUTO DETECTION SETTINGS - End

  // FEEDBACK - Start

  bool get isSoundOn {
    return _barcodeSelection.feedback.selection.sound != null;
  }

  set isSoundOn(bool newValue) {
    var vibration = _barcodeSelection.feedback.selection.vibration;
    _barcodeSelection.feedback = BarcodeSelectionFeedback()
      ..selection = Feedback(vibration, newValue ? Sound.defaultSound : null);
  }

  bool get isVibrationOn {
    return _barcodeSelection.feedback.selection.vibration != null;
  }

  set isVibrationOn(bool newValue) {
    var sound = _barcodeSelection.feedback.selection.sound;
    _barcodeSelection.feedback = BarcodeSelectionFeedback()
      ..selection = Feedback(newValue ? Vibration.defaultVibration : null, sound);
  }

  // FEEDBACK - End

  // CODE DUPLICATE FILTER - Start

  int get codeDuplicateFilter {
    return _barcodeSelectionSettings.codeDuplicateFilter.inMilliseconds;
  }

  set codeDuplicateFilter(int newValue) {
    _barcodeSelectionSettings.codeDuplicateFilter = Duration(milliseconds: newValue);
    applyBarcodeSelectionSettings();
  }

  // CODE DUPLICATE FILTER - End

  // BARCODE SELECTION POINT OF INTEREST - Start

  PointWithUnit? get barcodeSelectionPointOfInterest {
    return _barcodeSelection.pointOfInterest;
  }

  set barcodeSelectionPointOfInterest(PointWithUnit? newValue) {
    _barcodeSelection.pointOfInterest = newValue;
  }

  // BARCODE SELECTION POINT OF INTEREST - End

  // SCAN AREA - Start

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

  // SCAN AREA - End

  // POINT OF INTEREST- Start

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

  // POINT OF INTEREST - End

  // OVERLAY SETTINGS - Start

  late Brush _defaultTrackedBrush;

  Brush get defaultTrackedBrush {
    return _defaultTrackedBrush;
  }

  late Brush _defaultAimedBrush;

  Brush get defaultAimedBrush {
    return _defaultAimedBrush;
  }

  late Brush _defaultSelectingBrush;

  Brush get defaultSelectingBrush {
    return _defaultSelectingBrush;
  }

  late Brush _defaultSelectedBrush;

  Brush get defaultSelectedBrush {
    return _defaultSelectedBrush;
  }

  BarcodeSelectionBasicOverlayStyle get overlayStyle {
    return _overlay.style;
  }

  set overlayStyle(BarcodeSelectionBasicOverlayStyle newStyle) {
    dataCaptureView.removeOverlay(_overlay);
    var shouldShowScanAreaGuides = _overlay.shouldShowScanAreaGuides;
    var viewfinder = _overlay.viewfinder as AimerViewfinder;
    _overlay =
        BarcodeSelectionBasicOverlay.withBarcodeSelectionForViewWithStyle(barcodeSelection, dataCaptureView, newStyle);
    _overlay.shouldShowScanAreaGuides = shouldShowScanAreaGuides;
    (_overlay.viewfinder as AimerViewfinder).dotColor = viewfinder.dotColor;
    (_overlay.viewfinder as AimerViewfinder).frameColor = viewfinder.frameColor;
  }

  Brush get trackedBrush {
    return _overlay.trackedBrush;
  }

  set trackedBrush(Brush newBrush) {
    _overlay.trackedBrush = newBrush;
  }

  Brush get aimedBrush {
    return _overlay.aimedBrush;
  }

  set aimedBrush(Brush newBrush) {
    _overlay.aimedBrush = newBrush;
  }

  Brush get selectingBrush {
    return _overlay.selectingBrush;
  }

  set selectingBrush(Brush newBrush) {
    _overlay.selectingBrush = newBrush;
  }

  Brush get selectedBrush {
    return _overlay.selectedBrush;
  }

  set selectedBrush(Brush newBrush) {
    _overlay.selectedBrush = newBrush;
  }

  late Color _defaultFrozenBackgroundColor;

  Color get defaultFrozenBackgroundColor {
    return _defaultFrozenBackgroundColor;
  }

  Color get frozenBackgroundColor {
    return _overlay.frozenBackgroundColor;
  }

  set frozenBackgroundColor(Color newValue) {
    _overlay.frozenBackgroundColor = newValue;
  }

  bool get shouldShowHints {
    return _overlay.shouldShowHints;
  }

  set shouldShowHints(bool newValue) {
    _overlay.shouldShowHints = newValue;
  }

  // OVERLAY SETTINGS - End

  // VIEWFINDER SETTINGS - Start

  late Color _defaultFrameColor;

  Color get defaultFrameColor {
    return _defaultFrameColor;
  }

  late Color _defaultDotColor;

  Color get defaultDotColor {
    return _defaultDotColor;
  }

  AimerViewfinder get _viewfinder {
    return _overlay.viewfinder as AimerViewfinder;
  }

  Color get frameColor {
    return _viewfinder.frameColor;
  }

  set frameColor(Color newColor) {
    _viewfinder.frameColor = newColor;
  }

  Color get dotColor {
    return _viewfinder.dotColor;
  }

  set dotColor(Color newColor) {
    _viewfinder.dotColor = newColor;
  }

  // VIEWFINDER SETTINGS - END

  SymbologySettings getSymbologySettings(Symbology symbology) {
    return _barcodeSelectionSettings.settingsForSymbology(symbology);
  }

  void applyCameraSettings() {
    _camera?.applySettings(_cameraSettings);
  }

  void applyBarcodeSelectionSettings() {
    _barcodeSelection.applySettings(_barcodeSelectionSettings);
  }

  void init() {
    // Default camera settings for this sample
    _cameraSettings.focusRange = FocusRange.far;
    _cameraSettings.zoomFactor = 1.0;

    _camera?.applySettings(_cameraSettings);

    // Create data capture context using your license key and set the camera as the frame source.
    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);
    if (_camera != null) _dataCaptureContext.setFrameSource(_camera!);

    _barcodeSelectionSettings.codeDuplicateFilter = Duration(milliseconds: 500);

    // Create new barcode selection mode with the initial settings
    _barcodeSelection = BarcodeSelection.forContext(_dataCaptureContext, _barcodeSelectionSettings);

    // To visualize the on-going barcode selection process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(dataCaptureContext);

    _overlay = BarcodeSelectionBasicOverlay.withBarcodeSelectionForViewWithStyle(
        _barcodeSelection, _dataCaptureView, BarcodeSelectionBasicOverlayStyle.frame);

    _defaultTrackedBrush = _overlay.trackedBrush;
    _defaultAimedBrush = _overlay.aimedBrush;
    _defaultSelectingBrush = _overlay.selectingBrush;
    _defaultSelectedBrush = _overlay.selectedBrush;
    _defaultFrozenBackgroundColor = _overlay.frozenBackgroundColor;
    _defaultFrameColor = _viewfinder.frameColor;
    _defaultDotColor = _viewfinder.dotColor;
  }
}
