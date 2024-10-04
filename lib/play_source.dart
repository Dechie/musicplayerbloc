import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class PlaySource {
  final AudioPlayer _player;

  final File file;
  const PlaySource({required AudioPlayer player, required this.file})
      : _player = player;

  Future<Duration> get duration async =>
      await _player.getDuration() ?? Duration.zero;

  Stream<AudioEvent> get stream => _player.eventStream;

  @override
  void dispose() {
    _player.dispose();
  }

  void pause() {
    _player.pause();
  }

  void resume() {
    _player.resume();
  }

  void startPlay() async {
    Uint8List bytes = file.readAsBytesSync();
    await _player.play(BytesSource(bytes));
  }

  void stop() {
    _player.stop();
  }
}
