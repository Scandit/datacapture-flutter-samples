/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/route/routes.dart';
import 'package:BarcodeCaptureSettingsSample/settings/main/model/setting_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MainSettingsBloc extends Bloc {
  final _settings = [
    SettingItem(BCRoutes.BarcodeCaptureSettings),
    SettingItem(BCRoutes.CameraSettings),
    SettingItem(BCRoutes.ViewSettings),
    SettingItem(BCRoutes.ResultSettings),
  ];

  List<SettingItem> get settings => _settings;

  String get pluginVersion => DataCaptureVersion.pluginVersion;
}
