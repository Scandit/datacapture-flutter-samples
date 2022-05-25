/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

enum AimerSelectionStrategy { auto, manual }

extension AimerSelectionStrategyPrettyPrint on AimerSelectionStrategy {
  String get name => _name();

  String _name() {
    switch (this) {
      case AimerSelectionStrategy.auto:
        return 'Auto';
      case AimerSelectionStrategy.manual:
        return 'Manual';
      default:
        throw Exception("Missing pretty name for '$this' aimer selection strategy type");
    }
  }
}
