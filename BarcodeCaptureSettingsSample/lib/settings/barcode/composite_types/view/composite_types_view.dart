/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/barcode/composite_types/bloc/composite_types_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/composite_types/model/composite_type_item.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:flutter/material.dart';

class CompositeTypesSettingsView extends StatefulWidget {
  final String title;

  CompositeTypesSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CompositeTypesSettingsViewState(CompositeTypesBloc());
  }
}

class _CompositeTypesSettingsViewState extends State<CompositeTypesSettingsView> with WidgetsBindingObserver {
  final CompositeTypesBloc _bloc;

  _CompositeTypesSettingsViewState(this._bloc);

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
          itemCount: _bloc.compositeTypes.length,
          itemBuilder: (BuildContext context, int index) {
            return _getCompositeTypeListItem(_bloc.compositeTypes.elementAt(index));
          },
        ),
      )),
    );
  }

  Widget _getCompositeTypeListItem(CompositeTypeItem item) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        title: Text(
          item.compositeType.name,
        ),
        trailing: Icon(item.isEnabled ? Icons.check : null),
        onTap: () {
          setState(() {
            _bloc.toggleCompositeType(item);
          });
        },
      ),
    );
  }
}
