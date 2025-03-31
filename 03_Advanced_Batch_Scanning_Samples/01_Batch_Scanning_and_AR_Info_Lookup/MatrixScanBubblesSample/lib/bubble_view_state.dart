/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BubbleType { StockInfo, BarcodeData }

class BubbleViewState {
  var _state = BubbleType.StockInfo;

  BubbleViewState(this._state);

  void switchState() {
    switch (_state) {
      case BubbleType.StockInfo:
        _state = BubbleType.BarcodeData;
        break;
      default:
        _state = BubbleType.StockInfo;
        break;
    }
  }

  BubbleType get viewType {
    return _state;
  }
}
