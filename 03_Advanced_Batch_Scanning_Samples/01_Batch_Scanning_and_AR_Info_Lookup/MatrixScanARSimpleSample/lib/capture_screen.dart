/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/capture_bloc.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  CaptureScreenState createState() => CaptureScreenState();
}

class CaptureScreenState extends State<CaptureScreen>
    with WidgetsBindingObserver
    implements BarcodeArHighlightProvider, BarcodeArAnnotationProvider {
  final BarcodeArBloc bloc = BarcodeArBloc();

  BarcodeArView? barcodeArView;

  CaptureScreenState() : super();

  @override
  void initState() {
    super.initState();
    bloc.init();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();

    barcodeArView = BarcodeArView.forModeWithViewSettingsAndCameraSettings(
      bloc.dataCaptureContext,
      bloc.barcodeAr,
      bloc.barcodeArViewSettings,
      bloc.cameraSettings,
    )
      ..highlightProvider = this
      ..annotationProvider = this;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: barcodeArView,
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission();
        break;
      default:
        bloc.stopCapturing();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bloc.dispose();
    super.dispose();
  }

  @override
  Future<BarcodeArHighlight?> highlightForBarcode(Barcode barcode) {
    return bloc.highlightForBarcode(barcode);
  }

  @override
  Future<BarcodeArAnnotation?> annotationForBarcode(Barcode barcode) async {
    return bloc.annotationForBarcode(barcode);
  }

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;

      if (status.isGranted) {
        bloc.startCapturing();
      }
    });
  }
}
