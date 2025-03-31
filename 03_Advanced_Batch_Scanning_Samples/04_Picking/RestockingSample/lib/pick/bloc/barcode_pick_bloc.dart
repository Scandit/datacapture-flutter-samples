/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/bloc/bloc_base.dart';
import 'package:RestockingSample/models/products_manager.dart';
import 'package:RestockingSample/pick/models/barcode_pick_manager.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodePickBloc extends Bloc
    implements BarcodePickAsyncMapperProductProviderCallback, BarcodePickScanningListener {
  BarcodePickManager _pickManager = BarcodePickManager();
  ProductsManager _productsManager = ProductsManager();

  late BarcodePick _barcodePick;

  BarcodePick get barcodePick => _barcodePick;

  DataCaptureContext get dataCaptureContext => _pickManager.dataCaptureContext;

  BarcodePickBloc() {
    _barcodePick = _pickManager.createBarcodePick(this);
    _barcodePick.addScanningListener(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void productIdentifierForItems(List<String> itemsData, BarcodePickProductProviderCallback callback) {
    _productsManager.convertBarcodesToCallbackItems(itemsData, callback);
  }

  void pickItem(String itemData, BarcodePickActionCallback callback) {
    _productsManager.pickItem(itemData, callback);
  }

  void unpickItem(String itemData, BarcodePickActionCallback callback) {
    _productsManager.unpickItem(itemData, callback);
  }

  void setAllScannedCodes(Set<String> scannedItems) {}

  void setAllPickedCodes(Set<String> pickedItems) {}

  @override
  void didCompleteScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session) {
    // not relevant in this sample
  }

  @override
  void didUpdateScanningSession(BarcodePick barcodePick, BarcodePickScanningSession session) {
    _productsManager.setAllScannedCodes(session.scannedItems);
    _productsManager.setAllPickedCodes(session.pickedItems);
  }
}
