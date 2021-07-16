/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/aimer_viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';
import 'package:flutter/material.dart';

class AimerViewfinderSettingsView {
  final AimerViewfinderBloc _bloc;
  final Function _setState;

  AimerViewfinderSettingsView(this._setState, this._bloc);

  List<Widget> build(BuildContext context) {
    return [
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Frame Color"),
        subtitle: Text(_bloc.currentFrameColor.name),
        dense: false,
        onTap: () => _showFrameColorPicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Dot Color"),
        subtitle: Text(_bloc.currentDotColor.name),
        dense: false,
        onTap: () => _showDotColorPicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      )
    ];
  }

  void dispose() {
    _bloc.dispose();
  }

  Future<void> _showFrameColorPicker(BuildContext context) async {
    var selectedItem = await showDialog<ColorItem>(
        context: context,
        builder: (BuildContext context) {
          return _getFrameColorPickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState(() {
        _bloc.currentFrameColor = selectedItem;
      });
    }
  }

  SimpleDialog _getFrameColorPickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Frame Color"),
      children: _bloc.availableFrameColors
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.name),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }

  Future<void> _showDotColorPicker(BuildContext context) async {
    var selectedItem = await showDialog<ColorItem>(
        context: context,
        builder: (BuildContext context) {
          return _getDotColorPickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState(() {
        _bloc.currentDotColor = selectedItem;
      });
    }
  }

  SimpleDialog _getDotColorPickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Dot Color"),
      children: _bloc.availableDotColors
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.name),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }
}
