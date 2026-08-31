/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_ar.dart';

import '../sample_bootstrap.dart';

class BarcodeArScaffold extends StatelessWidget {
  final String title;
  final BarcodeArView barcodeArView;

  const BarcodeArScaffold({
    super.key,
    required this.title,
    required this.barcodeArView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildToolbar(context),
          Expanded(
            child: barcodeArView,
          ),
          _buildBottomToolbar(context),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      height: 100 + MediaQuery.of(context).padding.top,
      color: Colors.black,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 28,
        bottom: 28,
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToolbar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 48,
        bottom: MediaQuery.of(context).padding.bottom + 48,
        left: 48,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF5C6266),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  sampleAssetPath('assets/ic_return.png'),
                  width: 28,
                  height: 28,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 56,
            child: const Text(
              'Return',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
