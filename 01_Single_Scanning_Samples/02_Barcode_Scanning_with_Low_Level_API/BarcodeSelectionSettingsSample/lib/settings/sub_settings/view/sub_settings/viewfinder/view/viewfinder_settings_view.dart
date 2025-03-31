/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/viewfinder/bloc/viewfinder_settings_bloc.dart';
import 'package:flutter/material.dart';

class ViewfinderSettingsView extends StatefulWidget {
  final String title;

  ViewfinderSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewfinderSettingsViewState(ViewfinderSettingsBloc());
  }
}

class _ViewfinderSettingsViewState extends BaseState<ViewfinderSettingsView> with WidgetsBindingObserver {
  final ViewfinderSettingsBloc _bloc;

  _ViewfinderSettingsViewState(this._bloc);

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
                  title: Text("Frame Color"),
                  subtitle: Text(_bloc.frameColor.name),
                  dense: false,
                  onTap: () => showPicker(context, "Frame Color", _bloc.availableFrameColors, (newColorItem) {
                    setState(() {
                      _bloc.frameColor = newColorItem;
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
                  title: Text("Dot Color"),
                  subtitle: Text(_bloc.dotColor.name),
                  dense: false,
                  onTap: () => showPicker(context, "Dot Color", _bloc.availableDotColors, (newColorItem) {
                    setState(() {
                      _bloc.dotColor = newColorItem;
                    });
                  }),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
