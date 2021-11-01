/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/view_settings/controls/bloc/controls_bloc.dart';
import 'package:flutter/material.dart';

class ControlsSettingsView extends StatefulWidget {
  final String title;

  ControlsSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ControlsSettingsViewState(ControlsBloc());
  }
}

class _ControlsSettingsViewState extends State<ControlsSettingsView> with WidgetsBindingObserver {
  final ControlsBloc _bloc;

  _ControlsSettingsViewState(this._bloc);

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
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _createSwitchCard(
                    'Torch Button',
                    _bloc.isTorchControlEnabled,
                    (value) => {
                          setState(() {
                            _bloc.isTorchControlEnabled = value;
                          })
                        }),
                _createSwitchCard(
                    'Zoom Switch Control',
                    _bloc.isZoomSwitchControlEnabled,
                    (value) => {
                          setState(() {
                            _bloc.isZoomSwitchControlEnabled = value;
                          })
                        })
              ]),
        ),
      ),
    );
  }

  Widget _createSwitchCard(String text, bool value, Function(bool) onChange) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(children: <Widget>[
        SwitchListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
          value: value,
          title: Text(text),
          onChanged: (value) {
            onChange(value);
          },
        ),
      ]),
    );
  }
}
