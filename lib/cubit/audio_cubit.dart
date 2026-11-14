import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/calculation_storage.dart';
import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit(this.storage) : super(const AudioLoading());
  final CalculationStorage storage;

  Future<void> loadLast() async {
    try {
      final last = await storage.loadLast();
      if (!isClosed) emit(AudioInput(last: last));
    } catch (_) {
      if (!isClosed) {
        emit(const AudioError('Не удалось загрузить последние данные'));
      }
    }
  }

  Future<void> calculate({
    required int channels,
    required int frequency,
    required int depth,
    required double duration,
  }) async {
    final bytes = frequency.toDouble() * channels * depth * duration / 8;
    if (!bytes.isFinite) {
      emit(const AudioError('Результат слишком велик для расчёта'));
      return;
    }
    emit(const AudioLoading());
    try {
      await storage.saveCalculation(
        channels: channels,
        frequency: frequency,
        depth: depth,
        duration: duration,
        bytes: bytes,
      );
      if (!isClosed) emit(AudioResult(bytes));
    } catch (_) {
      if (!isClosed) emit(const AudioError('Не удалось сохранить расчёт'));
    }
  }

  void edit() => emit(const AudioInput());
}
