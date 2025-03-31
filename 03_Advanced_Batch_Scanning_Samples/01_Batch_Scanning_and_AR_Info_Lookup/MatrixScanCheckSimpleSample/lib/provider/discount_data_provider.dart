/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'discount_data.dart';

class DiscountDataProvider {
  static final DiscountDataProvider _instance = DiscountDataProvider._internal();

  factory DiscountDataProvider() {
    return _instance;
  }

  DiscountDataProvider._internal();

  final Map<String, DiscountData> _barcodeDiscounts = {};
  int _currentIndex = 0;

  // Get the information you want to show from your back end system/database.
  // In this sample we're just returning hardcoded data.
  DiscountData getDataForBarcode(Barcode barcode) {
    final barcodeData = barcode.data ?? '';

    if (_barcodeDiscounts.containsKey(barcodeData)) {
      return _barcodeDiscounts[barcodeData]!;
    }

    final discount = Discount.values[_currentIndex];
    final discountData = DiscountData(discount: discount);

    _barcodeDiscounts[barcodeData] = discountData;
    _currentIndex = (_currentIndex + 1) % Discount.values.length;

    return discountData;
  }
}
