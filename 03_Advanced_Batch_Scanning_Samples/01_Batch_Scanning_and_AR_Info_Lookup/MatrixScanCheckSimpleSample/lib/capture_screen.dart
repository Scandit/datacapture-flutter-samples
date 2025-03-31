/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_check.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/capture_bloc.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  CaptureScreenState createState() => CaptureScreenState();
}

class CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver
    implements BarcodeCheckHighlightProvider, BarcodeCheckAnnotationProvider {
  final BarcodeCheckBloc bloc = BarcodeCheckBloc();

  BarcodeCheckView? barcodeCheckView;

  CaptureScreenState() : super();

  @override
  void initState() {
    super.initState();
    bloc.init();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();

    barcodeCheckView = BarcodeCheckView.forModeWithViewSettingsAndCameraSettings(
      bloc.dataCaptureContext,
      bloc.barcodeCheck,
      bloc.barcodeCheckViewSettings,
      bloc.cameraSettings,
    )
      ..highlightProvider = this
      ..annotationProvider = this;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: barcodeCheckView,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bloc.dispose();
    super.dispose();
  }

  @override
  Future<BarcodeCheckHighlight?> highlightForBarcode(Barcode barcode) {
    return bloc.highlightForBarcode(barcode);
  }

  @override
  Future<BarcodeCheckAnnotation?> annotationForBarcode(Barcode barcode) async {
    return bloc.annotationForBarcode(barcode);
  }

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          if (value) {
            bloc.startCapturing();
          }
        }));
  }
}
