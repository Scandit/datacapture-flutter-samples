/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:matrixscancountsimplesample/result/model/scan_details.dart';

abstract class ListItem {
  ScanDetails get scanDetail;
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
  Widget buildLeading(BuildContext context);
  Widget buildTrailing(BuildContext context);
}

class UniqueItem implements ListItem {
  final ScanDetails _scanDetail;
  final int _uniqueIndex;

  UniqueItem(this._scanDetail, this._uniqueIndex);

  @override
  Widget buildTitle(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 5.0), child: Text('Item $_uniqueIndex'));
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text('${scanDetail.symbology}: ${scanDetail.barcodeData}'.toUpperCase());
  }

  @override
  Widget buildLeading(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(38, 38),
      child: ColoredBox(color: Colors.black12),
    );
  }

  @override
  Widget buildTrailing(BuildContext context) {
    return Text('Qty: ${scanDetail.quantity}');
  }

  @override
  ScanDetails get scanDetail => _scanDetail;
}

class NonUniqueItem implements ListItem {
  final ScanDetails _scanDetail;
  final int _nonUniqueIndex;

  NonUniqueItem(this._scanDetail, this._nonUniqueIndex);

  @override
  Widget buildTitle(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          'Non-unique item $_nonUniqueIndex',
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text('${_scanDetail.symbology}: ${_scanDetail.barcodeData}'.toUpperCase());
  }

  @override
  Widget buildLeading(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(38, 38),
      child: ColoredBox(color: Colors.black12),
    );
  }

  @override
  Widget buildTrailing(BuildContext context) {
    return Text('Qty: ${_scanDetail.quantity}');
  }

  @override
  ScanDetails get scanDetail => _scanDetail;
}
