/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/logo/bloc/logo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class LogoSettingsView extends StatefulWidget {
  final String title;

  LogoSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogoSettingsViewState(LogoBloc());
  }
}

class _LogoSettingsViewState extends State<LogoSettingsView> with WidgetsBindingObserver {
  final LogoBloc _bloc;
  late String _offsetXText, _offsetYText;

  _LogoSettingsViewState(this._bloc);

  @override
  Widget build(BuildContext context) {
    _offsetXText = _bloc.offsetXDisplayText;
    _offsetYText = _bloc.offsetYDisplayText;

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
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                title: Text("Anchor"),
                subtitle: Text(_bloc.currentAnchor.name),
                dense: false,
                onTap: () => _showAnchorPicker(context),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.blue,
                ),
              ),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("X"),
                    dense: false,
                    onTap: () => {
                      Navigator.push(
                              context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(LogoOffsetXBloc())))
                          .then((value) => setState(() {
                                _offsetXText = _bloc.offsetXDisplayText;
                              }))
                    },
                    trailing: Text(_offsetXText),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("Y"),
                    dense: false,
                    onTap: () => {
                      Navigator.push(
                              context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(LogoOffsetYBloc())))
                          .then((value) => setState(() {
                                _offsetYText = _bloc.offsetYDisplayText;
                              }))
                    },
                    trailing: Text(_offsetYText),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAnchorPicker(BuildContext context) async {
    var selectedItem = await showDialog<Anchor>(
        context: context,
        builder: (BuildContext context) {
          return _getStylePickerDialog(context);
        });
    if (selectedItem != null) {
      this.setState.call(() {
        _bloc.currentAnchor = selectedItem;
      });
    }
  }

  SimpleDialog _getStylePickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Anchor"),
      children: _bloc.availableAnchors
          .map((item) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(item.name),
                onPressed: () {
                  Navigator.pop(context, item);
                },
              ))
          .toList(),
    );
  }
}
