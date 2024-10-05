import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/play_source.dart';
import 'package:musicplayer/player/bloc/player_bloc.dart';

part 'player_view.dart';

class PlayerPage extends StatefulWidget {
  final AudioPlayer audioPlayer;
  const PlayerPage({super.key, required this.audioPlayer});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  File file = File("");
  late PlayerBloc _playerBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _playerBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Player'),
          actions: [
            IconButton(
              icon: const Icon(Icons.music_note),
              onPressed: () async {
                await _selectAndPlayFile();
              },
            ),
          ],
        ),
        body: BlocBuilder<PlayerBloc, MyPlayerState>(
          builder: (context, state) {
            if (state is PlayerRunInProgress) {
              return PlayerView(
                durSeconds: state.position,
                bloc: _playerBloc,
              );
            } else if (state is PlayerFailure) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return const Center(
                child: Text('No file selected'),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _playerBloc = PlayerBloc(
      playSource: PlaySource(player: widget.audioPlayer, file: file),
    );
  }

  Future<void> _selectAndPlayFile() async {
    try {
      var filee = (await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      ))
          ?.files
          .first;
      if (filee != null) {
        setState(() {
          file = File(filee.path!);
        });
        _playerBloc.add(PlayerFileSelected(file: file));
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
