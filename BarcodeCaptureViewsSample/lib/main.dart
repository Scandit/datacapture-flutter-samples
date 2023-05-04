/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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

const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformApp(
      title: 'Barcode Capture',
      cupertino: (_, __) => CupertinoAppData(theme: CupertinoThemeData(brightness: Brightness.light)),
      initialRoute: BCRoutes.Home.routeName,
      routes: {
        BCRoutes.Home.routeName: (context) => HomeScreen(BCRoutes.Home.viewTitle),
        BCRoutes.SplitView.routeName: (context) =>
            BarcodeCaptureSplitView(DataCaptureContext.forLicenseKey(licenseKey), BCRoutes.SplitView.viewTitle),
      },
    );
  }
}
