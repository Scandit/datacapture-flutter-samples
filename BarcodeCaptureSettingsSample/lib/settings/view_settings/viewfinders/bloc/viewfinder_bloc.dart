/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureSettingsSample/repository/settings_repository.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class ViewfindersBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  late Viewfinders _currentViewfinder;

  ViewfindersBloc() {
    if (_settings.currentViewfinder is RectangularViewfinder) {
      _currentViewfinder = Viewfinders.rectangular;
    } else if (_settings.currentViewfinder is AimerViewfinder) {
      _currentViewfinder = Viewfinders.Aimer;
    } else {
      _currentViewfinder = Viewfinders.none;
    }
  }

  Viewfinders get currentViewfinder {
    return _currentViewfinder;
  }

  set currentViewfinder(Viewfinders newViewfinder) {
    _currentViewfinder = newViewfinder;

    switch (_currentViewfinder) {
      case Viewfinders.none:
        _settings.currentViewfinder = null;
        break;
      case Viewfinders.rectangular:
        _settings.currentViewfinder = RectangularViewfinder();
        break;
      case Viewfinders.Aimer:
        _settings.currentViewfinder = AimerViewfinder();
        break;
    }
  }

  List<Viewfinders> get availableViewfinders {
    return Viewfinders.values;
  }
}

enum Viewfinders { none, rectangular, Aimer }

extension ViewfindersPrettyPrint on Viewfinders {
  String get name {
    switch (this) {
      case Viewfinders.none:
        return 'None';
      case Viewfinders.rectangular:
        return 'Rectangular';
      case Viewfinders.Aimer:
        return 'Aimer';
      default:
        throw Exception("Missing name for '$this' composite type");
    }
  }
}
