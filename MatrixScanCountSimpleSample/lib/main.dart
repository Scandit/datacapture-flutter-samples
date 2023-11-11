/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

import 'home/view/matrix_scan_count_screen.dart';
import 'result/bloc/result_bloc.dart';
import 'result/model/result_screen_navigation_args.dart';
import 'result/view/result_screen.dart';
import 'route/sample_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatrixScanCountSimpleSample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          color: Colors.black,
        ),
      ),
      initialRoute: SampleRoutes.Home.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == SampleRoutes.Results.routeName) {
          final args = settings.arguments as ResultScreenNavigationArgs;

          return MaterialPageRoute(
            builder: (context) {
              return ResultScreen(
                SampleRoutes.Results.viewTitle,
                ResultBloc(args.scannedItems, args.doneButtonStyle),
              );
            },
          );
        }
        return null;
      },
      routes: {
        SampleRoutes.Home.routeName: (context) => MatrixScanCountScreen(SampleRoutes.Home.viewTitle),
      },
    );
  }
}
