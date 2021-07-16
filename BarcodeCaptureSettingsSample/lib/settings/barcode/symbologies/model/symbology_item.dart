import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class SymbologyItem {
  final Symbology symbology;
  final bool isEnabled;
  SymbologyItem(this.symbology, this.isEnabled);

  String get name {
    return SymbologyDescription.forSymbology(symbology).readableName;
  }
}
