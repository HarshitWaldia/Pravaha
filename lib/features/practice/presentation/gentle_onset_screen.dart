import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class GentleOnsetScreen extends StatefulWidget {
  final Exercise exercise;

  const GentleOnsetScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<GentleOnsetScreen> createState() => _GentleOnsetScreenState();
}

class _GentleOnsetScreenState extends State<GentleOnsetScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  late AnimationController _animController;
  late Animation<double> _breathAnimation;
  int _currentPromptIndex = 0;
  bool _isRecording = false;
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;
  String? _recordedAudioPath;
  String _breathPhaseText = 'Inhale Gently (2s)';

  @override
  void initState() {
    super.initState();
    _startSessionTimer();

    // 4-second breathing and voicing cycle: 2s inhale, 2s gentle voicing exhalation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _breathAnimation = Tween<double>(begin: 0.7, end: 1.3).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.addListener(() {
      if (_animController.value < 0.5) {
        if (_breathPhaseText != 'Inhale Slowly through Diaphragm') {
          setState(() => _breathPhaseText = 'Inhale Slowly through Diaphragm');
        }
      } else {
        if (_breathPhaseText != 'Gentle Voicing Onset (Easy Start)') {
          setState(() => _breathPhaseText = 'Gentle Voicing Onset (Easy Start)');
        }
      }
    });

    _animController.repeat(reverse: true);
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
    _animController.dispose();
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
        setState(() => _isRecording = true);
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
          bpmUsed: 60,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  void _nextPrompt() {
    setState(() {
      _currentPromptIndex =
          (_currentPromptIndex + 1) % widget.exercise.promptLines.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentText = widget.exercise.promptLines[_currentPromptIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gentle Voicing Onset'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              _breathPhaseText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.accentTeal,
              ),
            ),
            const SizedBox(height: 20),

            // Animated Breathing & Phonation Wave
            Expanded(
              flex: 4,
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, child) {
                  return Center(
                    child: Container(
                      width: 180 * _breathAnimation.value,
                      height: 180 * _breathAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.breathGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentTeal.withAlpha(60),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.air,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Exercise Prompt
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
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Start with a soft sigh of air before the word:',
                            style: AppTypography.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentText,
                            style: AppTypography.practiceText.copyWith(
                              fontSize: currentText.length > 35 ? 18 : 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: TextButton.icon(
                onPressed: _nextPrompt,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next Prompt'),
              ),
            ),

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
