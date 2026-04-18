import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/services/audio_manager_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  late String _playerId;
  late AudioManagerService _audioManager;
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playerId = 'audio_${widget.audioUrl}_${DateTime.now().millisecondsSinceEpoch}';
    _audioManager = Get.find<AudioManagerService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void didUpdateWidget(AudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl) {
      // Audio URL changed, reset and restart player
      _resetAndStartNewAudio();
    }
  }

  Future<void> _init() async {
    try {
      if (widget.audioUrl.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isPlaying = false;
          });
        }
        return;
      }

      // Set up position listener
      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
          });
        }
      });

      // Set up duration listener
      _audioPlayer.durationStream.listen((duration) {
        if (mounted && duration != null) {
          setState(() {
            _duration = duration;
          });
        }
      });

      // Set up player state listener
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
            if (state.processingState == ProcessingState.completed) {
              _position = Duration.zero;
            }
          });
        }
      });

      // Load audio but DON'T auto-play
      await _audioPlayer.setUrl(widget.audioUrl);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      // DO NOT auto-play - user must click play button
      // await _audioPlayer.play();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error initializing audio player: $e');
    }
  }

  Future<void> _resetAndStartNewAudio() async {
    try {
      // Stop and reset current player
      await _audioPlayer.stop();
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
          _duration = Duration.zero;
          _isLoading = true;
        });
      }
      // Restart player with new URL
      await _init();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error resetting audio player: $e');
    }
  }

  @override
  void deactivate() {
    // Stop audio when widget is deactivated (removed from tree)
    _audioPlayer.stop().catchError((e) {
      print('Error stopping audio on deactivate: $e');
    });
    _audioManager.unregisterPlayer(_playerId);
    super.deactivate();
  }

  @override
  void dispose() {
    // Unregister from audio manager
    _audioManager.unregisterPlayer(_playerId);

    // Stop and dispose player to prevent background playback
    _audioPlayer.stop().then((_) {
      return _audioPlayer.dispose();
    }).catchError((e) {
      print('Error disposing audio player: $e');
      return _audioPlayer.dispose(); // Try to dispose anyway
    });
    super.dispose();
  }

  void _playPause() async {
    try {
      if (!_isPlaying) {
        // Register this player as the active one (stops any other playing audio)
        _audioManager.registerPlayer(_audioPlayer, _playerId);

        if (_position >= _duration && _duration != Duration.zero) {
          // If audio has finished, restart from beginning
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play();
      } else {
        await _audioPlayer.pause();
      }
    } catch (e) {
      print('Error during play/pause: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.inputBgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: _isLoading
          ? const Center(child: LoadingWidget(isTransparent: true,size: 24,))
          : Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: _playPause,
              child: Container(
                margin: const EdgeInsets.only(right: 25.0),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.primary,
                  size: 35,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    Text(
                      '-${(_duration - _position).inMinutes}:${((_duration - _position).inSeconds % 60).toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                SliderTheme(
                  data: const SliderThemeData(
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 4.0,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: 8.0,
                    ),
                    thumbColor: AppColors.primary,
                  ),
                  child: Slider(
                    value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds.toDouble()),
                    max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                    onChanged: (value) async {
                      await _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    activeColor: AppColors.primary,
                    inactiveColor: const Color(0xFFDFDFDF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}