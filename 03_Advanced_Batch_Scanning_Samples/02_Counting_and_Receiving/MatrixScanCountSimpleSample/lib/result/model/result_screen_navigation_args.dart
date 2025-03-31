/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../../result/model/scan_details.dart';

class ResultScreenNavigationArgs {
  Map<String, ScanDetails> scannedItems;
  DoneButtonStyle doneButtonStyle;

  ResultScreenNavigationArgs(this.scannedItems, this.doneButtonStyle);
}

enum DoneButtonStyle { resume, newScan }
