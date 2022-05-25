/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/route/routes.dart';
import 'package:BarcodeSelectionSettingsSample/settings/model/setting_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class MainSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  final _settingsItems = [
    SettingItem(BSRoutes.BarcodeSelectionSettings),
    SettingItem(BSRoutes.CameraSettings),
    SettingItem(BSRoutes.ViewSettings)
  ];

  List<SettingItem> get settingsItems => _settingsItems;

  Future<void> resetBarcodeSelectionSession() {
    return _settings.barcodeSelection.reset();
  }

  String get pluginVersion => DataCaptureVersion.pluginVersion;
}
