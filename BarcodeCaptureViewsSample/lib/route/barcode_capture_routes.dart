/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum BCRoutes { Home, SplitView }

extension RoutesValue on BCRoutes {
  String get routeName {
    switch (this) {
      case BCRoutes.Home:
        return '/';
      case BCRoutes.SplitView:
        return '/bcSplitView';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case BCRoutes.Home:
        return 'Barcode Capture Views';
      case BCRoutes.SplitView:
        return 'Split View';
      default:
        return 'Barcode Capture';
    }
  }
}
