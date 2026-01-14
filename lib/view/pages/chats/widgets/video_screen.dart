import 'dart:io';


import 'package:breffini_staff/core/theme/color_resources.dart';
import 'package:breffini_staff/core/utils/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class VideoViewScreen extends StatefulWidget {
  String videoUrl;
  String thumbUrl="";
  bool showAppBar;

  VideoViewScreen({required this.videoUrl,this.showAppBar=true,this.thumbUrl=""});

  @override
  _VideoViewScreenState createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  VideoPlayerController? _controller;
  bool _isControlsVisible = false;
  Timer? _hideControlsTimer;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    initializePlayer();

  }
  initializePlayer() async {
    String sss=widget.videoUrl;
    File file=File("");
    if(widget.videoUrl.startsWith("http")) {
      file = await DefaultCacheManager().getSingleFile(widget.videoUrl);
    }else{
      file=File(widget.videoUrl);
    }


    if(!widget.videoUrl.startsWith("http") || file.existsSync()){
      _controller = VideoPlayerController.file(File(file.existsSync()?file.path:widget.videoUrl))
        ..initialize().then((_) {
          setState(() {
            _sliderValue = _controller!.value.position.inSeconds.toDouble();
            _controller?.play();

          });
        });
    }else {

      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        ..initialize().then((_) {
          setState(() {
            _sliderValue = _controller!.value.position.inSeconds.toDouble();
            _controller?.play();

          });
        });
    }

    // Periodically update the slider value
    _controller!.addListener(() {
      if (_controller!.value.isInitialized) {
        setState(() {
          _sliderValue = _controller!.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  void _showControls() {
    setState(() {
      _isControlsVisible = true;
    });
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        _isControlsVisible = false;
      });
    });
  }

  void _seekTo(double value) {
    final position = Duration(seconds: value.toInt());
    _controller!.seekTo(position);
  }

  void _rewind() {
    final currentPosition = _controller!.value.position;
    final rewindPosition = currentPosition - Duration(seconds: 10);
    _controller!.seekTo(
        rewindPosition > Duration.zero ? rewindPosition : Duration.zero);
  }

  void _fastForward() {
    final currentPosition = _controller!.value.position;
    final forwardPosition = currentPosition + Duration(seconds: 10);
    _controller!.seekTo(forwardPosition < _controller!.value.duration
        ? forwardPosition
        : _controller!.value.duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.colorBlack,
      appBar: widget.showAppBar?AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: ColorResources.colorwhite,
          ),
        ),
        title: Text(
          'Video',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: ColorResources.colorwhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ):null,
      body: GestureDetector(
        onTap: _showControls,
        child: Stack(
          children: [
            null!= _controller && _controller!.value.isInitialized
                ? Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            )
                : SizedBox(),
            if (null!=_controller && _controller!.value.isInitialized && _isControlsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Seek Slider
                      Slider(
                        value: _sliderValue,
                        min: 0.0,
                        max: _controller!.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                          _seekTo(value);
                        },
                      ),
                      // Play/Pause and Rewind/Forward Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10, color: Colors.white),
                            onPressed: _rewind,
                          ),
                          IconButton(
                            icon: Icon(
                              null!=_controller && _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: _togglePlayPause,
                          ),
                          IconButton(
                            icon: Icon(Icons.forward_10, color: Colors.white),
                            onPressed: _fastForward,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (null==_controller || !_controller!.value.isInitialized)
              Stack(
                alignment: Alignment.center,
                children: [
                  if(!widget.thumbUrl.isNullOrEmpty())
                    widget.thumbUrl.startsWith("http")?
                    Image.network(widget.thumbUrl,
                      width: double.infinity,height: double.infinity,
                      fit: BoxFit.cover,)
                        :
                    Image.file(File(widget.thumbUrl),
                      width: double.infinity,height: double.infinity,
                      fit: BoxFit.cover,),
                  Center(
                    child: CircularProgressIndicator(color: ColorResources.colorBlue600,),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _hideControlsTimer?.cancel();
  }
}
