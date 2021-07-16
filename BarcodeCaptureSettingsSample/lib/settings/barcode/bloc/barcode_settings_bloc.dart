/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/route/routes.dart';
import 'package:BarcodeCaptureSettingsSample/settings/main/model/setting_item.dart';

class BarcodeSettingsBloc extends Bloc {
  final _settings = [
    SettingItem(BCRoutes.Symbologies),
    SettingItem(BCRoutes.CompositeTypes),
    SettingItem(BCRoutes.LocationSelection),
    SettingItem(BCRoutes.Feedback),
    SettingItem(BCRoutes.CodeDuplicateFilter),
  ];

  List<SettingItem> get settings => _settings;
}
