/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';

typedef void FreezeCallback(bool isFrozen);

class FreezeButton extends StatefulWidget {
  final FreezeCallback onPressed;

  const FreezeButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _FreezeButtonState createState() => _FreezeButtonState();
}

class _FreezeButtonState extends State<FreezeButton> {
  final AssetImage _freezeButtonAsset = AssetImage("assets/images/freeze_enabled.png");
  final AssetImage _unfreezeButtonAsset = AssetImage("assets/images/freeze_disabled.png");

  late AssetImage _buttonAsset;
  var _capturingFrozen = false;

  @override
  void initState() {
    super.initState();
    _buttonAsset = _freezeButtonAsset;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        width: 120,
        child: TextButton(
          onPressed: () => _onPressed(context),
          child: Image(image: _buttonAsset),
          style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
        ));
  }

  _onPressed(BuildContext context) {
    setState(() {
      _capturingFrozen = !_capturingFrozen;
      _buttonAsset = _capturingFrozen ? _unfreezeButtonAsset : _freezeButtonAsset;
      widget.onPressed(_capturingFrozen);
    });
  }
}
