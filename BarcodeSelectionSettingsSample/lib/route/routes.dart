/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

enum BSRoutes {
  Home,
  Settings,
  BarcodeSelectionSettings,
  CameraSettings,
  ViewSettings,
  Symbologies,
  SelectionType,
  SingleBarcodeAutoDetection,
  Feedback,
  CodeDuplicateFilter,
  PointOfInterest,
  ScanArea,
  ViewPointOfInterest,
  Overlay,
  Viewfinder,
}

extension RoutesValue on BSRoutes {
  String get routeName {
    switch (this) {
      case BSRoutes.Home:
        return '/';
      case BSRoutes.Settings:
        return '/settings';
      case BSRoutes.BarcodeSelectionSettings:
        return '/selection-settings';
      case BSRoutes.CameraSettings:
        return '/camera-settings';
      case BSRoutes.ViewSettings:
        return '/view-settings';
      case BSRoutes.Symbologies:
        return '/symbologies-settings';
      case BSRoutes.SelectionType:
        return '/selection-type-settings';
      case BSRoutes.SingleBarcodeAutoDetection:
        return '/single-barcode-auto-detection-settings';
      case BSRoutes.Feedback:
        return '/feedback-settings';
      case BSRoutes.CodeDuplicateFilter:
        return '/code-duplicate-filter-settings';
      case BSRoutes.PointOfInterest:
        return '/point-of-interest-settings';
      case BSRoutes.ScanArea:
        return '/scan-area-settings';
      case BSRoutes.ViewPointOfInterest:
        return '/view-point-of-interest-settings';
      case BSRoutes.Overlay:
        return '/overlay-settings';
      case BSRoutes.Viewfinder:
        return '/view-finder-settings';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case BSRoutes.Home:
        return 'Barcode Selection Settings';
      case BSRoutes.Settings:
        return 'Settings';
      case BSRoutes.BarcodeSelectionSettings:
        return 'Barcode Selection';
      case BSRoutes.CameraSettings:
        return 'Camera';
      case BSRoutes.ViewSettings:
        return 'View';
      case BSRoutes.Symbologies:
        return 'Symbologies';
      case BSRoutes.SelectionType:
        return 'Selection Type';
      case BSRoutes.SingleBarcodeAutoDetection:
        return 'Single Barcode Auto Detection';
      case BSRoutes.Feedback:
        return 'Feedback';
      case BSRoutes.CodeDuplicateFilter:
        return 'Code Duplicate Filter';
      case BSRoutes.PointOfInterest:
        return 'Point of Interest';
      case BSRoutes.ScanArea:
        return 'Scan Area';
      case BSRoutes.ViewPointOfInterest:
        return 'Point of Interest';
      case BSRoutes.Overlay:
        return 'Overlay';
      case BSRoutes.Viewfinder:
        return 'Viewfinder';
      default:
        return 'Barcode Selection Settings';
    }
  }
}
