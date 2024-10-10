import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/play_source.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, MyPlayerState> {
  static const int _duration = 0;

  final PlaySource _playSource;
  StreamSubscription<AudioEvent>? _playerSubscription;

  PlayerBloc({required PlaySource playSource})
      : _playSource = playSource,
        super(PlayerInitial(_duration, File(""))) {
    on<PlayerFileSelected>(_onStarted);
    //on<PlayerStarted>(_onStarted);
    on<_PlayerPlayed>(_onPlayed);
    on<PlayerPaused>(_onPaused);
    on<PlayerResumed>(_onResumed);
    on<PlayerReset>(_onReset);
  }
  PlaySource get playSource => _playSource;

  @override
  Future<void> close() {
    _playerSubscription?.cancel();
    return super.close();
  }

  void _onFileSelected(
      PlayerFileSelected event, Emitter<MyPlayerState> emit) async {
    _playSource.startPlay();
    emit(PlayerRunInProgress(event.position, event.file));
  }

  void _onPaused(PlayerPaused event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerRunInProgress) {
      try {
        _playerSubscription?.pause();
        _playSource.pause();
        Duration currentDuration = await _playSource.currentDuration;
        emit(PlayerRunPause(currentDuration.inSeconds, File("")));
      } catch (e) {
        emit(PlayerFailure(0, File(""), error: e.toString()));
      }
    }
  }

  void _onPlayed(_PlayerPlayed event, Emitter<MyPlayerState> emit) {
    emit(
      event.currentPosition > 0
          ? PlayerRunInProgress(event.currentPosition, event.file)
          : PlayerRunComplete(),
    );
  }

  void _onReset(PlayerReset event, Emitter<MyPlayerState> emit) {
    _playerSubscription?.cancel();
    _playSource.stop();
    emit(PlayerInitial(0, File("")));
  }

  void _onResumed(PlayerResumed event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerRunPause) {
      _playerSubscription?.resume();
      _playSource.resume();
      try {
        Duration currentDuration = await _playSource.currentDuration;
        emit(PlayerRunInProgress(
          currentDuration.inSeconds,
          event.file,
        ));
      } catch (e) {
        emit(PlayerFailure(0, event.file, error: e.toString()));
      }
    }
  }

  void _onStarted(
      PlayerFileSelected playerEvent, Emitter<MyPlayerState> emit) async {
    if (state is PlayerInitial) {
      try {
        _playSource.file = playerEvent.file;
        Duration currentDuration = await _playSource.currentDuration;

        emit(PlayerRunInProgress(currentDuration.inSeconds, playerEvent.file));
        _playerSubscription?.cancel();
        _playerSubscription = _playSource.stream.listen(
          (event) async {
            int pos = await _playSource.getPosition();
            // current position of the audio.
            add(
              _PlayerPlayed(
                currentPosition: pos,
                file: playerEvent.file,
              ),
            );
          },
        );

        _playSource.startPlay();
      } catch (e) {
        emit(PlayerFailure(0, _playSource.file, error: e.toString()));
      }
    }
  }
}
