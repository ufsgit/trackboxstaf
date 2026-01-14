import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final bool moreMenuButton;
  bool isPlaying;
  bool isStudent;
  final Color durationTextColor;
  final Widget Function(String duration, Widget slider)? builder;
  final void Function(bool isPlaying)? onClickPlay;
  final void Function(bool isPaused)? onClickPaused;

  PlayerWidget({
    required this.player,
    super.key,
    this.moreMenuButton = true,
    this.durationTextColor = Colors.black,
    this.onClickPlay,
    this.onClickPaused,
    this.builder,
    required this.isPlaying,
    required this.isStudent,
  });

  @override
  State<StatefulWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText =>
      _duration?.toString().split('.').first ?? '00:00:00';
  String get _positionText =>
      _position?.toString().split('.').first ?? '00:00:00';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    _playerState = player.state;
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final color = Colors.blue.shade600;
    final color = const Color(0xFFE3E7EE);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.builder != null)
          widget.builder!(
            _position != null
                ? '$_positionText / $_durationText'
                : _duration != null
                    ? _durationText
                    : '00:00:00',
            SliderWidget(
                duration: _duration,
                player: player,
                position: _position,
                isStudent: widget.isStudent),
          )
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 45,
                margin: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF6A7487),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: IconButton(
                  // Use a ternary operator to handle play/pause action
                  onPressed: widget.isPlaying && _isPlaying ? _pause : _play,
                  iconSize: 28.0,
                  icon: Icon(widget.isPlaying && _isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  color: const Color(0xFFE3E7EE),
                ),
              ),

              // if (_isPlaying || _isPaused)
              //   IconButton(
              //     key: const Key('stop_button'),
              //     onPressed: _isPlaying || _isPaused ? _stop : null,
              //     iconSize: 48.0,
              //     icon: const Icon(Icons.stop),
              //     color: color,
              //   ),
              (widget.isPlaying && _isPlaying)
                  ? Expanded(
                      child: SliderWidget(
                          duration: _duration,
                          player: player,
                          position: _position,
                          isStudent: widget.isStudent),
                    )
                  : Expanded(
                      child: Slider(
                          thumbColor: widget.isStudent
                              ? const Color(0xFF6A7487)
                              : const Color(0xFFE3E7EE),
                          activeColor: widget.isStudent
                              ? const Color(0xFF6A7487)
                              : const Color(0xFFE3E7EE),
                          inactiveColor: widget.isStudent
                              ? const Color(0xFFE3E7EE)
                              : const Color(0xFF6A7487),
                          onChanged: (value) {},
                          value: 0),
                    ),
              (widget.isPlaying && _isPlaying)
                  ? Text(
                      _position != null
                          ? _positionText
                          : _duration != null
                              ? _durationText
                              : '00:00:00',
                      style: TextStyle(
                          fontSize: 12.0, color: widget.durationTextColor),
                    )
                  : Text(''),
              SizedBox(
                width: 10,
              ),
              if (widget.moreMenuButton)
                PopupMenuButton(
                  color: Colors.white,
                  iconColor: Colors.grey.shade600,
                  itemBuilder: (c) => [
                    PopupMenuItem(
                      onTap: () => _changePlaybackSpeed(0.5),
                      child: const Text(
                        '0.5x',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _changePlaybackSpeed(1.0),
                      child: const Text(
                        '1x',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _changePlaybackSpeed(1.5),
                      child: const Text(
                        '1.5x',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _changePlaybackSpeed(2),
                      child: const Text(
                        '2x',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
            ],
          )
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
        print("AAAAAAAAAAAAAAAA");
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      // print(state.toString());
      // print(state.toString());
      if (state == PlayerState.completed) {
        widget.onClickPaused!(true);
      }
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    _pause();
    try {
      await player.resume();
      setState(() => _playerState = PlayerState.playing);
      if (widget.onClickPlay != null) {
        widget.onClickPlay!(true);
      }
    } catch (e) {
      print('Error during playback: $e');
      // Handle error
    }
  }

  Future<void> _pause() async {
    try {
      await player.pause();
      setState(() => _playerState = PlayerState.paused);
      if (widget.onClickPaused != null) {
        widget.onClickPaused!(true);
      }
    } catch (e) {
      print('Error during pause: $e');
      // Handle error
    }
  }

  Future<void> _stop() async {
    try {
      await player.stop();
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    } catch (e) {
      print('Error during stop: $e');
      // Handle error
    }
  }

  _changePlaybackSpeed(double d) {
    player.setPlaybackRate(d);
  }
}

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required Duration? duration,
    required this.player,
    required this.isStudent,
    required Duration? position,
  })  : _duration = duration,
        _position = position;

  final Duration? _duration;
  final AudioPlayer player;
  final bool isStudent;
  final Duration? _position;

  @override
  Widget build(BuildContext context) {
    return Slider(
      thumbColor: isStudent ? const Color(0xFF6A7487) : const Color(0xFFE3E7EE),
      activeColor:
          isStudent ? const Color(0xFF6A7487) : const Color(0xFFE3E7EE),
      inactiveColor:
          isStudent ? const Color(0xFFE3E7EE) : const Color(0xFF6A7487),
      onChanged: (value) {
        final duration = _duration;
        if (duration == null) return;
        final position = value * duration.inMilliseconds;
        player.seek(Duration(milliseconds: position.round()));
      },
      value: (_position != null &&
              _duration != null &&
              _position!.inMilliseconds > 0 &&
              _position!.inMilliseconds < _duration!.inMilliseconds)
          ? _position!.inMilliseconds / _duration!.inMilliseconds
          : 0.0,
    );
  }
}
