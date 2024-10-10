part of 'player_bloc.dart';

sealed class MyPlayerState extends Equatable {
  final int position;
  final File file;
  const MyPlayerState(this.position, this.file,);

  @override
  List<Object> get props => [position, file];
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
  PlayerRunComplete() : super(0, File(""));
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
