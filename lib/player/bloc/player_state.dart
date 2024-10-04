part of 'player_bloc.dart';

sealed class MyPlayerState extends Equatable {
  final int duration;
  final String fileName;
  const MyPlayerState(this.duration, this.fileName);

  @override
  List<Object> get props => [duration, fileName];
}

final class PlayerFailure extends MyPlayerState {
  final String error;
  const PlayerFailure(super.duration, super.fileName, {required this.error});

  @override
  String toString() => 'PlayerRunPause { duration: $duration }';
}

final class PlayerInitial extends MyPlayerState {
  const PlayerInitial(
    super.duration,
    super.fileName,
  );

  @override
  String toString() => 'PlayerInitial { duration: $duration }';
}

final class PlayerRunComplete extends MyPlayerState {
  const PlayerRunComplete() : super(0, "");
}

final class PlayerRunInProgress extends MyPlayerState {
  const PlayerRunInProgress(
    super.duration,
    super.fileName,
  );

  @override
  String toString() => 'PlayerRunInProgress { duration: $duration }';
}

final class PlayerRunPause extends MyPlayerState {
  const PlayerRunPause(
    super.duration,
    super.fileName,
  );

  @override
  String toString() => 'PlayerRunPause { duration: $duration }';
}
