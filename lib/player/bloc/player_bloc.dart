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
        super(const PlayerInitial(_duration, "")) {
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
    emit(const PlayerInitial(0, ""));
  }

  void _onPaused(PlayerPaused event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerRunInProgress) {
      try {
        _playerSubscription?.pause();
        _playSource.pause();
        Duration currentDuration = await _playSource.currentDuration;
        emit(PlayerRunPause(currentDuration.inSeconds, ""));
      } catch (e) {
        emit(PlayerFailure(0, "", error: e.toString()));
      }
    }
  }

  void _onPlayed(_PlayerPlayed event, Emitter<MyPlayerState> emit) {
    emit(
      event.currentPosition > 0
          ? PlayerRunInProgress(event.currentPosition, "")
          : const PlayerRunComplete(),
    );
  }

  void _onReset(PlayerReset event, Emitter<MyPlayerState> emit) {
    _playerSubscription?.cancel();
    _playSource.stop();
    emit(PlayerInitial(0, _playSource.file.path));
  }

  void _onResumed(PlayerResumed event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerRunPause) {
      _playerSubscription?.resume();
      _playSource.resume();
      try {
        Duration currentDuration = await _playSource.currentDuration;
        emit(PlayerRunInProgress(currentDuration.inSeconds, ""));
      } catch (e) {
        emit(PlayerFailure(0, "", error: e.toString()));
      }
    }
  }

  void _onStarted(PlayerFileSelected event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerInitial) {
      try {
        _playSource.file = event.file;
        Duration currentDuration = await _playSource.currentDuration;

        emit(PlayerRunInProgress(
            currentDuration.inSeconds, _playSource.file.path));
        _playerSubscription?.cancel();
        _playerSubscription = _playSource.stream.listen(
          (event) async {
            int pos = await _playSource.getPosition();
            // current position of the audio.
            add(
              _PlayerPlayed(
                currentPosition: pos,
              ),
            );
          },
        );

        _playSource.startPlay();
      } catch (e) {
        emit(PlayerFailure(0, _playSource.file.path, error: e.toString()));
      }
    }
  }
}
