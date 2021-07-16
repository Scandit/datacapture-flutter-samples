/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureSettingsSample/settings/double_with_unit/view/double_with_unit_view.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/bloc/rectangular_viewfinder_bloc.dart';
import 'package:BarcodeCaptureSettingsSample/settings/view_settings/viewfinders/model/color_item.dart';
import 'package:flutter/material.dart';
import 'package:BarcodeCaptureSettingsSample/settings/common/common_settings.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class RectangularViewfinderSettingsView {
  final RectangularViewfinderBloc _bloc;
  final Function _setState;
  late String widthText;
  late String heigthText;
  late TextEditingController _dimmingValueController = _getDimmingValueController();
  late TextEditingController _heightAspectValueController = _getHeightAspectValueController();
  late TextEditingController _widthAspectValueController = _getWidthAspectValueController();
  late TextEditingController _shorterDimensionValueController = _getShorterDimensionValueController();
  late TextEditingController _longerDimensionAspectValueController = _getLongerDimensionAspectValueController();

  RectangularViewfinderSettingsView(this._setState, this._bloc);

  List<Widget> build(BuildContext context) {
    widthText = _bloc.widthDisplayText;
    heigthText = _bloc.heigthDisplayText;
    return [
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Style"),
        subtitle: Text(_bloc.currentStyle.name),
        dense: false,
        onTap: () => _showStylePicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Line Style"),
        subtitle: Text(_bloc.currentLineStyle.name),
        dense: false,
        onTap: () => _showLineStylePicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Dimming (0.0 - 1.0)"),
        dense: false,
        trailing: SizedBox(
          width: 100,
          height: 60,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _dimmingValueController,
          ),
        ),
      ),
      ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
        title: Text("Color"),
        subtitle: Text(_bloc.currentColor.name),
        dense: false,
        onTap: () => _showColorPicker(context),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.blue,
        ),
      ),
      SwitchListTile(
        contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
        value: _bloc.isAnimationEnabled,
        title: Text("Animation"),
        subtitle: Text(
          _bloc.isAnimationEnabled ? "On" : "Off",
        ),
        onChanged: (value) {
          _setState(() {
            _bloc.isAnimationEnabled = value;
          });
        },
      ),
      Visibility(
        visible: _bloc.isAnimationEnabled,
        child: SwitchListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
          value: _bloc.isLooping,
          title: Text("Looping"),
          subtitle: Text(
            _bloc.isLooping ? "On" : "Off",
          ),
          onChanged: (value) {
            _setState(() {
              _bloc.isLooping = value;
            });
          },
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
            title: Text("Size Specification"),
            subtitle: Text(_bloc.currentSizingMode.name),
            dense: false,
            onTap: () => _showSizingModePicker(context),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue,
            ),
          ),
          _getSizeSpecificationConfigView(context)
        ],
      )
    ];
  }

  void dispose() {
    _dimmingValueController.dispose();
    _heightAspectValueController.dispose();
    _widthAspectValueController.dispose();
    _shorterDimensionValueController.dispose();
    _longerDimensionAspectValueController.dispose();
    _bloc.dispose();
  }

  Widget _getSizeSpecificationConfigView(BuildContext context) {
    switch (_bloc.currentSizingMode) {
      case SizingMode.widthAndHeight:
        return _getWidthAndHeightConfigView(context);
      case SizingMode.widthAndAspectRatio:
        return _getWidthAndHeightAspectConfigView(context);
      case SizingMode.heightAndAspectRatio:
        return _getHeightAndWidthAspectConfigView(context);
      case SizingMode.shorterDimensionAndAspectRatio:
        return _getShorterDimensionConfigView();
    }
  }

  Widget _getWidthAndHeightConfigView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Width"),
          dense: false,
          onTap: () => {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DoubleWithUnitView(RectangularViewfinderWidthBloc())))
                .then((value) => _setState(() {
                      widthText = _bloc.widthDisplayText;
                    }))
          },
          trailing: Text(widthText),
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Height"),
          dense: false,
          onTap: () => {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DoubleWithUnitView(RectangularViewfinderHeightBloc())))
                .then((value) => _setState(() {
                      heigthText = _bloc.heigthDisplayText;
                    }))
          },
          trailing: Text(heigthText),
        ),
      ],
    );
  }

  Widget _getWidthAndHeightAspectConfigView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Width"),
          dense: false,
          onTap: () => {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DoubleWithUnitView(RectangularViewfinderWidthBloc())))
                .then((value) => _setState(() {
                      widthText = _bloc.widthDisplayText;
                    }))
          },
          trailing: Text(widthText),
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Height Aspect"),
          dense: false,
          trailing: SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _heightAspectValueController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getHeightAndWidthAspectConfigView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Height"),
          dense: false,
          onTap: () => {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DoubleWithUnitView(RectangularViewfinderHeightBloc())))
                .then((value) => _setState(() {
                      heigthText = _bloc.heigthDisplayText;
                    }))
          },
          trailing: Text(heigthText),
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Width Aspect"),
          dense: false,
          trailing: SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _widthAspectValueController,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getShorterDimensionConfigView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Shorter Dimension (Fraction)"),
          dense: false,
          trailing: SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _shorterDimensionValueController,
            ),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
          title: Text("Longer Dimension Aspect"),
          dense: false,
          trailing: SizedBox(
            width: 100,
            height: 60,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _longerDimensionAspectValueController,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showStylePicker(BuildContext context) async {
    var selectedItem = await showDialog<RectangularViewfinderStyle>(
        context: context,
        builder: (BuildContext context) {
          return _getStylePickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentStyle = selectedItem;
      });
    }
  }

  SimpleDialog _getStylePickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Style"),
      children: _bloc.availableStyles
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

  Future<void> _showLineStylePicker(BuildContext context) async {
    var selectedItem = await showDialog<RectangularViewfinderLineStyle>(
        context: context,
        builder: (BuildContext context) {
          return _getLineStylePickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentLineStyle = selectedItem;
      });
    }
  }

  SimpleDialog _getLineStylePickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Line Style"),
      children: _bloc.availableLineStyles
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

  Future<void> _showColorPicker(BuildContext context) async {
    var selectedItem = await showDialog<ColorItem>(
        context: context,
        builder: (BuildContext context) {
          return _getColorPickerDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentColor = selectedItem;
      });
    }
  }

  SimpleDialog _getColorPickerDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Color"),
      children: _bloc.availableColors
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

  Future<void> _showSizingModePicker(BuildContext context) async {
    var selectedItem = await showDialog<SizingMode>(
        context: context,
        builder: (BuildContext context) {
          return _getSizingModeDialog(context);
        });
    if (selectedItem != null) {
      this._setState.call(() {
        _bloc.currentSizingMode = selectedItem;
      });
    }
  }

  SimpleDialog _getSizingModeDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text("Size Specification"),
      children: _bloc.availableSizingModes
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

  TextEditingController _getDimmingValueController() {
    var controller = TextEditingController(text: _bloc.dimming.toStringAsFixed(2));
    controller.addListener(() {
      var newValue = double.tryParse(controller.text);
      if (newValue != null) {
        _bloc.dimming = newValue;
      }
    });
    return controller;
  }

  TextEditingController _getShorterDimensionValueController() {
    var controller = TextEditingController(text: _bloc.shorterDimension.toStringAsFixed(2));
    controller.addListener(() {
      var newValue = double.tryParse(controller.text);
      if (newValue != null) {
        _bloc.shorterDimension = newValue;
      }
    });
    return controller;
  }

  TextEditingController _getHeightAspectValueController() {
    var controller = TextEditingController(text: _bloc.heightAspect.toStringAsFixed(2));
    controller.addListener(() {
      var newValue = double.tryParse(controller.text);
      if (newValue != null) {
        _bloc.heightAspect = newValue;
      }
    });
    return controller;
  }

  TextEditingController _getWidthAspectValueController() {
    var controller = TextEditingController(text: _bloc.widthAspect.toStringAsFixed(2));
    controller.addListener(() {
      var newValue = double.tryParse(controller.text);
      if (newValue != null) {
        _bloc.widthAspect = newValue;
      }
    });
    return controller;
  }

  TextEditingController _getLongerDimensionAspectValueController() {
    var controller = TextEditingController(text: _bloc.longerDimensionAspect.toStringAsFixed(2));
    controller.addListener(() {
      var newValue = double.tryParse(controller.text);
      if (newValue != null) {
        _bloc.longerDimensionAspect = newValue;
      }
    });
    return controller;
  }
}
