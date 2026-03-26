/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';
import 'package:permission_handler/permission_handler.dart';

import 'highlights_bloc.dart';
import '../../widgets/barcode_ar_scaffold.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  HighlightsScreenState createState() => HighlightsScreenState();
}

class HighlightsScreenState extends State<HighlightsScreen>
    with WidgetsBindingObserver
    implements BarcodeArHighlightProvider {
  final HighlightsBloc _bloc = HighlightsBloc();
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
      ..uiListener = _bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BarcodeArScaffold(
      title: 'Highlights',
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

  void _checkPermission() {
    Permission.camera.request().then((status) {
      if (!mounted) return;
      if (status.isGranted) {
        _bloc.startCapturing();
      }
    });
  }
}
