/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:ui';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

enum Discount {
  small,
  medium,
  large,
}

class DiscountData {
  final Discount discount;
  bool showingExpirationMessage = false;

  DiscountData({required this.discount});

  String getDisplayText(bool annotationBeingCreated) {
    if (annotationBeingCreated) showingExpirationMessage = false;

    final displayText = showingExpirationMessage ? _expirationDate : _expirationMessage;

    showingExpirationMessage = !showingExpirationMessage;

    return displayText;
  }

  String get percentage {
    switch (discount) {
      case Discount.small:
        return "25% off";
      case Discount.medium:
        return "50% off";
      case Discount.large:
        return "75% off";
    }
  }

  Color get color {
    switch (discount) {
      case Discount.small:
        return ColorDeserializer.fromRgbaHex('#FFDC32E6');
      case Discount.medium:
        return ColorDeserializer.fromRgbaHex('#FA8719E6');
      case Discount.large:
        return ColorDeserializer.fromRgbaHex('#FA4446E6');
    }
  }

  String get _expirationMessage {
    switch (discount) {
      case Discount.small:
        return "Expires in 3 days";
      case Discount.medium:
        return "Expires in 2 days";
      case Discount.large:
        return "Expires in 1 day";
    }
  }

  String get _expirationDate {
    final now = DateTime.now();
    final expiry = now.add(Duration(days: _daysUntilExpiry));
    final day = expiry.day.toString().padLeft(2, '0');
    final month = expiry.month.toString().padLeft(2, '0');
    final year = expiry.year.toString();
    return '$day/$month/$year';
  }

  int get _daysUntilExpiry {
    switch (discount) {
      case Discount.small:
        return 3;
      case Discount.medium:
        return 2;
      case Discount.large:
        return 1;
    }
  }
}
