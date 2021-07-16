/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/bloc/overlay_settings_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/overlay/model/brush_item.dart';
import 'package:flutter/material.dart';

class OverlaySettingsView extends StatefulWidget {
  final String title;

  OverlaySettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OverlaySettingsViewState(OverlaySettingsBloc());
  }
}

class _OverlaySettingsViewState extends State<OverlaySettingsView> with WidgetsBindingObserver {
  final OverlaySettingsBloc _bloc;

  _OverlaySettingsViewState(this._bloc);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Brush"),
                  subtitle: Text(_bloc.selectedBrush.displayName),
                  dense: false,
                  onTap: () => _showBrushPicker(),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showBrushPicker() async {
    var newItem = await showDialog<BrushItem>(
        context: context,
        builder: (BuildContext context) {
          return _getCameraPositionDialog(context);
        });
    if (newItem != null) {
      setState(() {
        _bloc.selectedBrush = newItem;
      });
    }
  }

  SimpleDialog _getCameraPositionDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Brush"),
      children: _bloc.availableBrushes
          .map((position) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(position.displayName),
                onPressed: () {
                  Navigator.pop(context, position);
                },
              ))
          .toList(),
    );
  }
}
