/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/bloc/main_settings_bloc.dart';
import 'package:BarcodeSelectionSettingsSample/settings/model/setting_item.dart';
import 'package:flutter/material.dart';

class MainSettingsView extends StatefulWidget {
  final String title;

  MainSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainSettingsViewState(MainSettingsBloc());
  }
}

class _MainSettingsViewState extends BaseState<MainSettingsView> with WidgetsBindingObserver {
  final MainSettingsBloc _bloc;

  _MainSettingsViewState(this._bloc);

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.all(1.0),
                      child: ListTile(
                        title: Text(
                          _bloc.settingsItems[index].title,
                        ),
                        onTap: () {
                          _onClick(context, _bloc.settingsItems[index]);
                        },
                      )),
                  itemCount: _bloc.settingsItems.length,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Card(
                child: ListTile(
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        child: Text(
                          'Reset Barcode Selection Session',
                          textAlign: TextAlign.start,
                        ),
                        onPressed: () =>
                            {_bloc.resetBarcodeSelectionSession().onError((error, stackTrace) => print(error))}),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                'Plugin Version: ${_bloc.pluginVersion}',
                style: TextStyle(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onClick(BuildContext context, SettingItem item) async {
    await Navigator.pushNamed(context, item.navigationRoute);
  }
}
