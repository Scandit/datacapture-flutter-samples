/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';

abstract class ListItem {
  Widget? buildLeading(BuildContext context);

  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);

  Widget? buildTrailing(BuildContext context);
}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget? buildLeading(BuildContext context) => null;

  @override
  Widget buildTitle(BuildContext context) {
    return Text(heading, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
  }

  @override
  Widget buildSubtitle(BuildContext context) => Divider();

  @override
  Widget? buildTrailing(BuildContext context) => null;
}

class ProductItem implements ListItem {
  String identifier;
  int quantityToPick;
  String barcodeData;
  bool picked;

  ProductItem(this.identifier, this.quantityToPick, this.barcodeData, this.picked);

  Widget? buildLeading(BuildContext context) => Container(
        width: 48,
        height: 48,
        color: Colors.grey,
      );

  @override
  Widget buildTitle(BuildContext context) => Text(identifier);

  @override
  Widget buildSubtitle(BuildContext context) {
    var gtinText = Text('GTIN: ' + barcodeData);

    if (quantityToPick == 0 && picked) {
      // Need to display also a warning
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gtinText,
          Text(
            'Picked item not in pick list',
            style: TextStyle(fontSize: 12, color: Colors.red.shade200),
          ),
        ],
      );
    }
    return gtinText;
  }

  @override
  Widget? buildTrailing(BuildContext context) {
    if (quantityToPick == 0 && picked) {
      return Icon(
        Icons.warning,
        color: Colors.orange,
      );
    } else if (picked) {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }

    return null;
  }
}
