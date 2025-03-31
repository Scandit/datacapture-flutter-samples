/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:USDLVerificationSample/home/view/usdl_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_id/scandit_flutter_datacapture_id.dart';

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
      title: 'USDLVerificationSample',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            color: Colors.black,
            titleTextStyle: TextStyle(color: Colors.white)),
      ),
      home: USDLVerificationScreen(),
    );
  }
}
