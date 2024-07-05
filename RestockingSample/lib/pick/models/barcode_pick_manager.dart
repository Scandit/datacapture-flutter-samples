/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/models/products_manager.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class BarcodePickManager {
  static final BarcodePickManager _singleton = BarcodePickManager._internal();

  factory BarcodePickManager() {
    return _singleton;
  }

  late DataCaptureContext _captureContext;

  DataCaptureContext get dataCaptureContext => _captureContext;

  ProductsManager _productsManager = ProductsManager();

  BarcodePickManager._internal() {
    _captureContext = DataCaptureContext.forLicenseKey(licenseKey);
  }

  BarcodePick createBarcodePick(BarcodePickAsyncMapperProductProviderCallback callback) {
    // We first create settings and enable the symbologies we want to scan.
    var settings = BarcodePickSettings();
    settings.enableSymbologies({
      Symbology.ean13Upca,
      Symbology.ean8,
      Symbology.code39,
      Symbology.code128,
      Symbology.upce,
    });

    // We need the list of products that we want to pick.
    var products = _productsManager.getBarcodePickProducts();

    // We instantiate our product provider, responsible for matching barcodes and products.
    BarcodePickProductProvider provider = BarcodePickAsyncMapperProductProvider(products, callback);

    // And finally create BarcodePick
    return BarcodePick(_captureContext, settings, provider);
  }
}
