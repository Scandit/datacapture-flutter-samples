/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/route/routes.dart';

class SettingItem {
  final String title;
  final String navigationRoute;

  SettingItem(BCRoutes route)
      : this.title = route.viewTitle,
        this.navigationRoute = route.routeName;
}
