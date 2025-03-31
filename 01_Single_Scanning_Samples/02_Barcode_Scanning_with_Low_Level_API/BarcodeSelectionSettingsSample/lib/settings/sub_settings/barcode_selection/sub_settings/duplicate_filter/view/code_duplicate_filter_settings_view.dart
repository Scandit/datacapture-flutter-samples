/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/barcode_selection/sub_settings/duplicate_filter/bloc/code_duplicate_filter_settings_bloc.dart';
import 'package:flutter/material.dart';

class CodeDuplicateFilterSettingsView extends StatefulWidget {
  final String title;

  CodeDuplicateFilterSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CodeDuplicateFilterSettingsViewState(CodeDuplicateFilterSettingsBloc());
  }
}

class _CodeDuplicateFilterSettingsViewState extends BaseState<CodeDuplicateFilterSettingsView>
    with WidgetsBindingObserver {
  final CodeDuplicateFilterSettingsBloc _bloc;
  late TextEditingController _valueEditingController;

  _CodeDuplicateFilterSettingsViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    _valueEditingController = TextEditingController(text: _bloc.codeDuplicateFilter.toString());
    _valueEditingController.addListener(() {
      var newValue = double.tryParse(_valueEditingController.text);
      if (newValue != null) {
        _bloc.codeDuplicateFilter = newValue;
      }
    });
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
          child: getCard(
            4.0,
            <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                title: Text('Code Duplicate Filter (s)'),
                dense: false,
                trailing: SizedBox(
                  width: 100,
                  height: 60,
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                    controller: _valueEditingController,
                    autofocus: true,
                  ),
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
    _valueEditingController.dispose();
    _bloc.dispose();
    super.dispose();
  }
}
