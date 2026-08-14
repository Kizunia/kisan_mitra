import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Service for recording audio via the device microphone.
///
/// Provides start/stop recording, real-time amplitude streaming for
/// waveform visualization, permission handling, and background noise detection.
class AudioRecordService {
  AudioRecorder _recorder = AudioRecorder();

  /// Stream controller for amplitude values (dBFS, typically -160 to 0).
  StreamController<double>? _amplitudeController;
  Timer? _amplitudeTimer;

  /// Whether we are currently recording.
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// Path to the last recorded file.
  String? _lastRecordingPath;
  String? get lastRecordingPath => _lastRecordingPath;

  /// Minimum required recording duration in seconds.
  static const int minDurationSec = 5;

  /// Maximum recording duration in seconds.
  static const int maxDurationSec = 10;

  /// Amplitude threshold below which we consider background noise too low
  /// (i.e., no real tap detected). In dBFS (closer to 0 = louder).
  static const double _noiseFloorDb = -65.0;

  // ─── Permission ──────────────────────────────────────────────────────

  /// Check if microphone permission is granted.
  Future<bool> hasPermission() async {
    try {
      return await _recorder.hasPermission();
    } catch (e) {
      debugPrint('AudioRecordService: hasPermission error: $e');
      try { await _recorder.dispose(); } catch (_) {}
      _recorder = AudioRecorder();
      return await _recorder.hasPermission();
    }
  }

  /// Request microphone permission. Returns true if granted.
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  // ─── Recording ───────────────────────────────────────────────────────

  /// Start recording audio. Returns a stream of amplitude values for
  /// waveform animation.
  ///
  /// The audio is saved as PCM WAV (16-bit, 44100 Hz, mono) so we can
  /// process the raw samples later.
  Future<Stream<double>> startRecording() async {
    if (_isRecording) {
      throw StateError('Already recording');
    }

    // Ensure permission
    final permitted = await hasPermission();
    if (!permitted) {
      final granted = await requestPermission();
      if (!granted) {
        throw PermissionDeniedException('Microphone permission denied');
      }
    }

    // Prepare file path
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/soil_recording_${DateTime.now().millisecondsSinceEpoch}.wav';

    // Configure recording: WAV format, 44100 Hz, mono
    const config = RecordConfig(
      encoder: AudioEncoder.wav,
      sampleRate: 44100,
      numChannels: 1,
      bitRate: 128000,
    );

    try {
      await _recorder.start(config, path: filePath);
    } catch (e) {
      debugPrint('AudioRecordService: start failed, recreating recorder. Error: $e');
      try { await _recorder.dispose(); } catch (_) {}
      _recorder = AudioRecorder();
      await _recorder.start(config, path: filePath);
    }

    _isRecording = true;
    _lastRecordingPath = filePath;

    // Set up amplitude streaming
    _amplitudeController = StreamController<double>.broadcast();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (
      _,
    ) async {
      try {
        final amp = await _recorder.getAmplitude();
        if (!(_amplitudeController?.isClosed ?? true)) {
          // amp.current is in dBFS (negative, 0 = max)
          _amplitudeController!.add(amp.current);
        }
      } catch (_) {
        // Recorder may have been stopped
      }
    });

    return _amplitudeController!.stream;
  }

  /// Stop recording and return the file path.
  ///
  /// Throws if not currently recording.
  Future<String> stopRecording() async {
    if (!_isRecording) {
      throw StateError('Not recording');
    }

    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    _amplitudeController?.close();
    _amplitudeController = null;

    String? path;
    try {
      path = await _recorder.stop();
    } catch (e) {
      debugPrint('AudioRecordService: stop failed. Error: $e');
      try { await _recorder.dispose(); } catch (_) {}
      _recorder = AudioRecorder();
    }
    
    _isRecording = false;

    return path ?? _lastRecordingPath!;
  }

  /// Cancel an in-progress recording and delete the file.
  Future<void> cancelRecording() async {
    if (_isRecording) {
      await stopRecording();
    }
    await deleteRecording();
  }

  // ─── Validation ──────────────────────────────────────────────────────

  /// Check if background noise is too high or signal too low.
  /// Returns true if the average amplitude indicates a valid tap was captured.
  ///
  /// [amplitudes] is a list of dBFS values collected during recording.
  bool isSignalValid(List<double> amplitudes) {
    if (amplitudes.isEmpty) return false;

    // Find the peak amplitude (closest to 0 = loudest)
    final peak = amplitudes.reduce((a, b) => a > b ? a : b);

    // If the loudest sample is below our noise floor, there's no real signal
    return peak > _noiseFloorDb;
  }

  // ─── Cleanup ─────────────────────────────────────────────────────────

  /// Delete the last recorded file from disk.
  Future<void> deleteRecording() async {
    if (_lastRecordingPath != null) {
      try {
        final file = File(_lastRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('AudioRecordService: Failed to delete recording: $e');
      }
      _lastRecordingPath = null;
    }
  }

  /// Release all resources.
  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    _amplitudeController?.close();
    if (_isRecording) {
      try {
        await _recorder.stop();
      } catch (_) {}
    }
    _recorder.dispose();
  }
}

/// Exception for when microphone permission is denied.
class PermissionDeniedException implements Exception {
  final String message;
  const PermissionDeniedException(this.message);

  @override
  String toString() => 'PermissionDeniedException: $message';
}
