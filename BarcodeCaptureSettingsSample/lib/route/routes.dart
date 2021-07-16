/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum BCRoutes {
  Home,
  Settings,
  BarcodeCaptureSettings,
  CameraSettings,
  ViewSettings,
  ResultSettings,
  Symbologies,
  CompositeTypes,
  LocationSelection,
  Feedback,
  CodeDuplicateFilter,
  ScanArea,
  PointOfInterest,
  Overlay,
  Viewfinder,
  Logo,
  Gestures,
  Controls
}

extension RoutesValue on BCRoutes {
  String get routeName {
    switch (this) {
      case BCRoutes.Home:
        return '/';
      case BCRoutes.Settings:
        return '/settings';
      case BCRoutes.BarcodeCaptureSettings:
        return '/captureSettings';
      case BCRoutes.CameraSettings:
        return '/cameraSettings';
      case BCRoutes.ViewSettings:
        return '/viewSettings';
      case BCRoutes.ResultSettings:
        return '/resultSettings';
      case BCRoutes.Symbologies:
        return '/symbologies';
      case BCRoutes.CompositeTypes:
        return '/compositeTypes';
      case BCRoutes.LocationSelection:
        return '/locationSelection';
      case BCRoutes.Feedback:
        return '/feedback';
      case BCRoutes.CodeDuplicateFilter:
        return '/codeDuplicateFilter';
      case BCRoutes.ScanArea:
        return '/scanArea';
      case BCRoutes.PointOfInterest:
        return '/pointOfInterest';
      case BCRoutes.Overlay:
        return '/overlay';
      case BCRoutes.Viewfinder:
        return '/viewfinder';
      case BCRoutes.Logo:
        return '/logo';
      case BCRoutes.Gestures:
        return '/gestures';
      case BCRoutes.Controls:
        return '/controls';
      default:
        return '/';
    }
  }

  String get viewTitle {
    switch (this) {
      case BCRoutes.Home:
        return 'Barcode Capture Settings';
      case BCRoutes.Settings:
        return 'Settings';
      case BCRoutes.BarcodeCaptureSettings:
        return 'Barcode Capture';
      case BCRoutes.CameraSettings:
        return 'Camera';
      case BCRoutes.ViewSettings:
        return 'View';
      case BCRoutes.ResultSettings:
        return 'Result';
      case BCRoutes.Symbologies:
        return 'Symbologies';
      case BCRoutes.CompositeTypes:
        return 'Composite Types';
      case BCRoutes.LocationSelection:
        return 'Location Selection';
      case BCRoutes.Feedback:
        return 'Feedback';
      case BCRoutes.CodeDuplicateFilter:
        return 'Code Duplicate Filter';
      case BCRoutes.ScanArea:
        return 'Scan Area';
      case BCRoutes.PointOfInterest:
        return 'Point of Interest';
      case BCRoutes.Overlay:
        return 'Overlay';
      case BCRoutes.Viewfinder:
        return 'Viewfinder';
      case BCRoutes.Logo:
        return 'Logo';
      case BCRoutes.Gestures:
        return 'Gestures';
      case BCRoutes.Controls:
        return 'Controls';
      default:
        return 'Barcode Capture Settings';
    }
  }
}
