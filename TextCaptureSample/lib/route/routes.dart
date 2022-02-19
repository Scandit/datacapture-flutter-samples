/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum TCRoutes { Home, Settings }

extension RoutesValue on TCRoutes {
  String get routeName {
    switch (this) {
      case TCRoutes.Home:
        return '/';
      case TCRoutes.Settings:
        return '/settings';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case TCRoutes.Home:
        return 'Text Recognition';
      case TCRoutes.Settings:
        return 'Settings';
      default:
        return 'Text Recognition';
    }
  }
}
