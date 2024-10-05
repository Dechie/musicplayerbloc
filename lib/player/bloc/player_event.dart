part of 'player_bloc.dart';

sealed class PlayerEvent {
  const PlayerEvent();
}

class PlayerFileSelected extends PlayerEvent {
  final File file;
  const PlayerFileSelected({required this.file});
}

class PlayerPaused extends PlayerEvent {
  const PlayerPaused();
}

class PlayerReset extends PlayerEvent {
  const PlayerReset();
}

class PlayerResumed extends PlayerEvent {
  const PlayerResumed();
}

class PlayerStarted extends PlayerEvent {
  final int duration;
  const PlayerStarted({required this.duration});
}

class PlayerStopped extends PlayerEvent {
  const PlayerStopped();
}

class _PlayerPlayed extends PlayerEvent {
  final int currentPosition;
  const _PlayerPlayed({required this.currentPosition});
}
