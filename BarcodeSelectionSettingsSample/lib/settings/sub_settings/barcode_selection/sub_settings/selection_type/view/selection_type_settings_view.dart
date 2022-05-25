/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/bloc/selection_type_settings_bloc.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/model/aimer_selection_strategy.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/selection_type/model/selection_type.dart';
import 'package:flutter/material.dart';

class SelectionTypeSettingsView extends StatefulWidget {
  final String title;

  SelectionTypeSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectionTypeSettingsViewState(SelectionTypeSettingsBloc());
  }
}

class _SelectionTypeSettingsViewState extends BaseState<SelectionTypeSettingsView> with WidgetsBindingObserver {
  final SelectionTypeSettingsBloc _bloc;

  _SelectionTypeSettingsViewState(this._bloc);

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
                getCard(4.0, <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text('Selection Type'),
                    subtitle: Text(_bloc.selectionType.name),
                    dense: false,
                    onTap: () => showPicker(context, 'Selection Type', _bloc.availableSelectionTypes, (newItem) {
                      setState(() {
                        _bloc.selectionType = newItem.value;
                      });
                    }),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ),
                ]),
                Visibility(
                  child: getCard(25.0, <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                      title: Text('Freeze Behavior'),
                      subtitle: Text(_bloc.freezeBehavior.name),
                      dense: false,
                      onTap: () => showPicker(context, 'Freeze Behavior', _bloc.availableFreezeBehaviors, (newItem) {
                        setState(() {
                          _bloc.freezeBehavior = newItem.value;
                        });
                      }),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ),
                  ]),
                  visible: _bloc.isTapSelection,
                ),
                Visibility(
                  child: getCard(4.0, <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                      title: Text('Tap Behavior'),
                      subtitle: Text(_bloc.tapBehavior.name),
                      dense: false,
                      onTap: () => showPicker(context, 'Tap Behavior', _bloc.availableTapBehaviors, (newItem) {
                        setState(() {
                          _bloc.tapBehavior = newItem.value;
                        });
                      }),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ),
                  ]),
                  visible: _bloc.isTapSelection,
                ),
                Visibility(
                  child: getCard(25.0, <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                      title: Text('Selection Strategy'),
                      subtitle: Text(_bloc.selectionStrategy.name),
                      dense: false,
                      onTap: () =>
                          showPicker(context, 'Selection Strategy', _bloc.availableSelectionStrategies, (newItem) {
                        setState(() {
                          _bloc.selectionStrategy = newItem.value;
                        });
                      }),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                      ),
                    ),
                  ]),
                  visible: _bloc.isTapSelection == false,
                ),
              ]),
        ),
      ),
    );
  }
}
