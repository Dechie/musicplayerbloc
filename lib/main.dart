import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AudioPlayer player = AudioPlayer();
  runApp(PlayerApp(player: player));
}
