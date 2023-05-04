/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum SampleRoutes { Home, Results }

extension RoutesValue on SampleRoutes {
  String get routeName {
    switch (this) {
      case SampleRoutes.Home:
        return '/';
      case SampleRoutes.Results:
        return '/scanResults';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case SampleRoutes.Home:
        return 'MatrixScan Count';
      case SampleRoutes.Results:
        return 'Scan Results';
      default:
        return 'MatrixScan Count';
    }
  }
}
