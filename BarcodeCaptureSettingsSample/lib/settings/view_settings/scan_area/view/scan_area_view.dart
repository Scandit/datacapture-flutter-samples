/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/scan_area/bloc/scan_area_bloc.dart';
import 'package:flutter/material.dart';

class ScanAreaSettingsView extends StatefulWidget {
  final String title;

  ScanAreaSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScanAreaSettingsViewState(ScanAreaSettingsBloc());
  }
}

class _ScanAreaSettingsViewState extends State<ScanAreaSettingsView> with WidgetsBindingObserver {
  final ScanAreaSettingsBloc _bloc;
  late String topMargin;
  late String bottomMargin;
  late String rightMargin;
  late String leftMargin;

  _ScanAreaSettingsViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    topMargin = _bloc.topMarginDisplayText;
    bottomMargin = _bloc.bottomMarginDisplayText;
    rightMargin = _bloc.rightMarginDisplayText;
    leftMargin = _bloc.leftMarginDisplayText;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 4.0, 0),
              child: Text('Margins'),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Top"),
                  dense: false,
                  onTap: () => {
                    Navigator.push(
                            context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(ScanAreaTopMargin())))
                        .then((value) => setState(() {
                              topMargin = _bloc.topMarginDisplayText;
                            }))
                  },
                  trailing: Text(topMargin),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Right"),
                  dense: false,
                  onTap: () => {
                    Navigator.push(
                            context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(ScanAreaRightMargin())))
                        .then((value) => setState(() {
                              rightMargin = _bloc.rightMarginDisplayText;
                            }))
                  },
                  trailing: Text(rightMargin),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Bottom"),
                  dense: false,
                  onTap: () => {
                    Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DoubleWithUnitView(ScanAreaBottomMargin())))
                        .then((value) => setState(() {
                              bottomMargin = _bloc.bottomMarginDisplayText;
                            }))
                  },
                  trailing: Text(bottomMargin),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Left"),
                  dense: false,
                  onTap: () => {
                    Navigator.push(
                            context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(ScanAreaLeftMargin())))
                        .then((value) => setState(() {
                              leftMargin = _bloc.leftMarginDisplayText;
                            }))
                  },
                  trailing: Text(leftMargin),
                ),
              ]),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
                SwitchListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  value: _bloc.shouldShowScanAreaGuides,
                  title: Text("Should Show Scan Area Guides"),
                  onChanged: (value) {
                    setState(() {
                      _bloc.shouldShowScanAreaGuides = value;
                    });
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
