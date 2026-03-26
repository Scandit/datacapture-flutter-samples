/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'popovers_bloc.dart';
import '../../widgets/barcode_ar_scaffold.dart';

class PopoversScreen extends StatefulWidget {
  const PopoversScreen({super.key});

  @override
  PopoversScreenState createState() => PopoversScreenState();
}

class PopoversScreenState extends State<PopoversScreen>
    with WidgetsBindingObserver
    implements BarcodeArHighlightProvider, BarcodeArAnnotationProvider {
  final PopoversBloc _bloc = PopoversBloc();
  BarcodeArView? _barcodeArView;

  @override
  void initState() {
    super.initState();
    _bloc.init();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();

    _barcodeArView = BarcodeArView.forModeWithViewSettingsAndCameraSettings(
      _bloc.dataCaptureContext,
      _bloc.barcodeAr,
      _bloc.barcodeArViewSettings,
      _bloc.cameraSettings,
    )
      ..highlightProvider = this
      ..annotationProvider = this;
  }

  @override
  Widget build(BuildContext context) {
    return BarcodeArScaffold(
      title: 'Popovers',
      barcodeArView: _barcodeArView!,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkPermission();
        break;
      default:
        _bloc.stopCapturing();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.dispose();
    super.dispose();
  }

  @override
  Future<BarcodeArHighlight?> highlightForBarcode(Barcode barcode) {
    return _bloc.highlightForBarcode(barcode);
  }

  @override
  Future<BarcodeArAnnotation?> annotationForBarcode(Barcode barcode) {
    return _bloc.annotationForBarcode(barcode);
  }

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;
      if (status.isGranted) {
        _bloc.startCapturing();
      }
    });
  }
}
