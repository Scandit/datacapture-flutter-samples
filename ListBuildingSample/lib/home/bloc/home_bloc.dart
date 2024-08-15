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

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

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
    var barcode = session.newlyRecognizedBarcode;
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
