/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/home/bloc/capture_bloc.dart';
import 'package:BarcodeSelectionSettingsSample/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CaptureView extends StatefulWidget {
  final String title;

  CaptureView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CaptureViewState(CaptureBloc());
  }
}

class _CaptureViewState extends BaseState<CaptureView> with WidgetsBindingObserver {
  final CaptureBloc _bloc;
  GlobalKey key = new GlobalKey<_CaptureViewState>();

  _CaptureViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addObserver(this);

    _checkPermission();

    _bloc.barcodeSelectedStream.listen((selectionData) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(selectionData),
        duration: Duration(milliseconds: 500),
        behavior: SnackBarBehavior.floating,
      ));
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
      key: key,
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          new IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () {
              _bloc.switchCameraOff();
              Navigator.pushNamed(context, BSRoutes.Settings.routeName).then((value) => _bloc.switchCameraOn());
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
