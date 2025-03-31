/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/pick/bloc/barcode_pick_bloc.dart';
import 'package:RestockingSample/result/view/result_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_pick.dart';

class BarcodePickScreen extends StatefulWidget {
  const BarcodePickScreen({super.key});

  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _BarcodePickScreenState(BarcodePickBloc());
}

class _BarcodePickScreenState extends State<BarcodePickScreen>
    with WidgetsBindingObserver
    implements BarcodePickActionListener, BarcodePickViewUiListener {
  BarcodePickBloc _bloc;
  late BarcodePickView _barcodePickView;

  _BarcodePickScreenState(this._bloc);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // We create the view settings.
    // We keep the default here, but you can use them to specify your own hints to display,
    //  whether to show guidelines or not and so on.
    var viewSettings = BarcodePickViewSettings();

    // We finally create the view, passing the mode and the view settings.
    _barcodePickView =
        BarcodePickView.forModeWithViewSettings(_bloc.dataCaptureContext, _bloc.barcodePick, viewSettings);

    _barcodePickView.addActionListener(this);
    _barcodePickView.uiListener = this;

    _checkPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume the process when the app is resumed
      _barcodePickView.resume();
    } else {
      // Pause the process when the app goes in background
      _barcodePickView.pause();
    }
  }

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          if (value) {
            _barcodePickView.start();
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Restocking'),
          ),
          body: _barcodePickView),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didPick(String itemData, BarcodePickActionCallback callback) {
    // On pick, the callback will be notified if the pick action was successful
    // or not, by calling callback.fun didFinish(result).
    _bloc.pickItem(itemData, callback);
  }

  @override
  void didUnpick(String itemData, BarcodePickActionCallback callback) {
    // On unpick, the callback will be notified if the unpick action was successful
    // or not, by calling callback.fun didFinish(code, result).
    _bloc.unpickItem(itemData, callback);
  }

  @override
  void didTapFinishButton(BarcodePickView view) async {
    _barcodePickView.stop();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen()),
    );

    _barcodePickView.start();
  }
}
