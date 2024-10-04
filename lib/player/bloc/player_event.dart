part of 'player_bloc.dart';

sealed class PlayerEvent {
  const PlayerEvent();
}

class PlayerStarted extends PlayerEvent {
  final int duration;
  const PlayerStarted({required this.duration});
}

class _PlayerPlayed extends PlayerEvent {
  final int duration;
  const _PlayerPlayed({required this.duration});
}

class PlayerPaused extends PlayerEvent {
  const PlayerPaused();
}

class PlayerResumed extends PlayerEvent {
  const PlayerResumed();
}

class PlayerStopped extends PlayerEvent {
  const PlayerStopped();
}

class PlayerReset extends PlayerEvent {
  const PlayerReset();
}

class PlayerFileSelected extends PlayerEvent {
  final File file;
  const PlayerFileSelected({required this.file});
}
