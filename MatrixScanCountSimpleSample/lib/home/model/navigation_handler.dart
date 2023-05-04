/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../../result/model/scan_details.dart';

abstract class NavigationHandler {
  void navigateOnExitButtonTap(Map<String, ScanDetails> scannedItems);
  void navigateOnListButtonTap(Map<String, ScanDetails> scannedItems);
}
