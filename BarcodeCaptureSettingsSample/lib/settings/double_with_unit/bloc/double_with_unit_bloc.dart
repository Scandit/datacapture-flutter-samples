/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/model/measure_unit_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class DoubleWithUnitBloc extends Bloc {
  String title;

  DoubleWithUnitBloc(this.title);

  MeasureUnit get measureUnit;
  set measureUnit(MeasureUnit newValue);

  double get value;
  set value(double newValue);

  List<MeasureUnitItem> get availiableMeasureUnits {
    return [
      MeasureUnitItem(MeasureUnit.dip, measureUnit == MeasureUnit.dip),
      MeasureUnitItem(MeasureUnit.fraction, measureUnit == MeasureUnit.fraction),
      MeasureUnitItem(MeasureUnit.pixel, measureUnit == MeasureUnit.pixel)
    ];
  }
}
