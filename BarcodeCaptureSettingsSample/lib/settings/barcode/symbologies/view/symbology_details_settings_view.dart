/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/barcode/symbologies/bloc/symbology_details_settings_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/symbologies/model/extension_item.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';

class SymbologyDetailsSettingsView extends StatefulWidget {
  final Symbology symbology;

  SymbologyDetailsSettingsView({Key? key, required this.symbology}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SymbologyDetailsSettingsViewState(SymbologyDetailsSettingsBloc(symbology));
  }
}

class _SymbologyDetailsSettingsViewState extends State<SymbologyDetailsSettingsView> with WidgetsBindingObserver {
  final SymbologyDetailsSettingsBloc _bloc;

  _SymbologyDetailsSettingsViewState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            child: Text(_bloc.title),
            onDoubleTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
                SwitchListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  value: _bloc.isEnabled,
                  title: Text("Enabled"),
                  subtitle: Text(
                    _bloc.isEnabled ? "ON" : "OFF",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _bloc.isEnabled = value;
                    });
                  },
                ),
              ]),
            ),
            Visibility(
              visible: _bloc.colorInvertedSettingsAvailable,
              child: Card(
                elevation: 4.0,
                margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: Column(children: <Widget>[
                  SwitchListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                    value: _bloc.isColorInvertedEnabled,
                    title: Text("Color Inverted"),
                    subtitle: Text(
                      _bloc.isColorInvertedEnabled ? "ON" : "OFF",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _bloc.isColorInvertedEnabled = value;
                      });
                    },
                  ),
                ]),
              ),
            ),
            Visibility(
              visible: _bloc.isRangeSettingsAvailable,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 10, 12.0, 0),
                    child: Text(
                      "Range",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("Minimum"),
                    subtitle: Text(_bloc.minimumSymbolCount.toString()),
                    dense: false,
                    onTap: () => _showMinRangeSelectorPicker(),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("Maximum"),
                    subtitle: Text(_bloc.maximumSymbolCount.toString()),
                    dense: false,
                    onTap: () => _showMaxRangeSelectorPicker(),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _bloc.colorInvertedSettingsAvailable,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 10, 12.0, 0),
                child: Text(
                  "Extensions",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Visibility(
                visible: _bloc.colorInvertedSettingsAvailable,
                child: Expanded(
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
                      itemCount: _bloc.extensions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _getExtensionItem(_bloc.extensions.elementAt(index));
                      }),
                )),
          ],
        )));
  }

  Future<void> _showMinRangeSelectorPicker() async {
    var selectedItem = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return _getMinRangeSelectorDialog(context);
        });
    if (selectedItem != null) {
      setState(() {
        _bloc.minimumSymbolCount = selectedItem;
      });
    }
  }

  SimpleDialog _getMinRangeSelectorDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Minimum Range"),
      children: _bloc.availableMinRanges
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.toString()),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }

  Future<void> _showMaxRangeSelectorPicker() async {
    var selectedItem = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return _getMaxRangeSelectorDialog(context);
        });
    if (selectedItem != null) {
      setState(() {
        _bloc.maximumSymbolCount = selectedItem;
      });
    }
  }

  SimpleDialog _getMaxRangeSelectorDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Maximum Range"),
      children: _bloc.availableMaxRanges
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.toString()),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }

  Widget _getExtensionItem(ExtensionItem item) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        title: Text(
          item.name,
        ),
        trailing: Icon(item.enabled ? Icons.check : null),
        onTap: () {
          setState(() {
            _bloc.setExtensionEnabled(item.name, !item.enabled);
          });
        },
      ),
    );
  }
}
