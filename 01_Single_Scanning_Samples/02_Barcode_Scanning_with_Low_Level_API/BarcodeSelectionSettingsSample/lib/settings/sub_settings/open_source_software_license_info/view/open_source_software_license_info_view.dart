/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';

import '../bloc/open_source_software_license_info_bloc.dart';

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class OpenSourceSoftwareLicenseInfoView extends StatelessWidget {
  final String title;
  final OpenSourceSoftwareLicenseInfoBloc _bloc = OpenSourceSoftwareLicenseInfoBloc();

  OpenSourceSoftwareLicenseInfoView(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: FutureBuilder<OpenSourceSoftwareLicenseInfo>(
          future: _bloc.getOpenSourceSoftwareLicenseInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error loading the open source software license info.");
            } else if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: SingleChildScrollView(
                  child: Text(snapshot.data!.licenseText, textAlign: TextAlign.left, style: TextStyle(fontSize: 10)),
                ),
              );
            } else {
              return Text("No data loaded from native.");
            }
          },
        ),
      ),
    );
  }
}
