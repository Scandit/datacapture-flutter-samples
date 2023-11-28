/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/route/routes.dart';
import 'package:TextCaptureSample/settings/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_text/scandit_flutter_datacapture_text.dart';

import 'home/view/scan_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureText.initialize();
  runApp(MyApp());
}

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
        initialRoute: TCRoutes.Home.routeName,
        routes: {
          TCRoutes.Home.routeName: (context) => ScanView(TCRoutes.Home.viewTitle),
          TCRoutes.Settings.routeName: (context) => SettingsView(TCRoutes.Settings.viewTitle),
        });
  }
}
