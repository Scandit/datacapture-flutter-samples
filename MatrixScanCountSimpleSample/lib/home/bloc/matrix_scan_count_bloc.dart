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
const String licenseKey = 'AZ707AsCLmJWHbYO4RjqcVAEgAxmNGYcF3Ytg4RiKa/lWTQ3IXkfVZhSSi0yOzuabn9STRdnzTLybIiJVkVZU2QK5jeqbn1HGCGXQ+9lqsN8VUaTw1IeuHJo+9mYVdv3I1DhedtSy89aKA4QugKI5d9ykKaXGohXjlI+PB5ju8Tyc80FPAC3WP9D8oKBcWyemTLQjoUu0Nl3T7mVyFIXMPshQeYddkjMQ1sVV9Jcuf1CbI9riUJWzbNUb4NcB4MoV0BHuyALUPtuM2+cBkX3bPN0AxjD9WC7KflL2UrsZeenvl/aDx2yU4t5vsa2BImNTyEqdVs+rmrGUzRdbYvSUFzKBeiBncLAASqnexTuSzh9KfEm/cKrVlWekP+zOkrilICkn3KVNY6g9RQd8FrsHTBI9OBbMpC79BTwuzHcnlFUG5S3ru/viJ2+f9JEEejxDbdJ7u4JohfBuUYBSEBQ/XzEPMdpqWcmxHGWF4j7jQy83B9Wlgrhd8xNWKjgAViI0bcebjnB7o6yuKacXICH/lo787RhnXSjqjQhJBCbEvwxHQZiEfWPdVKtY7EM+x8HFr6j3orKllKOMJ9asZ5bJYz9aIHlOWeRGm90guQn0KWiPwuKbUOQIMxFAOem2zcSTt4OfqS6Ci0Y6lk7FIrgpbaz8L1PW64kkjrZB6FtQ8OppmsyZ/QTvrHYFQFTH7MpamDviRjEKMyiD2ID6ypl+Meeme6cZYRJVujr6b4tweQCsfNEYhuDiMJaWQ57R0n2XdF0zkepLVc0yA2Q3wWhxSIASLnv6GTCYYVnDJnkrr6VaTv8RVUOp8h8U34wGDanamQ+39+rESMD59E288OKgFvZZWN9Ltu/VQCcjYCYT1RTDcA9co3Y18aGpDxvtLVEGJ8QDPv1E//IYAYEhXqu8r9xbsx/hTwZmLpNKyXGPRr9+hpufTAcAj908f2kuQ==';

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
