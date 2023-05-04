/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

class ScanDetails {
  final String _barcodeData;
  final String _symbology;
  int _quantity = 1;

  ScanDetails(this._barcodeData, this._symbology) {
    this._quantity = 1;
  }

  void increaseQuantity() {
    this._quantity += 1;
  }

  String get barcodeData => _barcodeData;

  String get symbology => _symbology;

  int get quantity => _quantity;
}
