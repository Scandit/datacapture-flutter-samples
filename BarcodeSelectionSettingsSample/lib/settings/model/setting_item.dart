/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/route/routes.dart';

class SettingItem {
  final String title;
  final String navigationRoute;

  SettingItem(BSRoutes route)
      : this.title = route.viewTitle,
        this.navigationRoute = route.routeName;
}
