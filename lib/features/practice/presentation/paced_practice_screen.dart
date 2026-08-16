import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';
import 'widgets/pacer_visualizer.dart';

class PacedPracticeScreen extends StatefulWidget {
  final Exercise exercise;

  const PacedPracticeScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<PacedPracticeScreen> createState() => _PacedPracticeScreenState();
}

class _PacedPracticeScreenState extends State<PacedPracticeScreen> {
  final AudioService _audioService = AudioService();
  late int _bpm;
  int _currentPromptIndex = 0;
  bool _isRecording = false;
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _bpm = widget.exercise.defaultBpm;
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioService.stopRecording();
      setState(() {
        _isRecording = false;
        _recordedAudioPath = path;
      });
      _finishPractice();
    } else {
      final started = await _audioService.startRecording();
      if (started) {
        setState(() {
          _isRecording = true;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission required for audio practice.'),
              backgroundColor: AppColors.accentCoral,
            ),
          );
        }
      }
    }
  }

  void _finishPractice() {
    _sessionTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          exercise: widget.exercise,
          durationSeconds: _elapsedSeconds > 0 ? _elapsedSeconds : 1,
          bpmUsed: _bpm,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  void _nextPrompt() {
    if (_currentPromptIndex < widget.exercise.promptLines.length - 1) {
      setState(() => _currentPromptIndex++);
    } else {
      setState(() => _currentPromptIndex = 0);
    }
  }

  void _prevPrompt() {
    if (_currentPromptIndex > 0) {
      setState(() => _currentPromptIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentText = widget.exercise.promptLines[_currentPromptIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Clinical Strategy',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Technique Tips',
                          style: AppTypography.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.exercise.clinicalRationale,
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        ...widget.exercise.tips.map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                Expanded(child: Text(tip, style: AppTypography.bodyMedium)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Visual Rhythmic Pacer Bubble
            Expanded(
              flex: 4,
              child: PacerVisualizer(
                bpm: _bpm,
                isPlaying: true,
              ),
            ),

            // BPM Controller Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  const Text('Pace', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  Expanded(
                    child: Slider(
                      value: _bpm.toDouble(),
                      min: 40,
                      max: 120,
                      divisions: 16,
                      label: '$_bpm BPM',
                      onChanged: (val) => setState(() => _bpm = val.round()),
                    ),
                  ),
                  Text('$_bpm BPM', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Prompt Card
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Line ${_currentPromptIndex + 1} of ${widget.exercise.promptLines.length}',
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentText,
                            textAlign: TextAlign.center,
                            style: AppTypography.practiceTextPaced.copyWith(
                              fontSize: currentText.length > 40 ? 19 : 22,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            // Navigation Arrows for Prompt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentPromptIndex > 0 ? _prevPrompt : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                  TextButton.icon(
                    onPressed: _nextPrompt,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Line'),
                  ),
                ],
              ),
            ),

            // Bottom Audio Controls Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: AudioRecorderBar(
                isRecording: _isRecording,
                onToggleRecord: _toggleRecording,
                onReset: _finishPractice,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
