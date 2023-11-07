/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/home/view/scan_view.dart';
import 'package:BarcodeCaptureSettingsSample/route/routes.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/code_duplicate/view/code_duplicate_filter_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/composite_types/view/composite_types_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/feedback/view/feedback_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/view/location_selection_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/symbologies/view/symbologies_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/view/barcode_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/camera/view/cemera_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/main/view/main_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/result/view/result_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/controls/view/controls_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/gestures/view/gesture_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/logo/view/logo_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/view/overlay_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/point_of_interest/view/point_of_interest_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/scan_area/view/scan_area_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/view/view_settings_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/view/viewfinder_view.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScanditFlutterDataCaptureBarcode.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        initialRoute: BCRoutes.Home.routeName,
        routes: {
          BCRoutes.Home.routeName: (context) => ScanView(BCRoutes.Home.viewTitle),
          BCRoutes.Settings.routeName: (context) => MainSettingsView(BCRoutes.Settings.viewTitle),
          BCRoutes.CameraSettings.routeName: (context) => CameraSettingsView(BCRoutes.CameraSettings.viewTitle),
          BCRoutes.BarcodeCaptureSettings.routeName: (context) =>
              BarcodeSettingsView(BCRoutes.BarcodeCaptureSettings.viewTitle),
          BCRoutes.Symbologies.routeName: (context) => SymbologiesSettingsView(BCRoutes.Symbologies.viewTitle),
          BCRoutes.LocationSelection.routeName: (context) =>
              LocationSelectionSettingsView(BCRoutes.LocationSelection.viewTitle),
          BCRoutes.Feedback.routeName: (context) => FeedbackSettingsView(BCRoutes.Feedback.viewTitle),
          BCRoutes.ViewSettings.routeName: (context) => ViewSettingsView(BCRoutes.ViewSettings.viewTitle),
          BCRoutes.Overlay.routeName: (context) => OverlaySettingsView(BCRoutes.Overlay.viewTitle),
          BCRoutes.ResultSettings.routeName: (context) => ResultSettingsView(BCRoutes.ResultSettings.viewTitle),
          BCRoutes.CodeDuplicateFilter.routeName: (context) =>
              CodeDuplicateFilterSettingsView(BCRoutes.CodeDuplicateFilter.viewTitle),
          BCRoutes.CompositeTypes.routeName: (context) => CompositeTypesSettingsView(BCRoutes.CompositeTypes.viewTitle),
          BCRoutes.ScanArea.routeName: (context) => ScanAreaSettingsView(BCRoutes.ScanArea.viewTitle),
          BCRoutes.PointOfInterest.routeName: (context) =>
              PointOfInterestSettingsView(BCRoutes.PointOfInterest.viewTitle),
          BCRoutes.Viewfinder.routeName: (context) => ViewfindersSettingsView(BCRoutes.Viewfinder.viewTitle),
          BCRoutes.Logo.routeName: (context) => LogoSettingsView(BCRoutes.Logo.viewTitle),
          BCRoutes.Gestures.routeName: (context) => GesturesSettingsView(BCRoutes.Gestures.viewTitle),
          BCRoutes.Controls.routeName: (context) => ControlsSettingsView(BCRoutes.Controls.viewTitle),
        });
  }
}
