/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/route/routes.dart';
import 'package:BarcodeCaptureSettingsSample/settings/main/model/setting_item.dart';

class ViewSettingsBloc extends Bloc {
  final _settings = [
    SettingItem(BCRoutes.ScanArea),
    SettingItem(BCRoutes.PointOfInterest),
    SettingItem(BCRoutes.Overlay),
    SettingItem(BCRoutes.Viewfinder),
    SettingItem(BCRoutes.Logo),
    SettingItem(BCRoutes.Gestures),
    SettingItem(BCRoutes.Controls),
  ];

  List<SettingItem> get settings => _settings;
}
