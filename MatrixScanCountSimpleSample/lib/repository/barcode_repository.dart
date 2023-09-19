/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import '../result/model/scan_details.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_count.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';

class BarcodeRepository {
  static final BarcodeRepository _singleton = BarcodeRepository._internal();

  factory BarcodeRepository() {
    return _singleton;
  }

  Iterable<TrackedBarcode> _scannedBarcodes = [];
  Iterable<Barcode> _additionalBarcodes = [];

  BarcodeRepository._internal();

  late WeakReference<BarcodeCount> _barcodeCount;

  void initialize(BarcodeCount barcodeCount) {
    this._barcodeCount = new WeakReference(barcodeCount);
  }

// Update lists of barcodes with the contents of the current session.
  void updateWithSession(BarcodeCountSession session) {
    _scannedBarcodes = session.recognizedBarcodes.values;
    _additionalBarcodes = session.additionalBarcodes;
  }

  // Save any scanned barcodes as additional barcodes, so they're still scanned
  // after coming back from background.
  void saveCurrentBarcodesAsAdditionalBarcodes() {
    List<Barcode> barcodesToSave = [];

    for (var barcode in _scannedBarcodes) {
      barcodesToSave.add(barcode.barcode);
    }

    barcodesToSave.addAll(_additionalBarcodes);
    if (_barcodeCount.target != null) {
      _barcodeCount.target?.setAdditionalBarcodes(barcodesToSave);
    }
  }

  // Create a map of barcodes to be passed to the scan results screen.
  Map<String, ScanDetails> getScanResults() {
    var scanResults = Map<String, ScanDetails>();

    // Add the inner Barcode objects of each scanned TrackedBarcode to the results map.
    for (TrackedBarcode trackedBarcode in _scannedBarcodes) {
      addBarcodeToResultsMap(trackedBarcode.barcode, scanResults);
    }

    // Add the previously saved Barcode objects to the results map.
    for (Barcode barcode in _additionalBarcodes) {
      addBarcodeToResultsMap(barcode, scanResults);
    }

    return scanResults;
  }

  void addBarcodeToResultsMap(Barcode barcode, Map<String, ScanDetails> scanResults) {
    var barcodeData = barcode.data;
    String symbology = barcode.symbology.toString();
    if (barcodeData == null) return;

    if (scanResults.containsKey(barcodeData)) {
      scanResults[barcodeData]?.increaseQuantity();
    } else {
      scanResults[barcodeData] = ScanDetails(barcodeData, symbology);
    }
  }

  void reset() {
    _additionalBarcodes = [];
    _scannedBarcodes = [];
  }
}
