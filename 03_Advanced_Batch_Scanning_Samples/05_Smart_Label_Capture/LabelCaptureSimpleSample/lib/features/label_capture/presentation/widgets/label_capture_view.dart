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
  late DataCaptureView _dataCaptureView;

  @override
  void initState() {
    super.initState();
    _initializeDataCaptureView();
  }

  void _initializeDataCaptureView() {
    _dataCaptureView = DataCaptureView.forContext(widget.dataSource.dataCaptureContext);

    // Add torch control
    _dataCaptureView.addControl(TorchSwitchControl());

    // Add overlays
    final basicOverlay = widget.dataSource.buildLabelCaptureOverlay(context);
    final validationOverlay = widget.dataSource.buildValidationFlowOverlay(context);

    _dataCaptureView.addOverlay(basicOverlay);
    _dataCaptureView.addOverlay(validationOverlay);
  }

  @override
  Widget build(BuildContext context) {
    return _dataCaptureView;
  }
}
