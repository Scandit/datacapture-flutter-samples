/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:USDLVerificationSample/home/bloc/usdl_verification_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

class USDLVerificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _USDLVerificationScreenState(USDLVerificationBloc());
}

class _USDLVerificationScreenState extends State<USDLVerificationScreen> with WidgetsBindingObserver {
  final USDLVerificationBloc _bloc;

  bool _isPermissionMessageVisible = false;

  _USDLVerificationScreenState(this._bloc);

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;

      final isGranted = status.isGranted;
      setState(() {
        _isPermissionMessageVisible = !isGranted;
      });

      if (isGranted) {
        _bloc.switchCameraOn();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _bloc.onIdCaptured.listen((capturedId) {
      _onCapturedIdEvent(capturedId);
    });

    _bloc.onIdRejected.listen((rejectedReason) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text(
                  rejectedReason,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                actions: [
                  GestureDetector(
                      child: Text('OK'),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              )).then((value) => {
            // Enable capture again, after the dialog is dismissed.
            _bloc.enableIdCapture()
          });
    });

    // Switch camera on to start streaming frames and enable the id capture mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = Text('No permission to access the camera!',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      child = _bloc.dataCaptureView;
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _cleanup();

        // Exit the app since this is the only screen
        SystemNavigator.pop();
      },
      child: Center(child: child),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission();
        break;
      default:
        _bloc.switchCameraOff();
        break;
    }
  }

  void _cleanup() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.dispose();
  }

  void _onCapturedIdEvent(CapturedId capturedId) async {
    _bloc.disableIdCapture();

    _showVerificationDialog();

    List<Text> result = [];

    try {
      result = _bloc.getResultMessage(capturedId);
    } catch (error) {
      if (error is PlatformException) {
        result.add(Text(
          error.details?.toString() ?? 'Unable to verify the document.',
          style: TextStyle(color: Colors.red, fontSize: 16),
        ));
      } else {
        result.add(Text(
          error.toString(),
          style: TextStyle(color: Colors.red, fontSize: 16),
        ));
      }
    }

    Navigator.of(context).pop();

    _showMessage(result);
  }

  void _showMessage(List<Text> results) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: results,
              ),
              actions: [
                GestureDetector(
                    child: Text('OK'),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            )).then((value) => {
          // Enable capture again, after the dialog is dismissed.
          _bloc.enableIdCapture()
        });
  }

  void _showVerificationDialog() {
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Running verification checks')
                ],
              ),
            ),
          );
        });
  }
}
