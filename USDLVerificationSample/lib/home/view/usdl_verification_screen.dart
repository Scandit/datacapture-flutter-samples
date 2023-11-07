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
  // Create data capture context using your license key.
  @override
  State<StatefulWidget> createState() => _USDLVerificationScreenState(USDLVerificationBloc());
}

class _USDLVerificationScreenState extends State<USDLVerificationScreen> with WidgetsBindingObserver {
  final USDLVerificationBloc _bloc;

  bool _isPermissionMessageVisible = false;

  _USDLVerificationScreenState(this._bloc);

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _bloc.switchCameraOn();
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _bloc.onIdCaptured.listen((capturedId) {
      _onCapturedIdEvent(capturedId);
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
    return WillPopScope(
        child: Center(child: child),
        onWillPop: () {
          dispose();
          return Future.value(true);
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
    WidgetsBinding.instance.removeObserver(this);
    _bloc.dispose();
    super.dispose();
  }

  void _onCapturedIdEvent(CapturedId capturedId) async {
    if (!_bloc.isUSDocument(capturedId)) {
      _bloc.resetIdCapture();
      _showMessage("Document is not a US driver’s license.");
      return;
    }

    if (_bloc.isBackScanNeeded(capturedId)) {
      return;
    }
    _bloc.disableIdCapture();

    _showVerificationDialog();

    // If document scanning is complete, verify the driver's license.
    var comparisonResult = await _bloc.compareFrontAndBack(capturedId);

    var message = "";

    // If front and back match AND ID is not expired, run verification
    if (comparisonResult.checksPassed && capturedId.isExpired == false) {
      try {
        var verificationResult = await _bloc.verifyIdOnBarcode(capturedId);

        message = _bloc.getResultMessage(
            capturedId, false, comparisonResult.checksPassed, verificationResult.allChecksPassed);
      } catch (error) {
        if (error is PlatformException) {
          message = error.details ?? "Unable to verify the document.";
        } else {
          message = error.toString();
        }
      }
    } else {
      message = _bloc.getResultMessage(capturedId, capturedId.isExpired == true, comparisonResult.checksPassed, false);
    }

    Navigator.of(context).pop();

    _showMessage(message);
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text(
                message,
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
