/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/result/bloc/result_settings_bloc.dart';
import 'package:flutter/material.dart';

class ResultSettingsView extends StatefulWidget {
  final String title;

  ResultSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResultSettingsViewState(ResultSettingsBloc());
  }
}

class _ResultSettingsViewState extends State<ResultSettingsView> with WidgetsBindingObserver {
  final ResultSettingsBloc _bloc;

  _ResultSettingsViewState(this._bloc);

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
                      value: _bloc.continuousScan,
                      title: Text("Continuous Scanning"),
                      onChanged: (value) {
                        setState(() {
                          _bloc.continuousScan = value;
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
