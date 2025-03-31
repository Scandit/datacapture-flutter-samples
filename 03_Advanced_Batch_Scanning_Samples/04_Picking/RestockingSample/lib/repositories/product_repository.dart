/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/models/product.dart';

/// Fake product repository class.
/// A real application would consider using a database or an API to query
/// for the list of products
class ProductRepository {
  final List<Product> _products;
  ProductRepository(this._products);

  Product? getProductForItemData(String itemData) {
    return _products
        .where(
          (element) => element.barcodeData.contains(itemData),
        )
        .firstOrNull;
  }

  List<Product> getAllProducts() {
    return _products;
  }

  Future<bool> verifyProductExists(String itemData) {
    // Here an API/Database call might be performed to check the product
    return Future(() => true);
  }

  int getProductsCount() {
    return _products.length;
  }
}
