/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../result/models/list_item.dart';

class Product {
  /// Identifier, must be unique per product.
  final String identifier;

  int quantityToPick;

  /// The content of the barcode that match the product. Multiple barcode can point to the same
  /// products.
  final List<String> barcodeData;

  Product(this.identifier, this.quantityToPick, this.barcodeData);

  ProductItem getProductItem(String itemData, bool picked) {
    return ProductItem(identifier, quantityToPick, itemData, picked);
  }
}
