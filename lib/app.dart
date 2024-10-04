import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/play_source.dart';

import 'player/bloc/player_bloc.dart';
import 'player/view/player_page.dart';

class PlayerApp extends StatelessWidget {
  final AudioPlayer player;
  const PlayerApp({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            PlayerBloc(playSource: PlaySource(player: player, file: File(""))),
        child: PlayerPage(
          audioPlayer: player,
        ),
      ),
    );
  }
}
