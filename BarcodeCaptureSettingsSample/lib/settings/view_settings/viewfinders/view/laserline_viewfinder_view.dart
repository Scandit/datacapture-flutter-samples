/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/laserline_viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/laserline_style_item.dart';
import 'package:flutter/material.dart';

class LaserlineViewfinderSettingsView {
  final LaserlineViewfinderBloc _bloc;
  final Function _setState;
  late String widthText;

  LaserlineViewfinderSettingsView(this._setState, this._bloc);

  List<Widget> build(BuildContext context) {
    widthText = _bloc.widthDisplayText;
    return [
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Style"),
        subtitle: Text(_bloc.currentStyle.displayName),
        dense: false,
        onTap: () => _showStylePicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Width"),
        dense: false,
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(LaserlineWidthBloc())))
              .then((value) => _setState(() {
                    widthText = _bloc.widthDisplayText;
                  }))
        },
        trailing: Text(widthText),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Enabled Color"),
        subtitle: Text(_bloc.currentEnabledColor.name),
        dense: false,
        onTap: () => _showEnabledColorPicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Disabled Color"),
        subtitle: Text(_bloc.currentDisabledColor.name),
        dense: false,
        onTap: () => _showDisabledColorPicker(context),
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

  Future<void> _showStylePicker(BuildContext context) async {
    var selectedItem = await showDialog<LaserlineStyleItem>(
        context: context,
        builder: (BuildContext context) {
          return _getStylePickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentStyle = selectedItem;
      });
    }
  }

  SimpleDialog _getStylePickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Style"),
      children: _bloc.availableStyles
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.displayName),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }

  Future<void> _showEnabledColorPicker(BuildContext context) async {
    var selectedItem = await showDialog<ColorItem>(
        context: context,
        builder: (BuildContext context) {
          return _getEnabledColorPickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentEnabledColor = selectedItem;
      });
    }
  }

  SimpleDialog _getEnabledColorPickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Enabled Color"),
      children: _bloc.availableEnabledColors
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

  Future<void> _showDisabledColorPicker(BuildContext context) async {
    var selectedItem = await showDialog<ColorItem>(
        context: context,
        builder: (BuildContext context) {
          return _getDisabledColorPickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentDisabledColor = selectedItem;
      });
    }
  }

  SimpleDialog _getDisabledColorPickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Disabled Color"),
      children: _bloc.availableDisabledColors
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
