/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/home/bloc/scan_bloc.dart';
import 'package:TextCaptureSample/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    _checkPermission();

    _bloc.textCaptureResultController.listen((scannedData) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Capture Result'),
            content: SingleChildScrollView(
              child: Text(scannedData),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Resume'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _bloc.enableTextCapture();
                },
              ),
            ],
          );
        },
      );
    });

    _bloc.textCaptureErrorController.listen((errorMessage) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: SingleChildScrollView(
              child: Text(errorMessage),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Resume'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _bloc.enableTextCapture();
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              new IconButton(
                icon: new Icon(Icons.settings),
                onPressed: () {
                  _bloc.switchCameraOff();
                  Navigator.pushNamed(context, TCRoutes.Settings.routeName).then((value) => _bloc.switchCameraOn());
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
      _bloc.enableTextCapture();
    }
  }

  T? _ambiguate<T>(T? value) => value;
}
