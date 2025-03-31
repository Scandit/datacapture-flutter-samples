/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/model/setting_item.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/bloc/view_settings_bloc.dart';
import 'package:flutter/material.dart';

class ViewSettingsView extends StatefulWidget {
  final String title;

  ViewSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewSettingsViewState(ViewSettingsBloc());
  }
}

class _ViewSettingsViewState extends BaseState<ViewSettingsView> with WidgetsBindingObserver {
  final ViewSettingsBloc _bloc;

  _ViewSettingsViewState(this._bloc);

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
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: Text(
                        _bloc.settings[index].title,
                      ),
                      onTap: () {
                        _onClick(context, _bloc.settings[index]);
                      },
                    )),
                itemCount: _bloc.settings.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onClick(BuildContext context, SettingItem item) async {
    await Navigator.pushNamed(context, item.navigationRoute);
  }
}
