/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:IdCaptureExtendedSample/home/model/captured_id_result.dart';
import 'package:IdCaptureExtendedSample/result/bloc/result_bloc.dart';
import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final String title;
  final int scanditBlue = 0xFF58B5C2;

  ResultView(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final captureResult = ModalRoute.of(context)!.settings.arguments as CapturedIdResult;
    final bloc = ResultBloc(captureResult);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Visibility(
            visible: bloc.faceImage != null,
            child: Container(
              width: 120,
              height: 120,
              child: bloc.faceImage ?? Container(),
            ),
          ),
          Visibility(
            visible: bloc.croppedDocument != null,
            child: bloc.croppedDocument ?? Container(),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: bloc.items.length,
            itemBuilder: (BuildContext context, int index) {
              var result = bloc.items[index];
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(left: 8.0, right: 2.0),
                title: Text(
                  result.value,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  result.key,
                  style: TextStyle(
                    color: Color(scanditBlue),
                    fontSize: 12,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ]),
      ),
    );
  }
}
