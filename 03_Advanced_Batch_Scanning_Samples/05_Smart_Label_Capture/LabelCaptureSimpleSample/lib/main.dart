/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_flutter_datacapture_label/scandit_flutter_datacapture_label.dart';
import 'package:LabelCaptureSimpleSample/core/utils/dependency_injection.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/pages/label_capture_page.dart';

// Enter your Scandit License key here.
// Your Scandit License key is available via your Scandit SDK web account.
const String licenseKey = '-- ENTER YOUR SCANDIT LICENSE KEY HERE --';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Scandit SDKs
  await ScanditFlutterDataCaptureLabel.initialize();

  // Initialize the DataCaptureContext
  DataCaptureContext.initialize(licenseKey);

  // Initialize dependencies
  await dependencies.initialize();

  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Capture Simple Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      home: BlocProvider(
        create: (context) => dependencies.createLabelCaptureBloc(),
        child: LabelCapturePage(dataSource: dependencies.dataSource),
      ),
    );
  }
}
