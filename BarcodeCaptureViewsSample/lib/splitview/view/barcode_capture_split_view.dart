/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';
import 'dart:io' show Platform;

import 'package:BarcodeCaptureViewsSample/splitview/bloc/barcode_capture_split_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class BarcodeCaptureSplitView extends StatefulWidget {
  final DataCaptureContext dataCaptureContext;
  final String title;

  BarcodeCaptureSplitView(this.dataCaptureContext, this.title, {Key? key}) : super(key: key);

  @override
  _BarcodeCaptureSplitViewState createState() =>
      _BarcodeCaptureSplitViewState(BarcodeCaptureSplitBloc(dataCaptureContext));
}

class _BarcodeCaptureSplitViewState extends State<BarcodeCaptureSplitView> with WidgetsBindingObserver {
  final BarcodeCaptureSplitBloc _bloc;

  _BarcodeCaptureSplitViewState(this._bloc);

  bool _isCapturingEnabled = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkPermission();

    _bloc.isCapturing.listen((enabled) {
      setState(() {
        _isCapturingEnabled = enabled;
      });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(Icons.delete, size: 26),
              padding: Platform.isIOS ? EdgeInsets.only(bottom: 6) : null,
              onPressed: () => _onClearClick(context),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox.fromSize(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: _bloc.captureView,
                  ),
                  Positioned(
                    child: _getTapToContinueOverlayWidget(),
                  ),
                ],
              ),
              size: widgets.Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.5),
            ),
            // Observing the tracked barcodes
            Expanded(
              child: StreamBuilder(
                stream: _bloc.capturedBarcodes,
                builder: (BuildContext context, AsyncSnapshot<List<Barcode>> snapshot) {
                  if (snapshot.hasData) return _getScannedBarcodesWidget(snapshot.data ?? List.empty());
                  if (snapshot.hasError) return Center(child: Text('${snapshot.error}'));
                  return Center(child: Text('Empty'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTapToContinueOverlayWidget() {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: GestureDetector(
        onTap: () {
          _bloc.resumeCapturing();
        },
        child: Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black87.withOpacity(0.7)),
                child: Center(
                  child: Text(
                    'Tap to continue',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      visible: !_isCapturingEnabled,
    );
  }

  Widget _getScannedBarcodesWidget(List<Barcode> barcodes) {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      separatorBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(
            left: 10.0,
            right: 0.0,
          ),
          child: Divider(
            color: Colors.black54,
          ),
        );
      },
      itemCount: barcodes.length,
      itemBuilder: (BuildContext context, int index) {
        return _getBarcodeItemWidget(barcodes[index]);
      },
    );
  }

  Widget _getBarcodeItemWidget(Barcode barcode) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(barcode.data ?? ''),
          Text(
            barcode.symbology.toString(),
            style: TextStyle(color: Colors.cyan),
          )
        ],
      ),
    );
  }

  void _onClearClick(BuildContext context) {
    _bloc.clearCapturedBarcodes();
  }

  void _checkPermission() {
    // Check camera permission is granted before switching the camera on
    Permission.camera.request().isGranted.then((value) {
      if (value && _isCapturingEnabled) {
        // Switch camera on to start streaming frames.
        // The camera is started asynchronously and will take some time to completely turn on.
        _bloc.switchCameraOn();
      }
    });
  }

  @override
  void dispose() {
    _bloc.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
