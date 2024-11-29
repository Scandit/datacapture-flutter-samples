import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

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
      default:
        throw Exception("Missing pretty name for '$this' video resolution");
    }
  }
}

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

extension FocusGestureStrategyPrettyPrint on FocusGestureStrategy {
  String get name => _name();

  String _name() {
    switch (this) {
      case FocusGestureStrategy.autoOnLocation:
        return 'Auto On Location';
      case FocusGestureStrategy.manual:
        return 'Manual';
      case FocusGestureStrategy.manualUntilCapture:
        return 'Manual Until Capture';
      case FocusGestureStrategy.none:
        return 'None';
      default:
        throw Exception("Missing pretty name for '$this' camera position");
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
      default:
        throw Exception("Missing name for '$this' measure unit");
    }
  }
}

extension SizingModePrettyPrint on SizingMode {
  String get name {
    switch (this) {
      case SizingMode.widthAndHeight:
        return 'Width and Height';
      case SizingMode.widthAndAspectRatio:
        return 'Width and Height Aspect';
      case SizingMode.heightAndAspectRatio:
        return 'Height and Width Aspect';
      case SizingMode.shorterDimensionAndAspectRatio:
        return 'Shorter Dimension and Aspect Ratio';
      default:
        throw Exception("Missing name for '$this' size specification");
    }
  }
}

extension CompositeTypePrettyPrint on CompositeType {
  String get name {
    switch (this) {
      case CompositeType.a:
        return 'A';
      case CompositeType.b:
        return 'B';
      case CompositeType.c:
        return 'C';
      default:
        throw Exception("Missing name for '$this' composite type");
    }
  }
}

extension RectangularViewfinderStylePrettyPrint on RectangularViewfinderStyle {
  String get name {
    switch (this) {
      case RectangularViewfinderStyle.rounded:
        return 'Rounded';
      case RectangularViewfinderStyle.square:
        return 'Square';
      default:
        throw Exception("Missing name for '$this' rectangular viewfinder style");
    }
  }
}

extension RectangularViewfinderLineStylePrettyPrint on RectangularViewfinderLineStyle {
  String get name {
    switch (this) {
      case RectangularViewfinderLineStyle.bold:
        return 'Bold';
      case RectangularViewfinderLineStyle.light:
        return 'Light';
      default:
        throw Exception("Missing name for '$this' rectangular viewfinder line style");
    }
  }
}

extension AnchorPrettyPrint on Anchor {
  String get name {
    switch (this) {
      case Anchor.bottomCenter:
        return 'Bottom Center';
      case Anchor.bottomLeft:
        return 'Bottom Left';
      case Anchor.bottomRight:
        return 'Bottom Right';
      case Anchor.center:
        return 'Center';
      case Anchor.centerLeft:
        return 'Center Left';
      case Anchor.centerRight:
        return 'Center Right';
      case Anchor.topCenter:
        return 'Top Center';
      case Anchor.topLeft:
        return 'Top Left';
      case Anchor.topRight:
        return 'Top Right';
      default:
        throw Exception("Missing name for '$this' rectangular viewfinder line style");
    }
  }
}
