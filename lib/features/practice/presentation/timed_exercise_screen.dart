import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class TimedExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const TimedExerciseScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<TimedExerciseScreen> createState() => _TimedExerciseScreenState();
}

class _TimedExerciseScreenState extends State<TimedExerciseScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  late int _totalDuration;
  late int _remainingSeconds;
  Timer? _countdownTimer;
  bool _isRunning = false;
  bool _isRecording = false;
  int _elapsedSeconds = 0;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _totalDuration = widget.exercise.durationSeconds;
    _remainingSeconds = _totalDuration;
    _startTimer();
  }

  void _startTimer() {
    _isRunning = true;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          // Halfway vibration for split exercises
          if (widget.exercise.splitTimer &&
              _remainingSeconds == (_totalDuration ~/ 2)) {
            HapticFeedback.heavyImpact();
          }
        } else {
          _timerFinished();
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      if (_isRunning) {
        _countdownTimer?.cancel();
        _isRunning = false;
      } else {
        _startTimer();
      }
    });
  }

  void _timerFinished() {
    _countdownTimer?.cancel();
    HapticFeedback.vibrate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Time complete! Great job!'),
        backgroundColor: AppColors.accentGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
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
    _countdownTimer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          exercise: widget.exercise,
          durationSeconds: _elapsedSeconds > 0 ? _elapsedSeconds : 1,
          bpmUsed: 0,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getCurrentPhaseText() {
    if (!widget.exercise.splitTimer) {
      return widget.exercise.instructionDetail ?? widget.exercise.description;
    }
    final half = _totalDuration ~/ 2;
    if (_remainingSeconds > half) {
      return 'PHASE 1 (Active Obstruction / Focus):\n${widget.exercise.promptLines.isNotEmpty ? widget.exercise.promptLines[0] : "Focus on articulation strength."}';
    } else {
      return 'PHASE 2 (Release & Free Phonation):\n${widget.exercise.promptLines.length > 2 ? widget.exercise.promptLines[2] : "Remove obstacle. Read with effortless flow."}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _totalDuration > 0
        ? (_totalDuration - _remainingSeconds) / _totalDuration
        : 1.0;
    final isBreathwork =
        widget.exercise.category == ExerciseCategory.breathSupport;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Technique Info',
            onPressed: () => _showRationaleBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Circular Countdown Timer
            Expanded(
              flex: 4,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isBreathwork
                              ? AppColors.accentTeal
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_remainingSeconds),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _remainingSeconds == 0
                              ? 'COMPLETE'
                              : (_isRunning ? 'PRACTICING' : 'PAUSED'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: _remainingSeconds == 0
                                ? AppColors.accentGreen
                                : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          icon: Icon(
                            _isRunning
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: isBreathwork
                                ? AppColors.accentTeal
                                : AppColors.primary,
                            size: 36,
                          ),
                          onPressed: _togglePause,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Instruction & Phase Card
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfaceVariant),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.exercise.splitTimer
                                  ? Icons.swap_horiz
                                  : Icons.lightbulb_outline,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Instruction & Focus',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _getCurrentPhaseText(),
                          style: AppTypography.bodyLarge,
                        ),
                        if (widget.exercise.safetyNote != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentAmber.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.exercise.safetyNote!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.accentAmber,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Recording & Completion Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 12),
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

  void _showRationaleBottomSheet(BuildContext context) {
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
              const Text('Clinical Strategy', style: AppTypography.titleLarge),
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
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(tip, style: AppTypography.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
