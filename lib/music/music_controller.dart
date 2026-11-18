import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class MusicController {
  static final AudioPlayer _player = AudioPlayer();
  static final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);
  static bool _started = false;

  static Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.28);
      await _player.play(AssetSource('audio/main_theme.wav'));
    } catch (_) {
      _started = false;
    }
  }

  static Future<void> toggle() async {
    enabled.value = !enabled.value;
    if (enabled.value) {
      if (_started) {
        await _player.resume();
      } else {
        await start();
      }
    } else {
      await _player.pause();
    }
  }

  static Future<void> dispose() async {
    await _player.dispose();
    _started = false;
  }
}
