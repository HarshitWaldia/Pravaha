import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AudioService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  bool _isRecording = false;
  String? _currentRecordingPath;

  bool get isRecording => _isRecording;
  String? get currentRecordingPath => _currentRecordingPath;
  AudioPlayer get player => _player;

  /// Request runtime microphone permission
  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Start recording voice to a temporary local file
  Future<bool> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      final granted = await requestMicPermission();
      if (!granted) return false;
    }

    final tempDir = await getApplicationDocumentsDirectory();
    final fileName = 'pravaha_rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final filePath = '${tempDir.path}/$fileName';

    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );

    await _recorder.start(config, path: filePath);
    _isRecording = true;
    _currentRecordingPath = filePath;
    return true;
  }

  /// Stop recording and return the saved audio path
  Future<String?> stopRecording() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _isRecording = false;
    _currentRecordingPath = path;
    return path;
  }

  /// Play audio from local file path
  Future<void> playAudio(String filePath) async {
    if (!File(filePath).existsSync()) return;
    await _player.stop();
    await _player.play(DeviceFileSource(filePath));
  }

  /// Pause current playback
  Future<void> pauseAudio() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resumeAudio() async {
    await _player.resume();
  }

  /// Stop playback
  Future<void> stopAudio() async {
    await _player.stop();
  }

  /// Clean up recorder and player resources
  void dispose() {
    _recorder.dispose();
    _player.dispose();
  }
}
