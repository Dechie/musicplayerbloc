part of 'player_bloc.dart';

sealed class MyPlayerState extends Equatable {
  final int position;
  final String fileName;
  const MyPlayerState(this.position, this.fileName);

  @override
  List<Object> get props => [position, fileName];
}

final class PlayerFailure extends MyPlayerState {
  final String error;
  const PlayerFailure(super.position, super.fileName, {required this.error});

  @override
  String toString() => 'PlayerRunPause { duration: $position }';
}

final class PlayerInitial extends MyPlayerState {
  const PlayerInitial(
    super.position,
    super.fileName,
  );

  @override
  String toString() => 'PlayerInitial { duration: $position }';
}

final class PlayerRunComplete extends MyPlayerState {
  const PlayerRunComplete() : super(0, "");
}

final class PlayerRunInProgress extends MyPlayerState {
  const PlayerRunInProgress(
    super.position,
    super.fileName,
  );

  @override
  String toString() => 'PlayerRunInProgress { duration: $position }';
}

final class PlayerRunPause extends MyPlayerState {
  const PlayerRunPause(
    super.position,
    super.fileName,
  );

  @override
  String toString() => 'PlayerRunPause { duration: $position }';
}
