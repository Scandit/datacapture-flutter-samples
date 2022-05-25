/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

enum SelectionType { tapToSelect, aimToSelect }

extension SelectionTypePrettyPrint on SelectionType {
  String get name => _name();

  String _name() {
    switch (this) {
      case SelectionType.aimToSelect:
        return 'Aim to Select';
      case SelectionType.tapToSelect:
        return 'Tap to Select';
      default:
        throw Exception("Missing pretty name for '$this' selection type");
    }
  }
}
