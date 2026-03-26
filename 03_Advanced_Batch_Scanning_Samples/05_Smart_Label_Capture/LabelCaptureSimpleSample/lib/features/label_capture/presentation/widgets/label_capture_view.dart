/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/data/datasources/label_capture_data_source.dart';

class LabelCaptureView extends StatefulWidget {
  final LabelCaptureDataSource dataSource;

  const LabelCaptureView({super.key, required this.dataSource});

  @override
  State<LabelCaptureView> createState() => _LabelCaptureViewState();
}

class _LabelCaptureViewState extends State<LabelCaptureView> {
  @override
  Widget build(BuildContext context) {
    return DataCaptureView(dataCaptureContext: widget.dataSource.dataCaptureContext, overlays: [
      widget.dataSource.buildLabelCaptureOverlay(context),
      widget.dataSource.buildValidationFlowOverlay(context)
    ]);
  }
}
