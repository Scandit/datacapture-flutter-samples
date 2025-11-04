/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:matrixscancountsimplesample/result/model/result_screen_navigation_args.dart';

import '../bloc/result_bloc.dart';
import '../model/result_screen_return.dart';

class ResultScreen extends StatefulWidget {
  final String title;
  final ResultBloc bloc;

  ResultScreen(this.title, this.bloc);

  @override
  _ResultScreenState createState() => _ResultScreenState(bloc);
}

class _ResultScreenState extends State<ResultScreen> with WidgetsBindingObserver {
  final ResultBloc _bloc;

  _ResultScreenState(this._bloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
              child: Align(
                child: Text(
                  "Items (${_bloc.numberOfScannedItems})",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.topLeft,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = _bloc.getItem(index);
                  return ListTile(
                    leading: item.buildLeading(context),
                    title: item.buildTitle(context),
                    subtitle: item.buildSubtitle(context),
                    trailing: item.buildTrailing(context),
                  );
                },
                itemCount: _bloc.itemsCount,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {
                      Navigator.pop(context, ResultScreenReturn(false));
                    },
                    child:
                        Text(_bloc.doneButtonStyle == DoneButtonStyle.resume ? 'RESUME SCANNING' : 'SCAN NEXT ORDER'),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, side: BorderSide(width: 2, color: Colors.black)),
                      onPressed: () {
                        Navigator.pop(context, ResultScreenReturn(true));
                      },
                      child: Text('CLEAR LIST', style: TextStyle(color: Colors.black)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
