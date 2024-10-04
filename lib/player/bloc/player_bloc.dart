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
    on<PlayerStarted>(_onStarted);
    on<_PlayerPlayed>(_onPlayed);
    on<PlayerPaused>(_onPaused);
    on<PlayerResumed>(_onResumed);
    on<PlayerReset>(_onReset);
  }

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
        Duration currentDuration = await _playSource.duration;
        emit(PlayerRunPause(currentDuration.inSeconds, ""));
      } catch (e) {
        emit(PlayerFailure(0, "", error: e.toString()));
      }
    }
  }

  void _onPlayed(_PlayerPlayed event, Emitter<MyPlayerState> emit) {
    emit(
      event.duration > 0
          ? PlayerRunInProgress(event.duration, "")
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
        Duration currentDuration = await _playSource.duration;
        emit(PlayerRunInProgress(currentDuration.inSeconds, ""));
      } catch (e) {
        emit(PlayerFailure(0, "", error: e.toString()));
      }
    }
  }

  void _onStarted(PlayerEvent event, Emitter<MyPlayerState> emit) async {
    if (state is PlayerFileSelected) {
      try {
        Duration currentDuration = await _playSource.duration;

        emit(PlayerRunInProgress(
            currentDuration.inSeconds, _playSource.file.path));
        _playerSubscription?.cancel();
        _playerSubscription = _playSource.stream.listen(
          (event) => add(
            _PlayerPlayed(
              duration: event.duration?.inSeconds ?? 0,
            ),
          ),
        );
      } catch (e) {
        emit(PlayerFailure(0, _playSource.file.path, error: e.toString()));
      }
    }
  }
}
