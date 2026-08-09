import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service handling encrypted background audio evidence recording
/// during an active SOS emergency. Saves locally to app-private dir.
class AudioEvidenceService {
  static final AudioRecorder _recorder = AudioRecorder();
  static String? _currentRecordingPath;
  static bool _isRecording = false;

  static bool get isRecording => _isRecording;
  static String? get currentRecordingPath => _currentRecordingPath;

  /// Request microphone permission (call early, e.g. on SOS trigger)
  static Future<bool> requestMicPermission() async {
    if (kIsWeb) return false; // Web doesn't support mic via this package
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start recording audio evidence. Saves to app-private directory
  /// as 'sos_evidence_{timestamp}.m4a'.
  static Future<bool> startRecording() async {
    if (kIsWeb) return false;
    if (_isRecording) return true;

    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        final granted = await requestMicPermission();
        if (!granted) return false;
      }

      final dir = await getApplicationDocumentsDirectory();
      final evidenceDir = Directory('${dir.path}/sos_evidence');
      if (!await evidenceDir.exists()) {
        await evidenceDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentRecordingPath = '${evidenceDir.path}/sos_evidence_$timestamp.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
      debugPrint('[AudioEvidence] Recording started: $_currentRecordingPath');
      return true;
    } catch (e) {
      debugPrint('[AudioEvidence] Failed to start recording: $e');
      return false;
    }
  }

  /// Stop the current recording and return the file path.
  static Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    try {
      final path = await _recorder.stop();
      _isRecording = false;
      debugPrint('[AudioEvidence] Recording stopped. File: $path');
      return path ?? _currentRecordingPath;
    } catch (e) {
      debugPrint('[AudioEvidence] Failed to stop recording: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Dispose the recorder (call on app shutdown)
  static Future<void> dispose() async {
    if (_isRecording) {
      await stopRecording();
    }
    _recorder.dispose();
  }
}
