import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  final AudioPlayer player = AudioPlayer();
  runApp(PlayerApp(player: player));
}
