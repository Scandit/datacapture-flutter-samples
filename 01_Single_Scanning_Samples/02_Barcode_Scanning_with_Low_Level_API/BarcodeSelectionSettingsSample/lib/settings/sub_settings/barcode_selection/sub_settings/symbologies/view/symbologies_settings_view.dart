/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/bloc/symbologies_settings_bloc.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/model/symbology_item.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/symbologies/view/symbology_details_settings_view.dart';
import 'package:flutter/material.dart';

class SymbologiesSettingsView extends StatefulWidget {
  final String title;

  SymbologiesSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SymbologiesSettingsViewState(SymbologiesSettingsBloc());
  }
}

class _SymbologiesSettingsViewState extends BaseState<SymbologiesSettingsView> with WidgetsBindingObserver {
  final SymbologiesSettingsBloc _bloc;
  late Iterable<SymbologyItem> _symbologies;

  _SymbologiesSettingsViewState(this._bloc);

  @override
  Widget build(BuildContext context) {
    _symbologies = _bloc.symbologies;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(widget.title),
          onDoubleTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
              ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          _bloc.enableAll();
                        })
                      },
                  child: Text("Enable All")),
              ElevatedButton(
                  onPressed: () => {
                        setState(() {
                          _bloc.disableAll();
                        })
                      },
                  child: Text("Disable All"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  )),
            ]),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 0.0,
                      right: 0.0,
                    ),
                    child: Divider(
                      color: Colors.grey.shade400,
                    ),
                  );
                },
                itemCount: _symbologies.length,
                itemBuilder: (BuildContext context, int index) {
                  return _getSymbologyListItem(_symbologies.elementAt(index));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getSymbologyListItem(SymbologyItem item) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        title: Text(
          item.name,
        ),
        trailing: Text(item.isEnabled ? "ON" : "OFF"),
        onTap: () {
          _openSymbologyDetails(context, item);
        },
      ),
    );
  }

  void _openSymbologyDetails(BuildContext context, SymbologyItem item) async {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => SymbologyDetailsSettingsView(symbology: item.symbology)))
        .then((value) => {
              this.setState(() {
                _symbologies = _bloc.symbologies;
              })
            });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
