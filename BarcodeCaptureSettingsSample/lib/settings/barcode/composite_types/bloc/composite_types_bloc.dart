/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/composite_types/model/composite_type_item.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class CompositeTypesBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  List<CompositeTypeItem> get compositeTypes {
    return CompositeType.values.map((e) => CompositeTypeItem(e, _settings.isCompositeTypeEnabled(e))).toList();
  }

  void toggleCompositeType(CompositeTypeItem item) {
    if (item.isEnabled) {
      _settings.disableCompositeType(item.compositeType);
    } else {
      _settings.enableCompositeType(item.compositeType);
    }
  }
}
