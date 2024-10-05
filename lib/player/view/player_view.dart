part of 'player_page.dart';

class PlayerView extends StatefulWidget {
  final int durSeconds;

  final PlayerBloc bloc;
  const PlayerView({
    super.key,
    required this.durSeconds,
    required this.bloc,
  });

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  double totalDuration = 0;
  int currentDuration = 0;
  String minStr = "", secStr = "";

  @override
  Widget build(BuildContext context) {
    var current =
        context.select((PlayerBloc bloc) => bloc.state.position.toDouble());
    printt("current: $current, total: $totalDuration");

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 18,
            child: SizedBox(
              child: Column(
                children: [
                  Text(
                      //"currently playing: ${context.select((PlayerBloc bloc) => bloc.state.fileName.split(".").first)}"),
                      "currently playing: ${widget.bloc.playSource.file.path.split("/").last.split(".").first}"),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: StreamBuilder<MyPlayerState>(
                stream: widget.bloc.stream,
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("$minStr:$secStr"),
                      ),
                      Slider(
                          //value: context.select((PlayerBloc bloc) =>
                          //   bloc.state.duration.toDouble()),
                          value: currentDuration.toDouble(),
                          onChanged: (value) {},
                          min: 0,
                          max: current),
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<void> getTotalDur() async {
    var dur = await widget.bloc.playSource.totalDuration;
    totalDuration = dur.inSeconds.toDouble();
    printt("total: $totalDuration");

    Duration aDur = await widget.bloc.playSource.currentDuration;
    minStr = aDur.inMinutes.toString().padLeft(2, "0");
    secStr = aDur.inSeconds.toString().padLeft(2, "0");
    currentDuration = aDur.inSeconds;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalDur();
  }

  void printt(String a) {
    for (int i = 0; i < 10; i++) {
      print(a);
    }
  }
}
