/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/base/base_state.dart';
import 'package:BarcodeSelectionSettingsSample/common/extensions.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/double_with_unit/bloc/double_with_unit_bloc.dart';
import 'package:BarcodeSelectionSettingsSample/settings/common/double_with_unit/model/measure_unit_item.dart';
import 'package:flutter/material.dart';

class DoubleWithUnitView extends StatefulWidget {
  final DoubleWithUnitBloc bloc;

  DoubleWithUnitView(this.bloc, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DoubleWithUnitViewState(bloc);
  }
}

class _DoubleWithUnitViewState extends BaseState<DoubleWithUnitView> with WidgetsBindingObserver {
  final DoubleWithUnitBloc _bloc;
  late TextEditingController _valueEditingController;

  _DoubleWithUnitViewState(this._bloc);

  @override
  void initState() {
    super.initState();

    _valueEditingController = TextEditingController(text: _bloc.value.toStringAsFixed(2));
    _valueEditingController.addListener(() {
      var newValue = double.tryParse(_valueEditingController.text);
      if (newValue != null) {
        _bloc.value = newValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(_bloc.title),
          onDoubleTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              getCard(
                4.0,
                <Widget>[
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(12.0, 0, 4.0, 0),
                    title: Text('Value'),
                    dense: false,
                    trailing: SizedBox(
                      width: 100,
                      height: 60,
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        controller: _valueEditingController,
                        autofocus: true,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
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
                  itemCount: _bloc.availableMeasureUnits.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _getSymbologyListItem(_bloc.availableMeasureUnits.elementAt(index));
                  },
                ),
              ),
            ]),
      ),
    );
  }

  Widget _getSymbologyListItem(MeasureUnitItem item) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: ListTile(
        title: Text(
          item.measureUnit.name,
        ),
        trailing: Icon(item.isSelected ? Icons.check : null),
        onTap: () {
          setState(() {
            _bloc.measureUnit = item.measureUnit;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
