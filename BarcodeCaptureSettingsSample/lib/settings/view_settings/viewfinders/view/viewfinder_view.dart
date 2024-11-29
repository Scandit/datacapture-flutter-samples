/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/aimer_viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/rectangular_viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/view/rectangular_viewfinder_view.dart';
import 'package:flutter/material.dart';

import 'aimer_viewfinder_view.dart';

class ViewfindersSettingsView extends StatefulWidget {
  final String title;

  ViewfindersSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewfindersSettingsViewState(ViewfindersBloc());
  }
}

class _ViewfindersSettingsViewState extends State<ViewfindersSettingsView> with WidgetsBindingObserver {
  final ViewfindersBloc _bloc;
  late AimerViewfinderSettingsView _aimerViewfinderSettingsView;
  late RectangularViewfinderSettingsView _rectangularViewfinderSettingsView;

  _ViewfindersSettingsViewState(this._bloc) {
    _aimerViewfinderSettingsView = AimerViewfinderSettingsView(this.setState, AimerViewfinderBloc());
    _rectangularViewfinderSettingsView = RectangularViewfinderSettingsView(this.setState, RectangularViewfinderBloc());
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Column(children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("Type"),
                    subtitle: Text(_bloc.currentViewfinder.name),
                    dense: false,
                    onTap: () => _showViewfinderTypesPicker(),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ),
                ]),
              ),
              Visibility(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 12.0, 4.0, 0),
                  child: Text(
                    _bloc.currentViewfinder.name,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                visible: _bloc.currentViewfinder != Viewfinders.none,
              ),
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Column(
                  children: _getSelectedViewfinderConfigurationViews(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _aimerViewfinderSettingsView.dispose();
    _rectangularViewfinderSettingsView.dispose();
    super.dispose();
  }

  List<Widget> _getSelectedViewfinderConfigurationViews(BuildContext context) {
    switch (_bloc.currentViewfinder) {
      case Viewfinders.none:
        return [];
      case Viewfinders.rectangular:
        return _rectangularViewfinderSettingsView.build(context);
      case Viewfinders.Aimer:
        return _aimerViewfinderSettingsView.build(context);
    }
  }

  Future<void> _showViewfinderTypesPicker() async {
    var item = await showDialog<Viewfinders>(
        context: context,
        builder: (BuildContext context) {
          return _getCameraPositionDialog(context);
        });
    if (item != null) {
      setState(() {
        _bloc.currentViewfinder = item;
      });
    }
  }

  SimpleDialog _getCameraPositionDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Viewfinder Type"),
      children: _bloc.availableViewfinders
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
