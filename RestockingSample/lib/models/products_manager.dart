/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
import 'dart:math';

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';

import '../repositories/product_repository.dart';

import 'product.dart';

class ProductsManager {
  static final ProductsManager _singleton = ProductsManager._();

  factory ProductsManager() {
    return _singleton;
  }

  late ProductRepository _repository;

  var _waitRandomizer = Random();

  Set<String> _allScannedCodes = {};

  Set<String> get allScannedCodes => _allScannedCodes;

  Set<String> _allPickedCodes = {};

  Set<String> get allPickedCodes => _allPickedCodes;

  ProductsManager._() {
    // Add your products here.
    // Product('Name', 'identifier', ['barcode1', 'barcode2', ..])
    _repository = ProductRepository([
      Product('Item A', 1, ['8414792869912', '3714711193285', '4951107312342', '1520070879331']),
      new Product('Item B', 1, ['1318890267144', '9866064348233', '4782150677788', '2371266523793']),
      new Product('Item C', 1, ['5984430889778', '7611879254123'])
    ]);
  }

  /// Creates the list of BarcodePickProduct that we need to pick.
  /// Returns a list of items that can directly be ingested when creating the BarcodePick object
  Set<BarcodePickProduct> getBarcodePickProducts() {
    return _repository.getAllProducts().map((e) => BarcodePickProduct(e.identifier, e.quantityToPick)).toSet();
  }

  /// Asynchronously match scanned barcode content with our products, to inform the UI if an item
  /// is searched for or not.
  /// [itemsData] The list of barcode to match against.
  /// [callback] The callback to call with the results.
  Future<void> convertBarcodesToCallbackItems(List<String> itemsData, BarcodePickProductProviderCallback callback) {
    return Future(() => _convertBarcodesToCallbackItems(itemsData)).then((value) => callback.onData(value));
  }

  List<BarcodePickProductProviderCallbackItem> _convertBarcodesToCallbackItems(List<String> itemsData) {
    List<BarcodePickProductProviderCallbackItem> callbackItems = [];
    for (var itemData in itemsData) {
      var product = _repository.getProductForItemData(itemData);

      if (product != null) {
        callbackItems.add(BarcodePickProductProviderCallbackItem(itemData, product.identifier));
      } else {
        callbackItems.add(BarcodePickProductProviderCallbackItem(itemData, null));
      }
    }

    return callbackItems;
  }

  /// Mark a product as picked. Artificially introduce a lag to simulate a network connection.
  /// [itemData] The barcode content of the item that was tapped in the BarcodePick UI.
  /// [callback] The callback to call with the results.
  Future<void> pickItem(String itemData, BarcodePickActionCallback callback) {
    return Future.delayed(Duration(milliseconds: 250 + _waitRandomizer.nextInt(500)))
        .then((value) => _pickItem(itemData).then((value) => callback.didFinish(value)));
  }

  Future<bool> _pickItem(String itemData) {
    return _repository.verifyProductExists(itemData);
  }

  /// Unpick a product. Artificially introduce a lag to simulate a network connection.
  /// [itemData] The barcode content of the item that was tapped in the BarcodePick UI.
  /// [callback] The callback to call with the results.
  Future<void> unpickItem(String itemData, BarcodePickActionCallback callback) {
    return Future.delayed(Duration(milliseconds: 250 + _waitRandomizer.nextInt(500)))
        .then((value) => _unpickItem(itemData).then((value) => callback.didFinish(value)));
  }

  Future<bool> _unpickItem(String itemData) {
    return _repository.verifyProductExists(itemData);
  }

  void setAllScannedCodes(Set<String> scannedItems) {
    _allScannedCodes = scannedItems;
  }

  void setAllPickedCodes(Set<String> pickedItems) {
    _allPickedCodes = pickedItems;
  }

  Product? getProductForItemData(String item) {
    return _repository.getProductForItemData(item);
  }

  void clearPickedAndScanned() {
    _allPickedCodes.clear();
    _allScannedCodes.clear();
  }
}
