import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class PlaySource {
  final AudioPlayer _player;

  File _file;
  PlaySource({required AudioPlayer player, required File file})
      : _file = file,
        _player = player;

  Future<Duration> get totalDuration async =>
      await _player.getDuration() ?? Duration.zero;
  Future<Duration> get currentDuration async =>
      await _player.getCurrentPosition() ?? Duration.zero;

  File get file => _file;

  set file(File file) {
    _file = file;
  }

  Stream<AudioEvent> get stream => _player.eventStream;

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

  getPosition() async {
    var posf = await _player.getCurrentPosition();
    return posf?.inSeconds ?? 0;
  }
}
