/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:ListBuildingSample/bloc/bloc_base.dart';
import 'package:ListBuildingSample/home/model/scanned_item.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_spark_scan.dart';

// There is a Scandit sample license key set below here.
// This license key is enabled for sample evaluation only.
// If you want to build your own application, get your license key by signing up for a trial at https://ssl.scandit.com/dashboard/sign-up?p=test
const String licenseKey = 'Aa2k0xbKMtvDJWNgLU02Cr8aLxUjNtOuqXCjHUxVAUf/d66Y5Tm74sJ+8L0rGQUZ20e52VlMY9I7YW4W13kWbvp36R8jbqQy6yZUGS50G5n4fRItJD6525RcbTYZQjoIGHQqle9jj08ra19ZUy9RliVlOn3hHz4WrGO8vORyATmFXJpULzk0I5RpiT84ckXhG2Ri8jtIzoISX3zsoiLtXVRGjjrkbuGZzGbKA180JKEpdfSQwVyupLti5yNYHAeKihS6IOklCTz8CM1BfRC4zBdIDjbVEJPFgAsLvMU0rTyJhHkB5Ds4wfHbKNFhW0T2XkYLKkvZ7X/HnEVD5oz9Kl4T4rtRkepJfsXUWHUgVugjLO5vqwhMcHNV5XpK2Pk/SLrzGF1PDRu8f4ZhBLrWKknWq+5TSK8GWi4wmGpVvbxqHhLljzOzplYs8I5TtphZ3otJNLs10lhk1YN9cmdaxpdUuF4k0WDU1Qfco75p5G+MBlsAVVFrs0xMF9fSMJkQ+4UU+G+py5781HPkpw4kaGwmJhGrzA/Lbhf4tL+XfynseLw42oygpfVabYEYRHSQx+1j5RpFSR6V9t4jlKsJu2xgYz0A96I82gIHItRRxZkT2oEsZCgYlgCiQsFcsFdo9N9bzDL9mVR5Nj0RPIVvKc01AVtKvXLx86g2rNPv45eBaJFrdsWmv97V8+Pv6M9d+Wr1qcTeT1BY8fvWUEDmU1HF6eCJ1A6cDAM+Nq4sAP9D2lH7D6rHwK+x07F56bMZibLeDoGKanE8PhhamhxBVemE/ByCoMoItBtSbpeBubHVsSHlGF3/AAKi6flY6j0htptgPOM8eOwGXx6YvVxu3KOMF+2RBIQai8LP0YEuhVJ0ST7WX5seeVSu5RMKUx/euHoQB6qID+ydzkXGzYZLTPPskmJSWqrboJQPIjZ/ruCtJepZ/+Lr7g5nCyb01w==';

class HomeBloc extends Bloc implements SparkScanListener, SparkScanFeedbackDelegate {
  // Create data capture context using your license key.
  final DataCaptureContext _dataCaptureContext = DataCaptureContext.forLicenseKey(licenseKey);

  DataCaptureContext get dataCaptureContext {
    return _dataCaptureContext;
  }

  late SparkScan _sparkScan;

  SparkScan get sparkScan {
    return _sparkScan;
  }

  late SparkScanViewSettings _sparkScanViewSettings;

  SparkScanViewSettings get sparkScanViewSettings {
    return _sparkScanViewSettings;
  }

  late StreamController<ScannedItem> _streamController;

  Stream<ScannedItem> get scannedItemsStream {
    return _streamController.stream;
  }

  HomeBloc() {
    _init();
  }

  void _init() {
    // The spark scan process is configured through SparkScan settings
    // which are then applied to the spark scan instance that manages the spark scan.
    var sparkScanSettings = new SparkScanSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled.
    // For the purpose of this sample we enable a very generous set of symbologies.
    // In your own app ensure that you only enable the symbologies that your app requires
    // as every additional enabled symbology has an impact on processing times.
    sparkScanSettings.enableSymbologies({
      Symbology.ean13Upca,
      Symbology.ean8,
      Symbology.upce,
      Symbology.code39,
      Symbology.code128,
      Symbology.interleavedTwoOfFive
    });

    // Some linear/1d barcode symbologies allow you to encode variable-length data.
    // By default, the Scandit Data Capture SDK only scans barcodes in a certain length range.
    // If your application requires scanning of one of these symbologies, and the length is
    // falling outside the default range, you may need to adjust the "active symbol counts"
    // for this symbology. This is shown in the following few lines of code for one of the
    // variable-length symbologies.
    var symbologySettings = sparkScanSettings.settingsForSymbology(Symbology.code39);
    symbologySettings.activeSymbolCounts = {7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

    // Create the spark scan instance.
    // Spark scan will automatically apply and maintain the optimal camera settings.
    _sparkScan = new SparkScan.withSettings(sparkScanSettings);

    // Register self as a listener to get informed of tracked barcodes.
    _sparkScan.addListener(this);

    // You can customize the SparkScanView using SparkScanViewSettings.
    _sparkScanViewSettings = new SparkScanViewSettings();

    // Setup stream controller to notify the UI of new scanned items
    _streamController = StreamController.broadcast();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  int _scannedItems = 0;

  @override
  void didScan(SparkScan sparkScan, SparkScanSession session, Future<FrameData> Function() getFrameData) {
    var barcode = session.newlyRecognizedBarcodes.firstOrNull;

    if (barcode == null) return;

    if (_isValidBarcode(barcode)) {
      _scannedItems += 1;

      var humanReadableSymbology = SymbologyDescription.forSymbology(barcode.symbology);

      _streamController
          .add(new ScannedItem("Item $_scannedItems", "${humanReadableSymbology.readableName}: ${barcode.data}"));
    }
  }

  bool _isValidBarcode(Barcode barcode) {
    return barcode.data != null && barcode.data != "123456789";
  }

  @override
  void didUpdateSession(SparkScan sparkScan, SparkScanSession session, Future<FrameData> Function() getFrameData) {
    // TODO: implement didUpdateSession
  }

  void clear() {
    _scannedItems = 0;
  }

  @override
  SparkScanBarcodeFeedback? feedbackForBarcode(Barcode barcode) {
    if (_isValidBarcode(barcode)) {
      return SparkScanBarcodeSuccessFeedback();
    } else {
      return SparkScanBarcodeErrorFeedback.fromMessage('This code should not have been scanned', Duration(seconds: 60));
    }
  }
}
