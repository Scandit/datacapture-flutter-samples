/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/bloc/label_capture_bloc.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/bloc/label_capture_event.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/bloc/label_capture_state.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/widgets/label_capture_view.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/widgets/result_dialog.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/data/datasources/label_capture_data_source.dart';

class LabelCapturePage extends StatefulWidget {
  final LabelCaptureDataSource dataSource;

  const LabelCapturePage({super.key, required this.dataSource});

  @override
  State<LabelCapturePage> createState() => _LabelCapturePageState();
}

class _LabelCapturePageState extends State<LabelCapturePage> {
  @override
  void initState() {
    super.initState();
    context.read<LabelCaptureBloc>().add(const LabelCaptureInitialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Label Scan'), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: BlocConsumer<LabelCaptureBloc, LabelCaptureState>(
        listener: (context, state) {
          if (state is LabelCaptureResultCaptured) {
            _showResultDialog(context, state.result);
          } else if (state is LabelCaptureError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        builder: (context, state) {
          if (state is LabelCaptureInitial || state is LabelCaptureLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Initializing camera...')],
              ),
            );
          } else if (state is LabelCaptureScanning ||
              state is LabelCapturePaused ||
              state is LabelCaptureResultCaptured) {
            return LabelCaptureView(dataSource: widget.dataSource);
          } else if (state is LabelCaptureError) {
            return _buildErrorView(state.message);
          } else if (state is LabelCapturePermissionDenied) {
            return _buildPermissionDeniedView();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LabelCaptureBloc>().add(const LabelCaptureInitialize());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Camera permission is required to scan labels',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LabelCaptureBloc>().add(const LabelCaptureRequestPermission());
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showResultDialog(BuildContext context, result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ResultDialog(
        result: result,
        onContinue: () {
          Navigator.of(dialogContext).pop();
          context.read<LabelCaptureBloc>().add(const LabelCaptureResultDialogDismissed());
        },
      ),
    );
  }
}
