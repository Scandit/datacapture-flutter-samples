/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeSelectionPointOfInterestSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  static PointWithUnit defaultPointOfInterest =
      PointWithUnit(DoubleWithUnit(0.5, MeasureUnit.fraction), DoubleWithUnit(0.5, MeasureUnit.fraction));

  bool get isBarcodeSelectionPointOfInterestEnabled {
    return _settings.barcodeSelectionPointOfInterest != null;
  }

  set isBarcodeSelectionPointOfInterestEnabled(bool newValue) {
    if (newValue)
      _settings.barcodeSelectionPointOfInterest = defaultPointOfInterest;
    else
      _settings.barcodeSelectionPointOfInterest = null;
  }

  String get pointXDisplayText {
    var pointOfInterestX = _settings.barcodeSelectionPointOfInterest?.x;
    if (pointOfInterestX == null) pointOfInterestX = defaultPointOfInterest.x;

    return '${pointOfInterestX.value.toStringAsFixed(2)} (${pointOfInterestX.unit.name})';
  }

  String get pointYDisplayText {
    var pointOfInterestY = _settings.barcodeSelectionPointOfInterest?.y;
    if (pointOfInterestY == null) pointOfInterestY = defaultPointOfInterest.y;

    return '${pointOfInterestY.value.toStringAsFixed(2)} (${pointOfInterestY.unit.name})';
  }
}

class PointOfInterestX extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();
  late DoubleWithUnit _pointOfInterestX;
  late DoubleWithUnit _pointOfInterestY;

  PointOfInterestX() : super('X') {
    var pointOfInterestX = _settings.barcodeSelectionPointOfInterest?.x;
    if (pointOfInterestX == null) {
      _pointOfInterestX = BarcodeSelectionPointOfInterestSettingsBloc.defaultPointOfInterest.x;
    } else {
      _pointOfInterestX = pointOfInterestX;
    }

    var pointOfInterestY = _settings.barcodeSelectionPointOfInterest?.y;
    if (pointOfInterestY == null) {
      _pointOfInterestY = BarcodeSelectionPointOfInterestSettingsBloc.defaultPointOfInterest.y;
    } else {
      _pointOfInterestY = pointOfInterestY;
    }
  }

  @override
  MeasureUnit get measureUnit {
    return _pointOfInterestX.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _pointOfInterestX = DoubleWithUnit(value, newUnit);
    _settings.barcodeSelectionPointOfInterest = PointWithUnit(_pointOfInterestX, _pointOfInterestY);
  }

  @override
  double get value {
    return _pointOfInterestX.value;
  }

  @override
  set value(double newValue) {
    _pointOfInterestX = DoubleWithUnit(newValue, measureUnit);
    _settings.barcodeSelectionPointOfInterest = PointWithUnit(_pointOfInterestX, _pointOfInterestY);
  }
}

class PointOfInterestY extends DoubleWithUnitBloc {
  final SettingsRepository _settings = SettingsRepository();
  late DoubleWithUnit _pointOfInterestX;
  late DoubleWithUnit _pointOfInterestY;

  PointOfInterestY() : super('Y') {
    var pointOfInterestX = _settings.barcodeSelectionPointOfInterest?.x;
    if (pointOfInterestX == null) {
      _pointOfInterestX = BarcodeSelectionPointOfInterestSettingsBloc.defaultPointOfInterest.x;
    } else {
      _pointOfInterestX = pointOfInterestX;
    }

    var pointOfInterestY = _settings.barcodeSelectionPointOfInterest?.y;
    if (pointOfInterestY == null) {
      _pointOfInterestY = BarcodeSelectionPointOfInterestSettingsBloc.defaultPointOfInterest.y;
    } else {
      _pointOfInterestY = pointOfInterestY;
    }
  }

  @override
  MeasureUnit get measureUnit {
    return _pointOfInterestY.unit;
  }

  @override
  set measureUnit(MeasureUnit newUnit) {
    _pointOfInterestY = DoubleWithUnit(value, newUnit);
    _settings.barcodeSelectionPointOfInterest = PointWithUnit(_pointOfInterestX, _pointOfInterestY);
  }

  @override
  double get value {
    return _pointOfInterestY.value;
  }

  @override
  set value(double newValue) {
    _pointOfInterestY = DoubleWithUnit(newValue, measureUnit);
    _settings.barcodeSelectionPointOfInterest = PointWithUnit(_pointOfInterestX, _pointOfInterestY);
  }
}
