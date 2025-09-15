/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/get_scan_results.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/start_scanning.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/usecases/stop_scanning.dart';
import 'package:LabelCaptureSimpleSample/features/label_capture/domain/repositories/label_capture_repository.dart';
import 'package:LabelCaptureSimpleSample/core/error/failures.dart';
import 'label_capture_event.dart';
import 'label_capture_state.dart';

class LabelCaptureBloc extends Bloc<LabelCaptureEvent, LabelCaptureState> {
  final StartScanning _startScanning;
  final StopScanning _stopScanning;
  final GetScanResults _getScanResults;
  final LabelCaptureRepository _repository;

  StreamSubscription? _scanResultsSubscription;

  LabelCaptureBloc({
    required StartScanning startScanning,
    required StopScanning stopScanning,
    required GetScanResults getScanResults,
    required LabelCaptureRepository repository,
  })  : _startScanning = startScanning,
        _stopScanning = stopScanning,
        _getScanResults = getScanResults,
        _repository = repository,
        super(const LabelCaptureInitial()) {
    on<LabelCaptureInitialize>(_onInitialize);
    on<LabelCaptureStartScanning>(_onStartScanning);
    on<LabelCaptureStopScanning>(_onStopScanning);
    on<LabelCapturePauseScanning>(_onPauseScanning);
    on<LabelCaptureResumeScanning>(_onResumeScanning);
    on<LabelCaptureRequestPermission>(_onRequestPermission);
    on<LabelCaptureResultDialogDismissed>(_onResultDialogDismissed);
    on<LabelCaptureResultReceived>(_onResultReceived);
  }

  Future<void> _onInitialize(LabelCaptureInitialize event, Emitter<LabelCaptureState> emit) async {
    emit(const LabelCaptureLoading());

    try {
      final hasPermission = await _repository.hasCameraPermission();

      if (!hasPermission) {
        // Automatically request permission
        await _repository.requestCameraPermission();
      }

      // Start listening to scan results and automatically start scanning
      _listenToScanResults();
      await _startScanning();
      emit(const LabelCaptureScanning());
    } catch (e) {
      if (e is PermissionFailure) {
        emit(const LabelCapturePermissionDenied());
      } else {
        emit(LabelCaptureError(e.toString()));
      }
    }
  }

  Future<void> _onStartScanning(LabelCaptureStartScanning event, Emitter<LabelCaptureState> emit) async {
    try {
      await _startScanning();
      emit(const LabelCaptureScanning());
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  Future<void> _onStopScanning(LabelCaptureStopScanning event, Emitter<LabelCaptureState> emit) async {
    try {
      await _stopScanning();
      emit(const LabelCaptureStopped());
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  Future<void> _onPauseScanning(LabelCapturePauseScanning event, Emitter<LabelCaptureState> emit) async {
    try {
      await _repository.pauseScanning();
      emit(const LabelCapturePaused());
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  Future<void> _onResumeScanning(LabelCaptureResumeScanning event, Emitter<LabelCaptureState> emit) async {
    try {
      await _repository.resumeScanning();
      emit(const LabelCaptureScanning());
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  Future<void> _onRequestPermission(LabelCaptureRequestPermission event, Emitter<LabelCaptureState> emit) async {
    try {
      await _repository.requestCameraPermission();
      _listenToScanResults();
      await _startScanning();
      emit(const LabelCaptureScanning());
    } catch (e) {
      emit(const LabelCapturePermissionDenied());
    }
  }

  Future<void> _onResultDialogDismissed(
      LabelCaptureResultDialogDismissed event, Emitter<LabelCaptureState> emit) async {
    try {
      await _repository.resumeScanning();
      emit(const LabelCaptureScanning());
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  Future<void> _onResultReceived(LabelCaptureResultReceived event, Emitter<LabelCaptureState> emit) async {
    try {
      await _repository.pauseScanning();
      emit(LabelCaptureResultCaptured(event.result));
    } catch (e) {
      emit(LabelCaptureError(e.toString()));
    }
  }

  void _listenToScanResults() {
    _scanResultsSubscription?.cancel();
    _scanResultsSubscription = _getScanResults().listen(
      (result) {
        add(LabelCaptureResultReceived(result));
      },
    );
  }

  @override
  Future<void> close() {
    _scanResultsSubscription?.cancel();
    return super.close();
  }
}
