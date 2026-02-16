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

  @override
  State<StatefulWidget> createState() => _FindScanScreenState(FindScanBloc(barcodeToFind));
}

class _FindScanScreenState extends State<FindScanView>
    with WidgetsBindingObserver
    implements BarcodeFindViewUiListener {
  FindScanBloc _bloc;

  BarcodeFindView? _barcodeFindView;
  bool _isCleaningUp = false;

  _FindScanScreenState(this._bloc);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Create an instance of the BarcodeFindView
    // Using the forModeWithViewSettings factory, you can use the
    // BarcodeFindViewSettings to defined haptic and sound feedback,
    // as well as change the visual feedback for found barcodes.
    _barcodeFindView = BarcodeFindView.forMode(_bloc.dataCaptureContext, _bloc.barcodeFind)
      ..uiListener = this; // Set the uiListener to  get a notification when the finish button is clicked

    // Tells the BarcodeFindView to start searching. When in searching is started,
    // the BarcodeFindView will start the camera and search as soon as everything is the view
    // is ready.
    _barcodeFindView?.startSearching();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop || _isCleaningUp) return;

        await _handleNavigation();
      },
      child: _barcodeFindView ?? const SizedBox.shrink(),
    );
  }

  Future<void> _handleNavigation() async {
    if (_isCleaningUp) return;

    _isCleaningUp = true;

    // Stop searching first
    await _barcodeFindView?.stopSearching();

    // Remove the view from the tree to trigger dispose
    setState(() {
      _barcodeFindView = null;
    });

    // Give native platform time to complete disposal
    await Future.delayed(const Duration(milliseconds: 200));

    // Now navigate back
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didTapFinishButton(Set<BarcodeFindItem> foundItems) async {
    // This method is called when the user presses the
    // finish button. It returns the list of all items that were found during
    // the session.
    await _handleNavigation();
  }
}
