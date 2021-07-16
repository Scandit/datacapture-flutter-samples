/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'dart:io';

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

  _ScanViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

    _checkPermission();

    _bloc.continuousScanResult.listen((scannedData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(scannedData),
        duration: Duration(milliseconds: 500),
      ));
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
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
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
}
