/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:matrixscancountsimplesample/home/bloc/matrix_scan_count_bloc.dart';
import 'package:matrixscancountsimplesample/result/model/result_screen_navigation_args.dart';
import 'package:matrixscancountsimplesample/result/model/result_screen_return.dart';
import 'package:matrixscancountsimplesample/result/model/scan_details.dart';
import 'package:matrixscancountsimplesample/route/sample_routes.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_count.dart';

import '../model/navigation_handler.dart';

class MatrixScanCountScreen extends StatefulWidget {
  final String title;

  MatrixScanCountScreen(this.title);

  // Create data capture context using your license key.
  @override
  _MatrixScanCountScreenState createState() => _MatrixScanCountScreenState();
}

class _MatrixScanCountScreenState extends State<MatrixScanCountScreen>
    with WidgetsBindingObserver
    implements NavigationHandler {
  late MatrixScanCountBloc _bloc;

  _MatrixScanCountScreenState() {
    _bloc = MatrixScanCountBloc(this);
  }

  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: BarcodeCountView.forContextWithModeAndStyle(
              _bloc.dataCaptureContext, _bloc.barcodeCount, BarcodeCountViewStyle.icon)
            ..uiListener = _bloc
            ..listener = _bloc,
        ),
        onWillPop: () {
          dispose();
          return Future.value(true);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc.didResume();
    } else if (state == AppLifecycleState.paused) {
      _bloc.didPause();
    }
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    _bloc.dispose();
    super.dispose();
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void navigateOnExitButtonTap(Map<String, ScanDetails> scannedItems) async {
    Navigator.pushNamed(
      context,
      SampleRoutes.Results.routeName,
      arguments: ResultScreenNavigationArgs(scannedItems, DoneButtonStyle.newScan),
    ).then((value) {
      if (!mounted) return;

      _bloc.resetSession().then((value) {
        // The click on the exit button will automatically disable the
        // mode and turn off the camera. We will run didResume to enable
        // the mode and turn on the camera again.
        _bloc.didResume();
      });
    });
  }

  @override
  void navigateOnListButtonTap(Map<String, ScanDetails> scannedItems) async {
    final result = await Navigator.pushNamed(
      context,
      SampleRoutes.Results.routeName,
      arguments: ResultScreenNavigationArgs(scannedItems, DoneButtonStyle.resume),
    );

    if (!mounted) return;

    if (result != null && result is ResultScreenReturn && result.executeReset) {
      // In case the click on the clear list happened we need to reset the session
      _bloc.resetSession();
    } else {
      _bloc.didResume();
    }
  }
}
