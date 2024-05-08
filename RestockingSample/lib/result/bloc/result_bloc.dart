/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/bloc/bloc_base.dart';
import 'package:RestockingSample/models/products_manager.dart';
import 'package:RestockingSample/result/models/list_item.dart';

import '../../models/product.dart';

class ResultBloc extends Bloc {
  ProductsManager _productsManager = ProductsManager();

  List<ListItem> _getItems() {
    return (_getPickedProducts() + _getInventoryList());
  }

  List<ListItem> get items => _getItems();

  /// Returns a list of scanned and not picked items.
  List<ListItem> _getInventoryList() {
    Set<String> pickedWithoutScannedCodes = _productsManager.allScannedCodes;
    pickedWithoutScannedCodes.removeAll(_productsManager.allPickedCodes);

    List<ListItem> scannedItems = [HeadingItem("Inventory (${pickedWithoutScannedCodes.length})")];

    for (var item in pickedWithoutScannedCodes) {
      var product = _productsManager.getProductForItemData(item);
      ProductItem productItem;
      if (product == null) {
        productItem = ProductItem('Unknown', 0, item, false);
      } else {
        productItem = product.getProductItem(item, false);
      }
      scannedItems.add(productItem);
    }
    return scannedItems;
  }

  /// Returns a list of all products that are picked.
  List<ListItem> _getPickedProducts() {
    List<ListItem> pickedItems = [HeadingItem("Picklist")];
    List<Product> pickedProducts = [];
    for (var item in _productsManager.allPickedCodes) {
      var product = _productsManager.getProductForItemData(item);

      if (product != null) {
        pickedProducts.add(product);
        int numberOfProductsInList = pickedProducts.where((element) => element.identifier == product.identifier).length;

        // Mark the product as picked only if the number products in the
        // displayed list is less or equal to quantity of products to pick.
        var picked = numberOfProductsInList <= product.quantityToPick;
        pickedItems.add(product.getProductItem(item, picked));
      } else {
        // No product matching item was found
        pickedItems.add(ProductItem("Unknown", 0, item, true));
      }
    }

    return pickedItems;
  }

  void clearPickedAndScanned() {
    _productsManager.clearPickedAndScanned();
  }
}
