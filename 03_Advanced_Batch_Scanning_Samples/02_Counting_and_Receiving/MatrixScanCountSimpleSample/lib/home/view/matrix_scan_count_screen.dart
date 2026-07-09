/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          // Cleanup everything on back press because this is the only screen
          _cleanup();

          // Exit the app since this is the only screen
          SystemNavigator.pop();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isPortrait = constraints.maxHeight >= constraints.maxWidth;
                // BarcodeCount always uses a 4:3 camera. Constraining the view to 9:16 portrait
                // (or 16:9 landscape) produces a container that fits the 4:3 preview plus the
                // BarcodeCountView's bottom UI chrome strip, with no overlap between them.
                return Align(
                  alignment: isPortrait ? Alignment.bottomCenter : Alignment.center,
                  child: AspectRatio(
                    aspectRatio: isPortrait ? 9 / 16 : 16 / 9,
                    child: BarcodeCountView.forContextWithModeAndStyle(
                        _bloc.dataCaptureContext, _bloc.barcodeCount, BarcodeCountViewStyle.icon)
                      ..uiListener = _bloc
                      ..listener = _bloc,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _bloc.didResume();
        break;
      default:
        _bloc.didPause();
        break;
    }
  }

  void _cleanup() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.dispose();
  }

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
