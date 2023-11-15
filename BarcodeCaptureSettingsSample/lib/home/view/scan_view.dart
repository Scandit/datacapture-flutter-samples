/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:BarcodeCaptureSettingsSample/home/bloc/scan_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanView extends StatefulWidget {
  final String title;

  ScanView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScanViewState(ScanBloc());
  }
}

class _ScanViewState extends State<ScanView> with WidgetsBindingObserver {
  final ScanBloc _bloc;
  GlobalKey key = new GlobalKey<_ScanViewState>();
  late OverlayState _overlay;
  OverlayEntry? _entry;
  Timer? _dismissOverlay;

  _ScanViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    _checkPermission();

    _bloc.continuousScanResult.listen((scannedData) {
      _showPopup(scannedData);
    });

    _bloc.singleScanResult.listen((scannedData) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Scan Result'),
            content: SingleChildScrollView(
              child: Text(scannedData),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _bloc.enableBarcodeCapture();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _bloc.switchCameraOff();
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._overlay = Overlay.of(context);
    return WillPopScope(
        child: Scaffold(
          key: key,
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              new IconButton(
                icon: new Icon(Icons.settings),
                onPressed: () {
                  _bloc.switchCameraOff();
                  Navigator.pushNamed(context, BCRoutes.Settings.routeName).then((value) => _bloc.switchCameraOn());
                },
              )
            ],
          ),
          body: SafeArea(child: _bloc.dataCaptureView),
        ),
        onWillPop: () {
          dispose();
          return Future.value(true);
        });
  }

  void _checkPermission() async {
    // Check camera permission is granted before switching the camera on
    var permissionsResult = await Permission.camera.request();
    if (permissionsResult.isGranted) {
      // Switch camera on to start streaming frames.
      // The camera is started asynchronously and will take some time to completely turn on.
      _bloc.switchCameraOn();
      _bloc.enableBarcodeCapture();
    }
  }

  void _showPopup(String scannedData) {
    _removeOverlay();
    _entry = OverlayEntry(builder: (context) {
      return Positioned(
          left: 0,
          top: MediaQuery.of(context).size.height * 0.1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Material(
              color: Colors.white,
              child: Center(
                child: Text(scannedData),
              ),
            ),
          ));
    });
    _overlay.insert(_entry!);
    _dismissOverlay?.cancel();
    _dismissOverlay = Timer(Duration(milliseconds: 500), _removeOverlay);
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  T? _ambiguate<T>(T? value) => value;
}
