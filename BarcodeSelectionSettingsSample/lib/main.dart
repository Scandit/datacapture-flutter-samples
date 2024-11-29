/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/home/view/capture_view.dart';
import 'package:BarcodeSelectionSettingsSample/route/routes.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/duplicate_filter/view/code_duplicate_filter_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/feedback/view/feedback_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/point_of_interest/view/barcode_selection_point_of_interest_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/view/selection_type_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/single_barcode_auto_detection/view/single_barcode_auto_detection_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/view/symbologies_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/view/barcode_selection_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/camera/view/cemera_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/open_source_software_license_info/view/open_source_software_license_info_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/overlay/view/overlay_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/point_of_interest/view/point_of_interest_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/scan_area/view/scan_area_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/viewfinder/view/viewfinder_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/view/view_settings_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/view/main_settings_view.dart';
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
        initialRoute: BSRoutes.Home.routeName,
        routes: {
          BSRoutes.Home.routeName: (context) => CaptureView(BSRoutes.Home.viewTitle),
          BSRoutes.Settings.routeName: (context) => MainSettingsView(BSRoutes.Settings.viewTitle),
          BSRoutes.BarcodeSelectionSettings.routeName: (context) =>
              BarcodeSelectionSettingsView(BSRoutes.BarcodeSelectionSettings.viewTitle),
          BSRoutes.ViewSettings.routeName: (context) => ViewSettingsView(BSRoutes.ViewSettings.viewTitle),
          BSRoutes.CameraSettings.routeName: (context) => CameraSettingsView(BSRoutes.CameraSettings.viewTitle),
          BSRoutes.Symbologies.routeName: (context) => SymbologiesSettingsView(BSRoutes.Symbologies.viewTitle),
          BSRoutes.SelectionType.routeName: (context) => SelectionTypeSettingsView(BSRoutes.SelectionType.viewTitle),
          BSRoutes.SingleBarcodeAutoDetection.routeName: (context) =>
              SingleBarcodeAutoDetectionSettingsView(BSRoutes.SingleBarcodeAutoDetection.viewTitle),
          BSRoutes.Feedback.routeName: (context) => FeedbackSettingsView(BSRoutes.Feedback.viewTitle),
          BSRoutes.CodeDuplicateFilter.routeName: (context) =>
              CodeDuplicateFilterSettingsView(BSRoutes.CodeDuplicateFilter.viewTitle),
          BSRoutes.PointOfInterest.routeName: (context) =>
              BarcodeSelectionPointOfInterestSettingsView(BSRoutes.PointOfInterest.viewTitle),
          BSRoutes.ScanArea.routeName: (context) => ScanAreaSettingsView(BSRoutes.ScanArea.viewTitle),
          BSRoutes.ViewPointOfInterest.routeName: (context) =>
              PointOfInterestSettingsView(BSRoutes.ViewPointOfInterest.viewTitle),
          BSRoutes.Overlay.routeName: (context) => OverlaySettingsView(BSRoutes.Overlay.viewTitle),
          BSRoutes.Viewfinder.routeName: (context) => ViewfinderSettingsView(BSRoutes.Viewfinder.viewTitle),
          BSRoutes.OpenSourceSoftwareLicenseInfo.routeName: (context) =>
              OpenSourceSoftwareLicenseInfoView(BSRoutes.OpenSourceSoftwareLicenseInfo.viewTitle),
        });
  }
}
