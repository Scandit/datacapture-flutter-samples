/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/single_barcode_auto_detection/bloc/single_barcode_auto_detection_settings_bloc.dart';
import 'package:flutter/material.dart';

class SingleBarcodeAutoDetectionSettingsView extends StatefulWidget {
  final String title;

  SingleBarcodeAutoDetectionSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SingleBarcodeAutoDetectionSettingsViewState(SingleBarcodeAutoDetectionSettingsBloc());
  }
}

class _SingleBarcodeAutoDetectionSettingsViewState extends BaseState<SingleBarcodeAutoDetectionSettingsView>
    with WidgetsBindingObserver {
  final SingleBarcodeAutoDetectionSettingsBloc _bloc;

  _SingleBarcodeAutoDetectionSettingsViewState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(widget.title),
          onDoubleTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 2, 2, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getCard(
                4.0,
                <Widget>[
                  SwitchListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                    value: _bloc.singleBarcodeAutoDetection,
                    title: Text("Single Barcode Auto Detection"),
                    subtitle: Text(
                      _bloc.singleBarcodeAutoDetection ? "Enabled" : "Disabled",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _bloc.singleBarcodeAutoDetection = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
