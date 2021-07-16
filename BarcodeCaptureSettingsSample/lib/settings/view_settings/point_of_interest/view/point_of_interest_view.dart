/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/point_of_interest/bloc/point_of_interest_bloc.dart';
import 'package:flutter/material.dart';

class PointOfInterestSettingsView extends StatefulWidget {
  final String title;

  PointOfInterestSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PointOfInterestSettingsViewState(PointOfInterestBloc());
  }
}

class _PointOfInterestSettingsViewState extends State<PointOfInterestSettingsView> with WidgetsBindingObserver {
  final PointOfInterestBloc _bloc;
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
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
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
            ),
          ],
        ),
      ),
    );
  }
}
