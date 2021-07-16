/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/view_settings/gestures/bloc/gestures_bloc.dart';
import 'package:flutter/material.dart';

class GesturesSettingsView extends StatefulWidget {
  final String title;

  GesturesSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GesturesSettingsViewState(GesturesBloc());
  }
}

class _GesturesSettingsViewState extends State<GesturesSettingsView> with WidgetsBindingObserver {
  final GesturesBloc _bloc;

  _GesturesSettingsViewState(this._bloc);

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
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Column(children: <Widget>[
                    SwitchListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                      value: _bloc.isTapToFocusEnabled,
                      title: Text("Tap to Focus"),
                      onChanged: (value) {
                        setState(() {
                          _bloc.isTapToFocusEnabled = value;
                        });
                      },
                    ),
                  ]),
                ),
                Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  child: Column(children: <Widget>[
                    SwitchListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                      value: _bloc.isSwipeToZoomEnabled,
                      title: Text("Swipe to Zoom"),
                      onChanged: (value) {
                        setState(() {
                          _bloc.isSwipeToZoomEnabled = value;
                        });
                      },
                    ),
                  ]),
                ),
              ]),
        ),
      ),
    );
  }
}
