/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

extension CameraPositionPrettyPrint on CameraPosition {
  String get name => _name();

  String _name() {
    switch (this) {
      case CameraPosition.worldFacing:
        return 'World Facing';
      case CameraPosition.userFacing:
        return 'User Facing';
      default:
        throw Exception("Missing pretty name for '$this' camera position");
    }
  }
}

extension VideoResolutionPrettyPrint on VideoResolution {
  String get name => _name();

  String _name() {
    switch (this) {
      case VideoResolution.auto:
        return 'auto';
      case VideoResolution.hd:
        return 'hd';
      case VideoResolution.fullHd:
        return 'fullHd';
      case VideoResolution.uhd4k:
        return 'uhd4k';
    }
  }
}

extension FocusRangePrettyPrint on FocusRange {
  String get name => _name();

  String _name() {
    switch (this) {
      case FocusRange.far:
        return 'Far';
      case FocusRange.full:
        return 'Full';
      case FocusRange.near:
        return 'Near';
    }
  }
}

extension MeasureUnitPrettyPrint on MeasureUnit {
  String get name {
    switch (this) {
      case MeasureUnit.dip:
        return 'DIP';
      case MeasureUnit.fraction:
        return 'FRACTION';
      case MeasureUnit.pixel:
        return 'PIXEL';
    }
  }
}

extension BarcodeSelectionFreezeBehaviorPrettyPrint on BarcodeSelectionFreezeBehavior {
  String get name {
    switch (this) {
      case BarcodeSelectionFreezeBehavior.manual:
        return 'Manual';
      case BarcodeSelectionFreezeBehavior.manualAndAutomatic:
        return 'Manual and Automatic';
    }
  }
}

extension BarcodeSelectionTapBehaviorPrettyPrint on BarcodeSelectionTapBehavior {
  String get name {
    switch (this) {
      case BarcodeSelectionTapBehavior.repeatSelection:
        return 'Repeat Selection';
      case BarcodeSelectionTapBehavior.toggleSelection:
        return 'Toggle Selection';
    }
  }
}

extension BarcodeSelectionBasicOverlayStylePrettyPrint on BarcodeSelectionBasicOverlayStyle {
  String get name {
    switch (this) {
      case BarcodeSelectionBasicOverlayStyle.frame:
        return 'Frame';
      case BarcodeSelectionBasicOverlayStyle.dot:
        return 'Dot';
    }
  }
}
