/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:BarcodeCaptureViewsSample/home/bloc/home_bloc.dart';
import 'package:BarcodeCaptureViewsSample/home/model/home_section.dart';
import 'package:flutter/material.dart';

import 'package:BarcodeCaptureViewsSample/route/barcode_capture_routes.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  final _homeBloc = HomeBloc();

  HomeScreen(this.title);

  void _onClick(BuildContext context, HomeSection mode) async {
    await Navigator.pushNamed(context, mode.route.routeName);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var permissionSatus = await Permission.camera.request();

      if (permissionSatus != PermissionStatus.granted) {
        print("Camera permission denied!!");
      }
    });

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Text(
                      _homeBloc.modes[index].title,
                    ),
                    onTap: () => {_onClick(context, _homeBloc.modes[index])},
                  ),
                ),
                itemCount: _homeBloc.modes.length,
              ),
            ),
            Text('Plugin Version: ${_homeBloc.pluginVersion}'),
          ],
        ),
      ),
    );
  }
}
