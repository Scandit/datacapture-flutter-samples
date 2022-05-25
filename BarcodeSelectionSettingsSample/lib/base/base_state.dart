import 'package:BarcodeSelectionSettingsSample/settings/common/model/picker_item.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  Widget getCard(double topMargin, List<Widget> children) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.fromLTRB(0, topMargin, 4.0, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: Column(children: children),
    );
  }

  Future<void> showPicker(BuildContext context, String title, List<PickerItem> items, PickerItemCallback fn) async {
    var newItem = await showDialog<PickerItem>(
        context: context,
        builder: (BuildContext context) {
          return _getDialog(context, title, items);
        });
    if (newItem != null) {
      fn(newItem);
    }
  }

  SimpleDialog _getDialog(BuildContext context, String title, List<PickerItem> items) {
    return SimpleDialog(
      title: Text(title),
      children: items
          .map((position) => SimpleDialogOption(
                padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 12.0),
                child: Row(
                  children: [
                    Icon(position.isSelected ? Icons.radio_button_on : Icons.radio_button_off),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(position.name),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.pop(context, position);
                },
              ))
          .toList(),
    );
  }
}
