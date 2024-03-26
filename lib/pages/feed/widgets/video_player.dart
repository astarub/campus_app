import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/core/themes.dart';
import 'package:flutter/material.dart';

class FeedVideoPlayer extends StatefulWidget {
  /// The network URL to video
  final String url;

  /// Video will directly start to play
  final bool autoplay;

  /// Video will be muted (unmute by user not implemented!)
  final bool muted;

  /// Disable Pause / Play / Replay Button
  final VoidCallback? tabHandler;

  const FeedVideoPlayer({
    Key? key,
    required this.url,
    this.autoplay = false,
    this.muted = false,
    this.tabHandler,
  }) : super(key: key);

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  /// The controller object to handle video player
  late CachedVideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  // Show replay instead of pause / play button
  bool showReplayButton = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = CachedVideoPlayerController.network(widget.url)..initialize();
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: const CustomVideoPlayerSettings(
        showFullscreenButton: false,
        settingsButtonAvailable: false,
        playOnlyOnce: true,
        showDurationPlayed: false,
        showDurationRemaining: false,
        controlBarAvailable: false,
        alwaysShowThumbnailOnVideoPaused: true,
        showPlayButton: false,
      ),
    );

    _customVideoPlayerController.videoPlayerController.addListener(() {
      setState(() {
        if (!_customVideoPlayerController.videoPlayerController.value.isPlaying &&
            _customVideoPlayerController.videoPlayerController.value.isInitialized &&
            (_customVideoPlayerController.videoPlayerController.value.duration ==
                _customVideoPlayerController.videoPlayerController.value.position)) {
          showReplayButton = true;
        } else {
          showReplayButton = false;
        }
      });
    });

    // Automatically start playing video on state initilization
    if (widget.autoplay) _customVideoPlayerController.videoPlayerController.play();
    // Mute Audio at start
    if (widget.muted) _customVideoPlayerController.videoPlayerController.setVolume(0);
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomVideoPlayer(customVideoPlayerController: _customVideoPlayerController),
        Positioned.fill(
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: widget.tabHandler ??
                () => setState(() {
                      if (_customVideoPlayerController.videoPlayerController.value.isPlaying) {
                        _customVideoPlayerController.videoPlayerController.pause();
                      } else {
                        _customVideoPlayerController.videoPlayerController.play();
                      }
                    }),
            child: widget.tabHandler != null
                ? null
                : Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      color: _customVideoPlayerController.videoPlayerController.value.isPlaying
                          ? const Color.fromRGBO(0, 0, 0, 0)
                          : Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(245, 246, 250, 0.5)
                              : const Color.fromRGBO(34, 40, 54, 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                    ),
                    child: Icon(
                      showReplayButton
                          ? Icons.replay_sharp
                          : _customVideoPlayerController.videoPlayerController.value.isPlaying
                              ? Icons.pause_sharp
                              : Icons.play_arrow_sharp,
                      color: _customVideoPlayerController.videoPlayerController.value.isPlaying
                          ? const Color.fromRGBO(0, 0, 0, 0)
                          : Provider.of<ThemesNotifier>(context).currentTheme == AppThemes.light
                              ? const Color.fromRGBO(34, 40, 54, 1)
                              : const Color.fromRGBO(245, 246, 250, 1),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
