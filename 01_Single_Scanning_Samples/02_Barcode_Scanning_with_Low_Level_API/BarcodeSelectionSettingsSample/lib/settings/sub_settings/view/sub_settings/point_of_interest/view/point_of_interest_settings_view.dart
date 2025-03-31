/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/view/sub_settings/point_of_interest/bloc/point_of_interest_settings_bloc.dart';
import 'package:flutter/material.dart';

class PointOfInterestSettingsView extends StatefulWidget {
  final String title;

  PointOfInterestSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PointOfInterestSettingsViewState(PointOfInterestSettingsBloc());
  }
}

class _PointOfInterestSettingsViewState extends BaseState<PointOfInterestSettingsView> with WidgetsBindingObserver {
  final PointOfInterestSettingsBloc _bloc;
  late String pointX;
  late String pointY;

  _PointOfInterestSettingsViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    pointX = _bloc.pointXDisplayText;
    pointY = _bloc.pointYDisplayText;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getCard(20.0, <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                title: Text("X"),
                dense: false,
                onTap: () => {
                  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(PointOfInterestX())))
                      .then((value) => setState(() {
                            pointX = _bloc.pointXDisplayText;
                          }))
                },
                trailing: Text(pointX),
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                title: Text("Y"),
                dense: false,
                onTap: () => {
                  Navigator.push(
                          context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(PointOfInterestY())))
                      .then((value) => setState(() {
                            pointY = _bloc.pointYDisplayText;
                          }))
                },
                trailing: Text(pointY),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
