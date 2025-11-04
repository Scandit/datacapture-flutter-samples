import 'package:matrixscancountsimplesample/bloc/bloc_base.dart';
import 'package:matrixscancountsimplesample/result/model/list_items.dart';
import 'package:matrixscancountsimplesample/result/model/result_screen_navigation_args.dart';
import 'package:matrixscancountsimplesample/result/model/scan_details.dart';

class ResultBloc implements Bloc {
  final Map<String, ScanDetails> _scannedItems;
  final DoneButtonStyle doneButtonStyle;
  late List<ListItem> _scannedBarcodes;

  ResultBloc(this._scannedItems, this.doneButtonStyle) {
    int uniqueIndex = 0;
    int nonUniqueIndex = 0;
    _scannedBarcodes = _scannedItems.values
        .where((element) => element.quantity > 1)
        .map((e) {
          nonUniqueIndex += 1;
          return NonUniqueItem(e, nonUniqueIndex);
        })
        .cast<ListItem>()
        .followedBy(_scannedItems.values.where((element) => element.quantity == 1).map((e) {
          uniqueIndex += 1;
          return UniqueItem(e, uniqueIndex);
        }))
        .cast<ListItem>()
        .toList();
  }

  int get itemsCount {
    return _scannedBarcodes.length;
  }

  ListItem getItem(int index) {
    return _scannedBarcodes.elementAt(index);
  }

  int get numberOfScannedItems {
    if (_scannedBarcodes.isEmpty) return 0;
    return _scannedBarcodes.map((e) => e.scanDetail.quantity).reduce((value, element) => value + element);
  }

  @override
  void dispose() {
    // Not relevant for this sample
  }
}
