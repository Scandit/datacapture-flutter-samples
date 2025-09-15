/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:ListBuildingSample/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_spark_scan.dart';

import '../model/scanned_item.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen(this.title);

  @override
  _HomeScreenState createState() => _HomeScreenState(HomeBloc());
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeBloc _homeBloc;

  final List<ScannedItem> _scannedItems = [];

  _HomeScreenState(this._homeBloc);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    _homeBloc.scannedItemsStream.listen((event) {
      setState(() {
        _scannedItems.add(event);
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    var sparkScanView = SparkScanView.forContext(
        getWidgetBody(), _homeBloc.dataCaptureContext, _homeBloc.sparkScan, _homeBloc.sparkScanViewSettings)
      ..feedbackDelegate = _homeBloc;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(child: sparkScanView),
    );
  }

  Widget getWidgetBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15, top: 5),
          child: new Text(Intl.plural(_scannedItems.length, other: "${_scannedItems.length} Items", one: "1 Item"),
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: _scannedItems.length,
            itemBuilder: (BuildContext context, int index) {
              // return row
              var item = _scannedItems[index];
              return new ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  color: Colors.grey,
                ),
                title: Text(item.title),
                subtitle: Text(item.description),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
          child: TextButton(
            onPressed: () {
              _homeBloc.clear();
              setState(() {
                _scannedItems.clear();
              });
            },
            child: Center(
              child: Text("CLEAR LIST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            style: TextButton.styleFrom(
                side: BorderSide(width: 2.0), padding: EdgeInsets.all(15), shape: RoundedRectangleBorder()),
          ),
        ),
      ],
    );
  }

  void _checkPermission() {
    // Check camera permission is granted before handling the camera
    Permission.camera.request().then((status) {
      if (!mounted) return;

      if (!status.isGranted) {
        print("Camera permission denied!!");
      }
    });
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
