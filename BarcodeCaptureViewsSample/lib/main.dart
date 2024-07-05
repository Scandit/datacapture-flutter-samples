/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'splitview/view/barcode_capture_split_view.dart';
import 'home/view/home_screen.dart';
import 'package:BarcodeCaptureViewsSample/route/barcode_capture_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(MyApp());
}

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        listTileTheme: ListTileThemeData(
          tileColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white)),
      ),
      title: 'Barcode Capture',
      initialRoute: BCRoutes.Home.routeName,
      routes: {
        BCRoutes.Home.routeName: (context) => HomeScreen(BCRoutes.Home.viewTitle),
        BCRoutes.SplitView.routeName: (context) =>
            BarcodeCaptureSplitView(DataCaptureContext.forLicenseKey(licenseKey), BCRoutes.SplitView.viewTitle),
      },
    );
  }
}
