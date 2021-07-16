/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/bloc/radius_location_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/bloc/rectangular_location_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/model/location_selection_item.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';

class LocationSelectionSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();
  late LocationSelectionType _currentLocationSelectionType;

  LocationSelectionSettingsBloc() {
    if (_settings.currentLocationSelection is RadiusLocationSelection) {
      _currentLocationSelectionType = LocationSelectionType.radius;
    } else if (_settings.currentLocationSelection is RectangularLocationSelection) {
      _currentLocationSelectionType = LocationSelectionType.rectangular;
    } else {
      _currentLocationSelectionType = LocationSelectionType.none;
    }
  }

  void updateLocationSelection() {
    switch (currentLocationSelection) {
      case LocationSelectionType.radius:
        _settings.currentLocationSelection = RadiusLocationSelection(_settings.radiusLocationSize);
        break;
      case LocationSelectionType.rectangular:
        if (_settings.rectangularLocationSelectionSizeMode == SizingMode.widthAndHeight) {
          _settings.currentLocationSelection = RectangularLocationSelection.withSize(
              SizeWithUnit(_settings.rectangularLocationSelectionWidth, _settings.rectangularLocationSelectionHeight));
        } else if (_settings.rectangularLocationSelectionSizeMode == SizingMode.widthAndAspectRatio) {
          _settings.currentLocationSelection = RectangularLocationSelection.withWidthAndAspect(
              _settings.rectangularLocationSelectionWidth, _settings.rectangularLocationSelectionHeightAspect);
        } else if (_settings.rectangularLocationSelectionSizeMode == SizingMode.heightAndAspectRatio) {
          _settings.currentLocationSelection = RectangularLocationSelection.withHeightAndAspect(
              _settings.rectangularLocationSelectionHeight, _settings.rectangularLocationSelectionWidthAspect);
        }
        break;
      default:
    }
  }

  List<LocationSelectionType> get availableLocationSelections {
    return LocationSelectionType.values;
  }

  LocationSelectionType get currentLocationSelection {
    return _currentLocationSelectionType;
  }

  set currentLocationSelection(LocationSelectionType newValue) {
    _currentLocationSelectionType = newValue;
  }

  String get radiusLocationSizeDisplayValue {
    return '${_settings.radiusLocationSelectionValue.toStringAsFixed(2)} (${_settings.radiusLocationSelectionUnit.name})';
  }

  RadiusLocationSelectionSizeBloc get radiusSizeBloc {
    return RadiusLocationSelectionSizeBloc();
  }

  RectangularLocationSelectionWidthBloc get rectangularWidthBloc {
    return RectangularLocationSelectionWidthBloc();
  }

  RectangularLocationSelectionHeightBloc get rectangularHeightBloc {
    return RectangularLocationSelectionHeightBloc();
  }

  SizingMode get rectangularLocationSelectionSizeMode {
    return _settings.rectangularLocationSelectionSizeMode;
  }

  set rectangularLocationSelectionSizeMode(SizingMode newValue) {
    _settings.rectangularLocationSelectionSizeMode = newValue;
  }

  Iterable<SizingMode> get availableRectangularLocationSelectionSizingModes {
    return SizingMode.values.where((element) => element != SizingMode.shorterDimensionAndAspectRatio);
  }

  String get rectangularLocationSelectionWidthDisplayValue {
    return '${_settings.rectangularLocationSelectionWidthValue.toStringAsFixed(2)} (${_settings.rectangularLocationSelectionWidthUnit.name})';
  }

  String get rectangularLocationSelectionHeightDisplayValue {
    return '${_settings.rectangularLocationSelectionHeightValue.toStringAsFixed(2)} (${_settings.rectangularLocationSelectionHeightUnit.name})';
  }

  double get rectangularLocationSelectionHeightAspect {
    return _settings.rectangularLocationSelectionHeightAspect;
  }

  set rectangularLocationSelectionHeightAspect(double newValue) {
    _settings.rectangularLocationSelectionHeightAspect = newValue;
  }

  double get rectangularLocationSelectionWidthAspect {
    return _settings.rectangularLocationSelectionWidthAspect;
  }

  set rectangularLocationSelectionWidthAspect(double newValue) {
    _settings.rectangularLocationSelectionWidthAspect = newValue;
  }
}
