/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'info_annotations_bloc.dart';
import '../../widgets/barcode_ar_scaffold.dart';

class InfoAnnotationsScreen extends StatefulWidget {
  const InfoAnnotationsScreen({super.key});

  @override
  InfoAnnotationsScreenState createState() => InfoAnnotationsScreenState();
}

class InfoAnnotationsScreenState extends State<InfoAnnotationsScreen>
    with WidgetsBindingObserver
    implements BarcodeArHighlightProvider, BarcodeArAnnotationProvider {
  final InfoAnnotationsBloc _bloc = InfoAnnotationsBloc();
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
      title: 'Info Annotations',
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
