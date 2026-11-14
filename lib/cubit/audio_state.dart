sealed class AudioState {
  const AudioState();
}

class AudioInput extends AudioState {
  const AudioInput();
}

class AudioResult extends AudioState {
  const AudioResult(this.bytes);

  final double bytes;
}
