/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:SearchAndFindSample/bloc/bloc_base.dart';
import 'package:SearchAndFindSample/find/models/barcode_to_find.dart';
import 'package:SearchAndFindSample/models/data_capture_manager.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_find.dart';

class FindScanBloc extends Bloc {
  DataCaptureManager _dataCaptureManager = DataCaptureManager();

  late BarcodeFind _barcodeFind;

  DataCaptureContext get dataCaptureContext => _dataCaptureManager.dataCaptureContext;

  BarcodeFind get barcodeFind => _barcodeFind;

  FindScanBloc(BarcodeToFind barcodeToFind) {
    // The barcode find process is configured through barcode find settings
    // which are then applied to the barcode find instance.
    var settings = new BarcodeFindSettings();

    // We enable only the given symbology.
    settings.enableSymbology(barcodeToFind.symbology, true);

    // Create new barcode find mode with created settings.
    _barcodeFind = new BarcodeFind(settings);

    var itemsToSearch = <BarcodeFindItem>{};

    itemsToSearch.add(BarcodeFindItem(new BarcodeFindItemSearchOptions(barcodeToFind.data), null));

    // The BarcodeFind can search a set of items. In this simplified sample, we set only
    // one items, but for real case we can set several at once.
    barcodeFind.setItemList(itemsToSearch);

    barcodeFind.isEnabled = true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
