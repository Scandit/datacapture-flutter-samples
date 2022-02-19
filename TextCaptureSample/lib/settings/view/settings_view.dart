/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:TextCaptureSample/settings/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  final String title;

  SettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsViewState(SettingsBloc());
  }
}

class _SettingsViewState extends State<SettingsView> with WidgetsBindingObserver {
  final SettingsBloc _bloc;

  _SettingsViewState(this._bloc);

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
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Mode'),
              ),
              width: double.infinity,
              color: Colors.black12,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: Text(
                        _bloc.modes[index].displayName,
                      ),
                      trailing: Icon(_bloc.modes[index].mode == _bloc.currentMode.mode ? Icons.check : null),
                      onTap: () {
                        setState(() {
                          _bloc.currentMode = _bloc.modes[index];
                        });
                      },
                    )),
                itemCount: _bloc.modes.length,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Scan Position'),
              ),
              width: double.infinity,
              color: Colors.black12,
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.all(1.0),
                    child: ListTile(
                      title: Text(
                        _bloc.scanPositions[index].displayName,
                      ),
                      trailing: Icon(_bloc.scanPositions[index].position == _bloc.currentScanPosition.position
                          ? Icons.check
                          : null),
                      onTap: () {
                        setState(() {
                          _bloc.currentScanPosition = _bloc.scanPositions[index];
                        });
                      },
                    )),
                itemCount: _bloc.scanPositions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
