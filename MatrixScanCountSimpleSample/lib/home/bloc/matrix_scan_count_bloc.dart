/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:matrixscancountsimplesample/bloc/bloc_base.dart';
import 'package:matrixscancountsimplesample/repository/barcode_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_count.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../model/navigation_handler.dart';

// There is a Scandit sample license key set below here.
// This license key is enabled for sample evaluation only.
// If you want to build your own application, get your license key by signing up for a trial at https://ssl.scandit.com/dashboard/sign-up?p=test
const String licenseKey = 'AYjTKgwFKLhZGtmHmyNAawklGVUpLfmaJ2JN39hPFcbHRdb8Sh3UX45m7PRkJtORsQzsAeBZw7aAZ/VBZlp5ykVZZOOYUI8ZAxAsZ3tOrh5HXX2CzFyh2yNzGtUXQuR5eFHqhXNx8+mfbsvN2zErPt0+TW4TESKXSx4764U8HnIF/01crbTR4/qxeWvIgdmGJkoV2YZc4wfZjpQI2Uvd3/J2jFcv/WrVHgWZ/VAC2lHTzC3JdwtTNJKxxDpsqKp1sDlARxGjw4hlebrAUbft3aWMjbtpVn2T4D+tBN3GVuwlD9Uo7MN3Sto17fSVSD1JLymYPHP7zxsnByy9mCBhKqTf3YKCh8DughdNJpIIWaaoY6t6OTof+TxY25XAboYM1Ii3FdaK1MjK2x9bVujInqaIYzPRYRwQj6lPyVaYSiRRJTsR6l3RLXyorSeqM6Mjyspyb9Gl3ht1grXe8TzMwVUFLYwBlV1zYcKfCVxHIaPo8irO1X7+sImu0166pNeK962FxzUx+rJMsvEIhy8mzF//yRI8WBLZvuBS5AH8EJHBb5p6DcdLgNVf3AwQWw6S5ENIw1Nu+eS2p+nm7msRRWP5jbqo8TfwgoellmtHaljlvmQ47kXfZvo9feDd7qZtGvWuX22yZkb+3k0OEfNKZaBKLrfzKU6X5TlmMvyhU7mF6mMdkBwex+NuKhRl1fYVjzD1hk75j70/QgXyjMv9nJpSEIXEt//AVHZTG4lGvAT0l3hPOie/zS0ixEH11+LJvbzsZQXYngggsJ40oCbajRxnvrMEcJQ5Lcxnp/Ov8qTmApOqK+XmLAV/s+MdeeIatFNTk6o9xGar+cB8';

class MatrixScanCountBloc implements Bloc, BarcodeCountListener, BarcodeCountViewListener, BarcodeCountViewUiListener {
  late DataCaptureContext _dataCaptureContext;
  late BarcodeCount _barcodeCount;

  Camera? _camera;

  BarcodeRepository _barcodeRepository = new BarcodeRepository();

  NavigationHandler _navigationHandler;

  MatrixScanCountBloc(this._navigationHandler) {
    _init();
  }

  void _init() {
    _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);

    // Use the default camera and set it as the frame source of the context.
    _camera = Camera.defaultCamera;

    // Use the recommended camera settings for the BarcodeCount mode.
    _camera?.applySettings(BarcodeCount.recommendedCameraSettings);

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _dataCaptureContext.setFrameSource(_camera!);
    }

    // The barcode count process is configured through barcode count settings
    // which are then applied to the barcode count instance that manages barcode count.
    BarcodeCountSettings barcodeCountSettings = new BarcodeCountSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled.
    // For the purpose of this sample we enable a very generous set of symbologies.
    // In your own app ensure that you only enable the symbologies that your app requires
    // as every additionals enabled symbology has an impact on processing times.
    barcodeCountSettings
        .enableSymbologies({Symbology.ean13Upca, Symbology.ean8, Symbology.upce, Symbology.code39, Symbology.code128});

    // Create barcode count and attach to context.
    _barcodeCount = BarcodeCount.forContext(dataCaptureContext, barcodeCountSettings);

    _barcodeRepository.initialize(_barcodeCount);

    didResume();
  }

  DataCaptureContext get dataCaptureContext {
    return _dataCaptureContext;
  }

  BarcodeCount get barcodeCount {
    return _barcodeCount;
  }

  void didResume() {
    _registerBarcodeCountListener();
    _barcodeCount.isEnabled = true;
    Permission.camera.request().isGranted.then((value) {
      if (value) {
        resumeFrameSource();
      }
    });
  }

  void didPause() {
    pauseFrameSource();
    _barcodeRepository.saveCurrentBarcodesAsAdditionalBarcodes();
    _barcodeCount.removeListener(this);
  }

  void _registerBarcodeCountListener() {
    _barcodeCount.addListener(this);
  }

  void _unregisterBarcodeCountListener() {
    _barcodeCount.removeListener(this);
  }

  void pauseFrameSource() {
    _camera?.switchToDesiredState(FrameSourceState.off);
  }

  void resumeFrameSource() {
    _camera?.switchToDesiredState(FrameSourceState.on);
  }

  @override
  Brush? brushForRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // No need to return a brush here, BarcodeCountViewStyle.ICON style is used
    return null;
  }

  @override
  Brush? brushForRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // No need to return a brush here, BarcodeCountViewStyle.ICON style is used
    return null;
  }

  @override
  Brush? brushForUnrecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // No need to return a brush here, BarcodeCountViewStyle.ICON style is used
    return null;
  }

  @override
  void didCompleteCaptureList(BarcodeCountView view) {
    // Not relevant in this sample
  }

  @override
  void didTapExitButton(BarcodeCountView view) {
    _unregisterBarcodeCountListener();
    _navigationHandler.navigateOnExitButtonTap(_barcodeRepository.getScanResults());
  }

  @override
  void didTapFilteredBarcode(BarcodeCountView view, TrackedBarcode filteredBarcode) {
    // Not relevant in this sample
  }

  @override
  void didTapListButton(BarcodeCountView view) {
    _unregisterBarcodeCountListener();
    _navigationHandler.navigateOnListButtonTap(_barcodeRepository.getScanResults());
  }

  @override
  void didTapRecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // Not relevant in this sample
  }

  @override
  void didTapRecognizedBarcodeNotInList(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // Not relevant in this sample
  }

  @override
  void didTapSingleScanButton(BarcodeCountView view) {
    // Not relevant in this sample
  }

  @override
  void didTapUnrecognizedBarcode(BarcodeCountView view, TrackedBarcode trackedBarcode) {
    // Not relevant in this sample
  }

  @override
  void didScan(BarcodeCount barcodeCount, BarcodeCountSession session, Future<FrameData> Function() getFrameData) {
    _barcodeRepository.updateWithSession(session);
  }

  Future<void> resetSession() {
    _registerBarcodeCountListener();
    _barcodeRepository.reset();
    return _barcodeCount.clearAdditionalBarcodes().then((value) => _barcodeCount.reset());
  }

  @override
  void dispose() {
    pauseFrameSource();
    _barcodeCount.removeListener(this);
    _dataCaptureContext.removeAllModes();
  }
}
