/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/bloc/location_selection_settings_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/barcode/location_selection/model/location_selection_item.dart';
import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class LocationSelectionSettingsView extends StatefulWidget {
  final String title;

  LocationSelectionSettingsView(this.title, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LocationSelectionSettingsViewState(LocationSelectionSettingsBloc());
  }
}

class _LocationSelectionSettingsViewState extends State<LocationSelectionSettingsView> with WidgetsBindingObserver {
  final LocationSelectionSettingsBloc _bloc;
  late TextEditingController _heightAspectEditingController;
  late TextEditingController _widthAspectEditingController;

  _LocationSelectionSettingsViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    _heightAspectEditingController =
        TextEditingController(text: _bloc.rectangularLocationSelectionHeightAspect.toStringAsFixed(2));
    _heightAspectEditingController.addListener(() {
      var newValue = double.tryParse(_heightAspectEditingController.text);
      if (newValue != null) _bloc.rectangularLocationSelectionHeightAspect = newValue;
    });

    _widthAspectEditingController =
        TextEditingController(text: _bloc.rectangularLocationSelectionWidthAspect.toStringAsFixed(2));
    _widthAspectEditingController.addListener(() {
      var newValue = double.tryParse(_widthAspectEditingController.text);
      if (newValue != null) _bloc.rectangularLocationSelectionWidthAspect = newValue;
    });
  }

  @override
  void dispose() {
    _bloc.updateLocationSelection();
    _heightAspectEditingController.dispose();
    _widthAspectEditingController.dispose();
    _bloc.dispose();
    super.dispose();
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
          children: <Widget>[
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                  title: Text("Type"),
                  subtitle: Text(_bloc.currentLocationSelection.name),
                  dense: false,
                  onTap: () => _showLocationSelectionPicker(),
                  trailing: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.blue,
                  ),
                ),
              ]),
            ),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.fromLTRB(0, 4.0, 4.0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              child: Column(
                children: _getSelectedLocationSelectionTypeView(),
              ),
            )
          ],
        )));
  }

  List<Widget> _getSelectedLocationSelectionTypeView() {
    switch (_bloc.currentLocationSelection) {
      case LocationSelectionType.radius:
        return [_getRadiusLocationConfigViews()];
      case LocationSelectionType.rectangular:
        return [_getRectangularLocationConfigViews()];
      default:
        return [];
    }
  }

  Widget _getRadiusLocationConfigViews() {
    var sizeText = _bloc.radiusLocationSizeDisplayValue;

    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        title: Text(
          'Size',
        ),
        trailing: Text(sizeText),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(_bloc.radiusSizeBloc)))
              .then((value) => {
                    setState(() {
                      sizeText = _bloc.radiusLocationSizeDisplayValue;
                    })
                  });
        },
      ),
    );
  }

  Widget _getRectangularLocationConfigViews() {
    return Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Size Specification"),
        subtitle: Text(_bloc.rectangularLocationSelectionSizeMode.name),
        dense: false,
        onTap: () => _showSizeSpecificationPicker(),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      )
    ])
      ..children.addAll(_getRectangularSizeModeViews());
  }

  Future<void> _showSizeSpecificationPicker() async {
    var selectedItem = await showDialog<SizingMode>(
        context: context,
        builder: (BuildContext context) {
          return _getSizeSpecificationDialog(context);
        });
    if (selectedItem != null) {
      setState(() {
        _bloc.rectangularLocationSelectionSizeMode = selectedItem;
      });
    }
  }

  SimpleDialog _getSizeSpecificationDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Size Specification"),
      children: _bloc.availableRectangularLocationSelectionSizingModes
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

  List<Widget> _getRectangularSizeModeViews() {
    switch (_bloc.rectangularLocationSelectionSizeMode) {
      case SizingMode.widthAndHeight:
        return _getRectangularWithAndHeightSizingModeView();
      case SizingMode.widthAndAspectRatio:
        return _getRectangularWithAndAspectSizingModeView();
      case SizingMode.heightAndAspectRatio:
        return _getRectangularHeightAndAspectSizingModeViews();
      default:
        return [];
    }
  }

  List<Widget> _getRectangularWithAndHeightSizingModeView() {
    var widthText = _bloc.rectangularLocationSelectionWidthDisplayValue;
    var heightText = _bloc.rectangularLocationSelectionHeightDisplayValue;
    return [
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          title: Text(
            'Width',
          ),
          trailing: Text(widthText),
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(_bloc.rectangularWidthBloc)))
                .then((value) => {
                      setState(() {
                        widthText = _bloc.rectangularLocationSelectionWidthDisplayValue;
                      })
                    });
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          title: Text(
            'Height',
          ),
          trailing: Text(heightText),
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(_bloc.rectangularHeightBloc)))
                .then((value) => {
                      setState(() {
                        heightText = _bloc.rectangularLocationSelectionHeightDisplayValue;
                      })
                    });
          },
        ),
      )
    ];
  }

  List<Widget> _getRectangularWithAndAspectSizingModeView() {
    var widthText = _bloc.rectangularLocationSelectionWidthDisplayValue;

    return [
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          title: Text(
            'Width',
          ),
          trailing: Text(widthText),
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(_bloc.rectangularWidthBloc)))
                .then((value) => {
                      setState(() {
                        widthText = _bloc.rectangularLocationSelectionWidthDisplayValue;
                      })
                    });
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0, 12.0, 0),
          title: Text('Height Aspect'),
          dense: false,
          trailing: SizedBox(
            width: 70,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _heightAspectEditingController,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _getRectangularHeightAndAspectSizingModeViews() {
    var heightText = _bloc.rectangularLocationSelectionHeightDisplayValue;

    return [
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          title: Text(
            'Height',
          ),
          trailing: Text(heightText),
          onTap: () {
            Navigator.push(
                    context, MaterialPageRoute(builder: (context) => DoubleWithUnitView(_bloc.rectangularWidthBloc)))
                .then((value) => {
                      setState(() {
                        heightText = _bloc.rectangularLocationSelectionHeightDisplayValue;
                      })
                    });
          },
        ),
      ),
      Padding(
        padding: EdgeInsets.all(0.0),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16.0, 0, 12.0, 0),
          title: Text('Width Aspect'),
          dense: false,
          trailing: SizedBox(
            width: 70,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _widthAspectEditingController,
              textAlign: TextAlign.right,
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> _showLocationSelectionPicker() async {
    var selectedItem = await showDialog<LocationSelectionType>(
        context: context,
        builder: (BuildContext context) {
          return _getLocationSelectionDialog(context);
        });
    if (selectedItem != null) {
      setState(() {
        _bloc.currentLocationSelection = selectedItem;
      });
    }
  }

  SimpleDialog _getLocationSelectionDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Type"),
      children: _bloc.availableLocationSelections
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
