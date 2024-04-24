/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:SearchAndFindSample/find/bloc/find_scan_bloc.dart';
import 'package:SearchAndFindSample/find/models/barcode_to_find.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_find.dart';

class FindScanView extends StatefulWidget {
  final BarcodeToFind barcodeToFind;

  // In the constructor, require the barcode to find.
  const FindScanView({super.key, required this.barcodeToFind});

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _FindScanScreenState(FindScanBloc(barcodeToFind));
}

class _FindScanScreenState extends State<FindScanView>
    with WidgetsBindingObserver
    implements BarcodeFindViewUiListener {
  FindScanBloc _bloc;

  late BarcodeFindView _barcodeFindView;

  _FindScanScreenState(this._bloc);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Create an instance of the BarcodeFindView
    // Using the forModeWithViewSettings factory, you can use the
    // BarcodeFindViewSettings to defined haptic and sound feedback,
    // as well as change the visual feedback for found barcodes.
    _barcodeFindView = BarcodeFindView.forMode(_bloc.dataCaptureContext, _bloc.barcodeFind);

    // Set the uiListener to  get a notification when the finish button is clicked
    _barcodeFindView.uiListener = this;

    // Resume finding by calling the BarcodeFindView widgetResumed function.
    // Under the hood, it re-enables the BarcodeFind mode and makes sure the view is properly
    // setup.
    _barcodeFindView.widgetResumed();

    // Tells the BarcodeFindView to start searching. When in searching is started,
    // the BarcodeFindView will start the camera and search as soon as everything is the view
    // is ready.
    _barcodeFindView.startSearching();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume finding by calling the BarcodeFindView widgetResumed function.
      // Under the hood, it re-enables the BarcodeFind mode and makes sure the view is properly
      // setup.
      _barcodeFindView.widgetResumed();
    } else {
      // Pause finding by calling the BarcodeFindView widgetPaused function.
      // Under the hood, it will disable the mode and free resources that are not needed in a
      // paused state.
      _barcodeFindView.widgetPaused();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _barcodeFindView.widgetPaused().then((value) => true);
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Search & Find'),
            ),
            body: _barcodeFindView),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didTapFinishButton(Set<BarcodeFindItem> foundItems) {
    // This method is called when the user presses the
    // finish button. It returns the list of all items that were found during
    // the session.
    Navigator.of(context).maybePop();
  }
}
