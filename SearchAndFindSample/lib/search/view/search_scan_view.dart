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
  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _SearchScanScreenState(SearchScanBloc());
}

class _SearchScanScreenState extends State<SearchScanView> with WidgetsBindingObserver {
  SearchScanBloc _bloc;

  _SearchScanScreenState(this._bloc);

  late DataCaptureView _dataCaptureView;

  late BarcodeCaptureOverlay _overlay;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _bloc.onBarcodeCaptured.listen((barcode) {
      _onBarcodeCaptured(barcode);
    });

    // To visualize the on-going barcode capturing process on screen,
    // setup a data capture view that renders the camera preview.
    // The view must be connected to the data capture context.
    _dataCaptureView = DataCaptureView.forContext(_bloc.dataCaptureContext);

    // Setup the barcode capture session
    _bloc.setupScanning();

    // Add a barcode capture overlay to the data capture view to set a viewfinder UI.
    _overlay = BarcodeCaptureOverlay.withBarcodeCaptureForViewWithStyle(
        _bloc.barcodeCapture, null, BarcodeCaptureOverlayStyle.frame);

    // We add the aim viewfinder to the overlay.
    _overlay.viewfinder = new AimerViewfinder();

    // Adjust the overlay's barcode highlighting to display a light green rectangle.
    var brush = new Brush(Color(0x8028D380), Colors.transparent, 0);

    _overlay.brush = brush;

    _dataCaptureView.addOverlay(_overlay);

    // Check camera permissions
    _checkPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _bloc.pauseScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => _bloc.dispose()).then((value) => true);
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
    Permission.camera.request().isGranted.then((value) => setState(() {
          if (value) {
            _bloc.resumeScanning();
          }
        }));
  }

  void _onBarcodeCaptured(CapturedBarcode barcode) {
    if (_isModalSheetVisible) {
      Navigator.pop(context);
    }
    // Artificial delay added to give time to fluter to close the previous bottom sheet
    Future.delayed(Duration(milliseconds: 150)).then((value) => showBottomPopup(barcode));
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
    _bloc.disposeCurrentScanning();
    // Remove overlay
    _dataCaptureView.removeOverlay(_overlay);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindScanView(barcodeToFind: BarcodeToFind(barcode.symbology, barcode.data)),
      ),
    );

    // Once we come back we will need to re-create the barcode capture session
    _bloc.setupScanning();
    // resume scanning
    _bloc.resumeScanning();
    // add overlay to set a viewfinder UI again
    _dataCaptureView.addOverlay(_overlay);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
