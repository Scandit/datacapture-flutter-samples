/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/overlay/bloc/overlay_settings_bloc.dart';
import 'package:flutter/material.dart';

class OverlaySettingsView extends StatefulWidget {
  final String title;

  OverlaySettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OverlaySettingsViewState(OverlaySettingsBloc());
  }
}

class _OverlaySettingsViewState extends BaseState<OverlaySettingsView> with WidgetsBindingObserver {
  final OverlaySettingsBloc _bloc;

  _OverlaySettingsViewState(this._bloc);

  @override
  void initState() {
    super.initState();
  }

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              getCard(20.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Style"),
                  subtitle: Text(_bloc.style.name),
                  dense: false,
                  onTap: () => showPicker(context, "Style", _bloc.availableStyles, (newItem) {
                    setState(() {
                      _bloc.style = newItem.value;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 20, 4, 4),
                child: Text('Bushes'),
              ),
              getCard(4.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text('Tracked Brush'),
                  subtitle: Text(_bloc.trackedBrushColor.name),
                  dense: false,
                  onTap: () => showPicker(context, 'Tracked Brush', _bloc.availableTrackedBrushColors, (newItem) {
                    setState(() {
                      _bloc.trackedBrushColor = newItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(1.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text('Aimed Brush'),
                  subtitle: Text(_bloc.aimedBrushColor.name),
                  dense: false,
                  onTap: () => showPicker(context, 'Aimed Brush', _bloc.availableAimedBrushColors, (newItem) {
                    setState(() {
                      _bloc.aimedBrushColor = newItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(1.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text('Selecting Brush'),
                  subtitle: Text(_bloc.selectingBrushColor.name),
                  dense: false,
                  onTap: () => showPicker(context, 'Selecting Brush', _bloc.availableSelectingBrushColors, (newItem) {
                    setState(() {
                      _bloc.selectingBrushColor = newItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(1.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text('Selected Brush'),
                  subtitle: Text(_bloc.selectedBrushColor.name),
                  dense: false,
                  onTap: () => showPicker(context, 'Selected Brush', _bloc.availableSelectedBrushColors, (newItem) {
                    setState(() {
                      _bloc.selectedBrushColor = newItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(20.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text('Frozen Background Color'),
                  subtitle: Text(_bloc.frozeBackgroundColor.name),
                  dense: false,
                  onTap: () =>
                      showPicker(context, 'Frozen Background Color', _bloc.availableFrozenBackgroundColors, (newItem) {
                    setState(() {
                      _bloc.frozeBackgroundColor = newItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(20.0, <Widget>[
                SwitchListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  value: _bloc.shouldShowHints,
                  title: Text("Should Show Hints"),
                  onChanged: (value) {
                    setState(() {
                      _bloc.shouldShowHints = value;
                    });
                  },
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
