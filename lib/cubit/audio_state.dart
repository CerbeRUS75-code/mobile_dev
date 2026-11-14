sealed class AudioState {
  const AudioState();
}

class AudioLoading extends AudioState {
  const AudioLoading();
}

class AudioInput extends AudioState {
  const AudioInput({this.last});
  final Map<String, Object>? last;
}

class AudioResult extends AudioState {
  const AudioResult(this.bytes);
  final double bytes;
}

class AudioError extends AudioState {
  const AudioError(this.message);
  final String message;
}
