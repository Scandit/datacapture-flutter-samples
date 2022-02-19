/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum ICRoutes { Home, Result }

extension RoutesValue on ICRoutes {
  String get routeName {
    switch (this) {
      case ICRoutes.Home:
        return '/';
      case ICRoutes.Result:
        return '/result';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case ICRoutes.Home:
        return 'IdCaptureExtended Sample';
      case ICRoutes.Result:
        return 'Scan Result';
      default:
        return 'IdCaptureExtended Sample';
    }
  }
}
