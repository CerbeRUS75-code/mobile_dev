import 'package:flutter_bloc/flutter_bloc.dart';

import 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(const AudioInput());

  void calculate({
    required int channels,
    required int frequency,
    required int depth,
    required double duration,
  }) {
    final bytes = frequency.toDouble() * channels * depth * duration / 8;
    emit(AudioResult(bytes));
  }

  void edit() => emit(const AudioInput());
}
