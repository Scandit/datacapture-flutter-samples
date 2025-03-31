/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

typedef PickerItemCallback = void Function(PickerItem newColorItem);

class PickerItem<T> {
  final T value;
  final String name;
  final bool isSelected;

  PickerItem(this.name, this.value, this.isSelected);
}
