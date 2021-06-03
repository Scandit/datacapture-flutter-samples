/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:MatrixScanSimpleSample/main.dart';
import 'package:MatrixScanSimpleSample/scan_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class ScanResultsScreen extends StatelessWidget {
  final String title;

  ScanResultsScreen(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ScanResult> results = ModalRoute.of(context)?.settings.arguments as List<ScanResult>? ?? [];

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
      ),
      body: Column(children: [
        Expanded(
            child: ListView.separated(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  var result = results[index];
                  return Material(
                      child: ListTile(
                    title: PlatformText(
                      result.data,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: PlatformText(
                      SymbologyDescription.forSymbology(result.symbology).readableName,
                      style: TextStyle(color: Color(scanditBlue)),
                    ),
                  ));
                },
                separatorBuilder: (BuildContext context, int index) => const Divider())),
        Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(48.0),
          child: SizedBox(
              width: double.infinity,
              child: PlatformButton(
                  onPressed: () => _scanAgain(context),
                  material: (_, __) => MaterialRaisedButtonData(textColor: Colors.white),
                  cupertino: (_, __) => CupertinoButtonData(
                      color: Color(scanditBlue), borderRadius: BorderRadius.all(Radius.circular(3.0))),
                  child: PlatformText(
                    'Scan Again',
                    style: TextStyle(fontSize: 16),
                  ))),
        )
      ]),
    );
  }

  _scanAgain(BuildContext context) {
    Navigator.pop(context);
  }
}
