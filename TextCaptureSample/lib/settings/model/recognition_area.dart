/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum Position { top, center, bottom }

class RecognitionArea {
  Position _position;

  RecognitionArea(this._position);

  Position get position {
    return _position;
  }

  String get displayName {
    if (_position == Position.top) {
      return 'Top';
    }

    if (_position == Position.bottom) {
      return 'Bottom';
    }

    if (_position == Position.center) {
      return 'Center';
    }

    throw UnimplementedError('No display name for ${_position} position.');
  }

  double get centerY {
    if (_position == Position.top) {
      return 0.25;
    }

    if (_position == Position.bottom) {
      return 0.75;
    }

    if (_position == Position.center) {
      return 0.5;
    }

    throw UnimplementedError('No center Y value for ${_position} position.');
  }
}
