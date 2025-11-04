/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:SearchAndFindSample/find/models/barcode_to_find.dart';
import 'package:SearchAndFindSample/find/view/find_scan_view.dart';
import 'package:SearchAndFindSample/search/bloc/search_scan_bloc.dart';
import 'package:SearchAndFindSample/search/models/captured_barcode.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';

class SearchScanView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScanScreenState(SearchScanBloc());
}

class _SearchScanScreenState extends State<SearchScanView> with WidgetsBindingObserver {
  SearchScanBloc _bloc;

  _SearchScanScreenState(this._bloc);

  late DataCaptureView _dataCaptureView;

  @override
  void initState() {
    super.initState();

    _addAppStateListener();
    _init();
  }

  void _init() async {
    _bloc.onBarcodeCaptured.listen((barcode) {
      _onBarcodeCaptured(barcode);
    });

    // To visualize the on-going barcode capturing process on screen,
    // setup a data capture view that renders the camera preview.
    // The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(_bloc.dataCaptureContext);

    // Setup the barcode capture session
    await _bloc.setupScanning();

    // Add overlay to the data capture view
    await _initOverlay();

    // Check camera permissions
    _checkPermission();
  }

  Future<void> _initOverlay() async {
    // Add a barcode capture overlay to the data capture view to set a viewfinder UI.
    final overlay = BarcodeCaptureOverlay(_bloc.barcodeCapture);

    // We add the aim viewfinder to the overlay.
    overlay.viewfinder = new AimerViewfinder();

    // Adjust the overlay's barcode highlighting to display a light green rectangle.
    var brush = new Brush(Color(0x8028D380), Colors.transparent, 0);

    overlay.brush = brush;

    await _dataCaptureView.addOverlay(overlay);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission();
        break;
      default:
        _bloc.pauseScanning();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents immediate popping
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _bloc.dispose();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Search & Find'),
          ),
          body: _dataCaptureView,
        ),
      ),
    );
  }

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;

      if (status.isGranted) {
        _bloc.resumeScanning();
      }
    });
  }

  void _onBarcodeCaptured(CapturedBarcode barcode) {
    if (_isModalSheetVisible) {
      Navigator.pop(context);
    }

    // Artificial delay added to give time to fluter to close the previous bottom sheet
    Future.delayed(Duration(milliseconds: 150)).then((value) {
      showBottomPopup(barcode);
    });
  }

  bool _isModalSheetVisible = false;

  void showBottomPopup(CapturedBarcode barcode) {
    _isModalSheetVisible = true;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.all(20),
          child: new ListTile(
            trailing: GestureDetector(
              child: Image(image: AssetImage('assets/fastfind.png')),
              onTap: () {
                _navigateToFindView(barcode);
              },
            ),
            title: new Text(barcode.data),
          ),
        ),
      ),
    ).whenComplete(() {
      _isModalSheetVisible = false;
    });
  }

  void _navigateToFindView(CapturedBarcode barcode) async {
    // Close bottom sheet
    Navigator.pop(context);

    // Disable current capture session
    await _bloc.disposeCurrentScanning();

    // Remove overlay
    _dataCaptureView.removeAllOverlays();

    // remove app state listener
    _removeAppStateListener();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindScanView(barcodeToFind: BarcodeToFind(barcode.symbology, barcode.data)),
      ),
    );

    // Artificial delay added to give time to fluter to close the FindView
    // and close the camera so that when we re-create the camera instance here
    // we will have the correct state in sync.
    await Future.delayed(Duration(milliseconds: 500));

    // Once we come back we will need to re-create the barcode capture session
    await _bloc.setupScanning();
    // resume scanning
    await _bloc.resumeScanning();
    // add overlay to set a viewfinder UI again
    await _initOverlay();

    // add app state listener
    _addAppStateListener();
  }

  @override
  void dispose() {
    _removeAppStateListener();
    super.dispose();
  }

  void _addAppStateListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _removeAppStateListener() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
