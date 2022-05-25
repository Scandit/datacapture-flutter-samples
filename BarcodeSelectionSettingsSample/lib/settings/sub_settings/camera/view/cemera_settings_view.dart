/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/settings/sub_settings/camera/bloc/camera_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class CameraSettingsView extends StatefulWidget {
  final String title;

  CameraSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CameraSettingsViewState(CameraSettingsBloc());
  }
}

class _CameraSettingsViewState extends BaseState<CameraSettingsView> with WidgetsBindingObserver {
  final CameraSettingsBloc _bloc;
  late String? _cameraPosition;

  _CameraSettingsViewState(this._bloc) {
    _cameraPosition = _bloc.cameraPosition?.name;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getCard(4.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Camera Position"),
                  subtitle: Text(_cameraPosition ?? 'No Camera'),
                  dense: false,
                  onTap: () => _showCameraPositionPicker(),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(20.0, <Widget>[
                SwitchListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  value: _bloc.isTorchOn,
                  title: Text("Desired Torch State"),
                  subtitle: Text(
                    _bloc.isTorchOn ? "On" : "Off",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _bloc.isTorchOn = value;
                    });
                  },
                ),
              ]),
              Padding(
                padding: EdgeInsets.fromLTRB(4, 40, 0, 0),
                child: Text("Camera Settings"),
              ),
              getCard(4.0, <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Preferred Resolution"),
                  subtitle: Text(_bloc.videoResolution.name),
                  dense: false,
                  onTap: () => _showCameraResolutionPicker(),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
              getCard(4.0, <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    new Text("Zoom Factor"),
                    new Text(_bloc.zoomFactor.toStringAsFixed(2)),
                  ]),
                ),
                Slider(
                  value: _bloc.zoomFactor,
                  min: 1,
                  max: 20,
                  divisions: 100,
                  onChanged: (double value) {
                    setState(() {
                      _bloc.zoomFactor = value;
                    });
                  },
                )
              ]),
              getCard(
                4.0,
                <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text("Focus Range"),
                    subtitle: Text(_bloc.focusRange.name),
                    dense: false,
                    onTap: () => _showFocusRangePickerPicker(),
                    trailing: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCameraPositionPicker() async {
    var newPosition = await showDialog<CameraPosition>(
        context: context,
        builder: (BuildContext context) {
          return _getCameraPositionDialog(context);
        });
    if (newPosition != null) {
      await _bloc.setCameraPosition(newPosition);
      setState(() {
        _cameraPosition = newPosition.name;
      });
    }
  }

  SimpleDialog _getCameraPositionDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Camera Position"),
      children: _bloc.availableCameraPositions
          .map((position) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(position.name),
                onPressed: () {
                  Navigator.pop(context, position);
                },
              ))
          .toList(),
    );
  }

  Future<void> _showCameraResolutionPicker() async {
    var newRes = await showDialog<VideoResolution>(
        context: context,
        builder: (BuildContext context) {
          return getCameraResolutionDialog(context);
        });
    if (newRes != null) {
      setState(() {
        _bloc.videoResolution = newRes;
      });
    }
  }

  SimpleDialog getCameraResolutionDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Resolution"),
      children: _bloc.availableVideoResolutions
          .map((res) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(res.name),
                onPressed: () {
                  Navigator.pop(context, res);
                },
              ))
          .toList(),
    );
  }

  Future<void> _showFocusRangePickerPicker() async {
    var newValue = await showDialog<FocusRange>(
        context: context,
        builder: (BuildContext context) {
          return getFocusRangeStrategyDialog(context);
        });
    if (newValue != null) {
      setState(() {
        _bloc.focusRange = newValue;
      });
    }
  }

  SimpleDialog getFocusRangeStrategyDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Focus Gesture Strategy"),
      children: _bloc.availableFocusRanges
          .map((res) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Text(res.name),
                onPressed: () {
                  Navigator.pop(context, res);
                },
              ))
          .toList(),
    );
  }
}
