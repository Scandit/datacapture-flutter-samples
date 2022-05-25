/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/route/routes.dart';
import 'package:BarcodeSelectionSettingsSample/settings/model/setting_item.dart';

class BarcodeSelectionSettingsBloc extends Bloc {
  final _settings = [
    SettingItem(BSRoutes.Symbologies),
    SettingItem(BSRoutes.SelectionType),
    SettingItem(BSRoutes.SingleBarcodeAutoDetection),
    SettingItem(BSRoutes.Feedback),
    SettingItem(BSRoutes.CodeDuplicateFilter),
    SettingItem(BSRoutes.PointOfInterest),
  ];

  List<SettingItem> get settings => _settings;
}
