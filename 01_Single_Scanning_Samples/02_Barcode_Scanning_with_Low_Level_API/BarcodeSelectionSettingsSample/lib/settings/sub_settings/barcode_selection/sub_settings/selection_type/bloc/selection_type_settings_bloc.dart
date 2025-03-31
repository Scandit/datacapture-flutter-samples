/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/repository/settings_repository.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/model/picker_item.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/model/aimer_selection_strategy.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/model/selection_type.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';

class SelectionTypeSettingsBloc extends Bloc {
  final SettingsRepository _settings = SettingsRepository();

  SelectionType get selectionType {
    if (isTapSelection) return SelectionType.tapToSelect;

    return SelectionType.aimToSelect;
  }

  set selectionType(SelectionType newSelectionType) {
    if (newSelectionType == SelectionType.tapToSelect) {
      _settings.selectionType = BarcodeSelectionTapSelection.withFreezeBehaviourAndTapBehaviour(
          BarcodeSelectionFreezeBehavior.manual, BarcodeSelectionTapBehavior.toggleSelection);
    } else {
      _settings.selectionType = BarcodeSelectionAimerSelection()
        ..selectionStrategy = BarcodeSelectionManualSelectionStrategy();
    }
  }

  List<PickerItem> get availableSelectionTypes {
    return SelectionType.values.map((e) => PickerItem(e.name, e, e == selectionType)).toList();
  }

  BarcodeSelectionFreezeBehavior get freezeBehavior {
    if (isTapSelection) {
      var tapSelection = _settings.selectionType as BarcodeSelectionTapSelection;
      return tapSelection.freezeBehavior;
    }

    return BarcodeSelectionFreezeBehavior.manual;
  }

  set freezeBehavior(BarcodeSelectionFreezeBehavior newFreezeBehavior) {
    if (isTapSelection == false) return;

    _settings.selectionType =
        BarcodeSelectionTapSelection.withFreezeBehaviourAndTapBehaviour(newFreezeBehavior, tapBehavior);
  }

  List<PickerItem> get availableFreezeBehaviors {
    return BarcodeSelectionFreezeBehavior.values.map((e) => PickerItem(e.name, e, e == freezeBehavior)).toList();
  }

  BarcodeSelectionTapBehavior get tapBehavior {
    if (isTapSelection) {
      var tapSelection = _settings.selectionType as BarcodeSelectionTapSelection;
      return tapSelection.tapBehavior;
    }

    return BarcodeSelectionTapBehavior.toggleSelection;
  }

  set tapBehavior(BarcodeSelectionTapBehavior newTapBehaviour) {
    if (isTapSelection == false) return;

    _settings.selectionType =
        BarcodeSelectionTapSelection.withFreezeBehaviourAndTapBehaviour(freezeBehavior, newTapBehaviour);
  }

  List<PickerItem> get availableTapBehaviors {
    return BarcodeSelectionTapBehavior.values.map((e) => PickerItem(e.name, e, e == tapBehavior)).toList();
  }

  bool get isTapSelection {
    return _settings.selectionType is BarcodeSelectionTapSelection;
  }

  List<PickerItem> get availableSelectionStrategies {
    return AimerSelectionStrategy.values.map((e) => PickerItem(e.name, e, e == selectionStrategy)).toList();
  }

  AimerSelectionStrategy get selectionStrategy {
    if (isTapSelection == false) {
      var aimerSelection = _settings.selectionType as BarcodeSelectionAimerSelection;
      if (aimerSelection.selectionStrategy is BarcodeSelectionAutoSelectionStrategy) return AimerSelectionStrategy.auto;
    }

    return AimerSelectionStrategy.manual;
  }

  set selectionStrategy(AimerSelectionStrategy newStrategy) {
    if (newStrategy == AimerSelectionStrategy.manual)
      _settings.selectionType = BarcodeSelectionAimerSelection()
        ..selectionStrategy = BarcodeSelectionManualSelectionStrategy();
    else
      _settings.selectionType = BarcodeSelectionAimerSelection()
        ..selectionStrategy = BarcodeSelectionAutoSelectionStrategy();
  }
}
