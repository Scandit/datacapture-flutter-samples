/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/result/view/result_view.dart';
import 'package:IdCaptureExtendedSample/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

import 'home/view/id_capture_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureId.initialize();
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
        initialRoute: ICRoutes.Home.routeName,
        routes: {
          ICRoutes.Home.routeName: (context) => IdCaptureView(ICRoutes.Home.viewTitle),
          ICRoutes.Result.routeName: (context) => ResultView(ICRoutes.Home.viewTitle),
        });
  }
}
