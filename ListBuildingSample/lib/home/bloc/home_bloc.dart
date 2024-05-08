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
const String licenseKey = 'AZ707AsCLmJWHbYO4RjqcVAEgAxmNGYcF3Ytg4RiKa/lWTQ3IXkfVZhSSi0yOzuabn9STRdnzTLybIiJVkVZU2QK5jeqbn1HGCGXQ+9lqsN8VUaTw1IeuHJo+9mYVdv3I1DhedtSy89aKA4QugKI5d9ykKaXGohXjlI+PB5ju8Tyc80FPAC3WP9D8oKBcWyemTLQjoUu0Nl3T7mVyFIXMPshQeYddkjMQ1sVV9Jcuf1CbI9riUJWzbNUb4NcB4MoV0BHuyALUPtuM2+cBkX3bPN0AxjD9WC7KflL2UrsZeenvl/aDx2yU4t5vsa2BImNTyEqdVs+rmrGUzRdbYvSUFzKBeiBncLAASqnexTuSzh9KfEm/cKrVlWekP+zOkrilICkn3KVNY6g9RQd8FrsHTBI9OBbMpC79BTwuzHcnlFUG5S3ru/viJ2+f9JEEejxDbdJ7u4JohfBuUYBSEBQ/XzEPMdpqWcmxHGWF4j7jQy83B9Wlgrhd8xNWKjgAViI0bcebjnB7o6yuKacXICH/lo787RhnXSjqjQhJBCbEvwxHQZiEfWPdVKtY7EM+x8HFr6j3orKllKOMJ9asZ5bJYz9aIHlOWeRGm90guQn0KWiPwuKbUOQIMxFAOem2zcSTt4OfqS6Ci0Y6lk7FIrgpbaz8L1PW64kkjrZB6FtQ8OppmsyZ/QTvrHYFQFTH7MpamDviRjEKMyiD2ID6ypl+Meeme6cZYRJVujr6b4tweQCsfNEYhuDiMJaWQ57R0n2XdF0zkepLVc0yA2Q3wWhxSIASLnv6GTCYYVnDJnkrr6VaTv8RVUOp8h8U34wGDanamQ+39+rESMD59E288OKgFvZZWN9Ltu/VQCcjYCYT1RTDcA9co3Y18aGpDxvtLVEGJ8QDPv1E//IYAYEhXqu8r9xbsx/hTwZmLpNKyXGPRr9+hpufTAcAj908f2kuQ==';

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
