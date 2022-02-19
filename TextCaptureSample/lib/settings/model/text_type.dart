/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum Mode { gs1Ai, lot }

class TextType {
  Mode _mode;

  TextType(this._mode);

  Mode get mode {
    return _mode;
  }

  String get displayName {
    if (_mode == Mode.gs1Ai) {
      return 'GS1 AI';
    }

    if (_mode == Mode.lot) {
      return 'LOT';
    }

    throw UnimplementedError('No display name found for ${_mode} capture mode');
  }

  String get regex {
    if (_mode == Mode.gs1Ai) {
      return '((\\\(\\\d+\\\)[\\\dA-Z]+)+)';
    }

    if (_mode == Mode.lot) {
      return '([A-Z0-9]{6,8})';
    }

    throw UnimplementedError('No regex found for ${_mode} capture mode');
  }
}
