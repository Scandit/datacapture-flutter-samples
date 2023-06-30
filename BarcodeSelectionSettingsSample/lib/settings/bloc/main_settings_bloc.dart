/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/route/routes.dart';
import 'package:BarcodeSelectionSettingsSample/settings/model/setting_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MainSettingsBloc extends Bloc {
  final _settingsItems = [
    SettingItem(BSRoutes.BarcodeSelectionSettings),
    SettingItem(BSRoutes.CameraSettings),
    SettingItem(BSRoutes.ViewSettings)
  ];

  List<SettingItem> get settingsItems => _settingsItems;

  String get pluginVersion => DataCaptureVersion.pluginVersion;
}
