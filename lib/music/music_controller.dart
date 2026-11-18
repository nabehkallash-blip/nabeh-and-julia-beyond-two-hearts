import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// A quiet, original ambient piece generated locally so the game has no
/// dependency on a loud placeholder soundtrack.
class MusicController {
  static final AudioPlayer _player = AudioPlayer();
  static final ValueNotifier<bool> enabled = ValueNotifier<bool>(true);
  static bool _started = false;

  static Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.22);
      await _player.play(BytesSource(_makeCalmTrack()));
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

  static Uint8List _makeCalmTrack() {
    const sampleRate = 22050;
    const seconds = 24;
    const channels = 1;
    const bitsPerSample = 16;
    const sampleCount = sampleRate * seconds;
    final dataLength = sampleCount * channels * bitsPerSample ~/ 8;
    final bytes = ByteData(44 + dataLength);

    void writeText(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        bytes.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    writeText(0, 'RIFF');
    bytes.setUint32(4, 36 + dataLength, Endian.little);
    writeText(8, 'WAVE');
    writeText(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, channels, Endian.little);
    bytes.setUint32(24, sampleRate, Endian.little);
    bytes.setUint32(28, sampleRate * channels * bitsPerSample ~/ 8, Endian.little);
    bytes.setUint16(32, channels * bitsPerSample ~/ 8, Endian.little);
    bytes.setUint16(34, bitsPerSample, Endian.little);
    writeText(36, 'data');
    bytes.setUint32(40, dataLength, Endian.little);

    // A slow four-chord progression with a soft plucked-piano-like melody.
    const chords = [
      [130.81, 164.81, 196.00],
      [110.00, 130.81, 164.81],
      [87.31, 110.00, 130.81],
      [98.00, 123.47, 146.83],
    ];
    const melody = [261.63, 293.66, 329.63, 392.00, 349.23, 329.63, 293.66, 261.63];
    for (var i = 0; i < sampleCount; i++) {
      final t = i / sampleRate;
      final chordIndex = (t ~/ 6) % chords.length;
      final chord = chords[chordIndex];
      var value = 0.0;
      for (final frequency in chord) {
        value += math.sin(2 * math.pi * frequency * t) * 0.075;
        value += math.sin(2 * math.pi * frequency * 2 * t) * 0.012;
      }
      final noteSlot = (t ~/ 1.5) % melody.length;
      final noteTime = t % 1.5;
      final noteEnvelope = math.exp(-noteTime * 2.3) * (1 - math.exp(-noteTime * 45));
      value += math.sin(2 * math.pi * melody[noteSlot] * noteTime) * noteEnvelope * 0.12;
      final fadeIn = (t / 2).clamp(0.0, 1.0);
      final fadeOut = ((seconds - t) / 2).clamp(0.0, 1.0);
      value *= math.min(fadeIn, fadeOut);
      final sample = (value.clamp(-0.95, 0.95) * 32767).round();
      bytes.setInt16(44 + i * 2, sample, Endian.little);
    }
    return bytes.buffer.asUint8List();
  }

  static Future<void> dispose() async {
    await _player.dispose();
    _started = false;
  }
}
