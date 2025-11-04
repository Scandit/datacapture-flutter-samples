/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:RestockingSample/result/bloc/result_bloc.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ResultScreenState(ResultBloc());
}

class _ResultScreenState extends State<ResultScreen> {
  ResultBloc _bloc;

  _ResultScreenState(this._bloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Result List'),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _bloc.items.length,
              itemBuilder: (context, index) {
                final item = _bloc.items[index];

                return ListTile(
                  leading: item.buildLeading(context),
                  title: item.buildTitle(context),
                  subtitle: item.buildSubtitle(context),
                  trailing: item.buildTrailing(context),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                  onPressed: () {
                    // Go back without cleaning up anything
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CONTINUE SCANNING',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(width: 2, color: Colors.black),
                        shape: BeveledRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      // Restart the app so we can start the process again
                      _bloc.clearPickedAndScanned();
                      Navigator.pop(context);
                    },
                    child: Text('FINISH', style: TextStyle(color: Colors.black)))
              ],
            ),
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
