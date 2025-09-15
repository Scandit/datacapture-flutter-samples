/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:LabelCaptureSimpleSample/features/label_capture/data/datasources/label_capture_data_source.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/data/repositories/label_capture_repository_impl.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/repositories/label_capture_repository.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/get_scan_results.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/start_scanning.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/stop_scanning.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/presentation/bloc/label_capture_bloc.dart';

class DependencyContainer {
  late final LabelCaptureDataSource _dataSource;
  late final LabelCaptureRepository _repository;
  late final StartScanning _startScanning;
  late final StopScanning _stopScanning;
  late final GetScanResults _getScanResults;

  Future<void> initialize() async {
    // Data sources
    _dataSource = LabelCaptureDataSourceImpl();
    await _dataSource.initialize();

    // Repository
    _repository = LabelCaptureRepositoryImpl(dataSource: _dataSource);

    // Use cases
    _startScanning = StartScanning(_repository);
    _stopScanning = StopScanning(_repository);
    _getScanResults = GetScanResults(_repository);
  }

  LabelCaptureDataSource get dataSource => _dataSource;

  LabelCaptureBloc createLabelCaptureBloc() {
    return LabelCaptureBloc(
      startScanning: _startScanning,
      stopScanning: _stopScanning,
      getScanResults: _getScanResults,
      repository: _repository,
    );
  }

  void dispose() {
    _dataSource.dispose();
  }
}

final DependencyContainer dependencies = DependencyContainer();
