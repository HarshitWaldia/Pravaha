import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class StepperExerciseScreen extends StatefulWidget {
  final Exercise exercise;

  const StepperExerciseScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<StepperExerciseScreen> createState() => _StepperExerciseScreenState();
}

class _StepperExerciseScreenState extends State<StepperExerciseScreen> {
  final AudioService _audioService = AudioService();
  int _currentStageIndex = 0;
  late int _totalStages;
  int _stageSecondsRemaining = 10;
  int _elapsedSeconds = 0;
  Timer? _timer;
  bool _isAutoTimerRunning = true;
  bool _isRecording = false;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _totalStages = widget.exercise.stageTitles?.length ??
        (widget.exercise.stagePrompts?.length ?? 4);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _elapsedSeconds++;
        if (_isAutoTimerRunning) {
          if (_stageSecondsRemaining > 1) {
            _stageSecondsRemaining--;
          } else {
            // Auto advance stage
            if (_currentStageIndex < _totalStages - 1) {
              _currentStageIndex++;
              _stageSecondsRemaining = 10;
              HapticFeedback.heavyImpact();
            } else {
              _isAutoTimerRunning = false;
              HapticFeedback.vibrate();
            }
          }
        }
      });
    });
  }

  void _goToStage(int index) {
    if (index >= 0 && index < _totalStages) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentStageIndex = index;
        _stageSecondsRemaining = 10;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    _timer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    final stages = widget.exercise.stageTitles ?? [];
    final prompts = widget.exercise.stagePrompts ?? [];
    final currentTitle =
        _currentStageIndex < stages.length ? stages[_currentStageIndex] : 'Stage ${_currentStageIndex + 1}';
    final currentPrompt =
        _currentStageIndex < prompts.length ? prompts[_currentStageIndex] : '';

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
            const SizedBox(height: 16),

            // Horizontal Stepper Dots
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_totalStages, (index) {
                  final isDone = index < _currentStageIndex;
                  final isCurrent = index == _currentStageIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _goToStage(index),
                      child: Container(
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isCurrent
                              ? AppColors.primary
                              : (isDone ? AppColors.accentGreen : AppColors.surfaceVariant),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // Active Stage Hero Display
            Expanded(
              flex: 4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'STAGE ${_currentStageIndex + 1} OF $_totalStages',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceVariant),
                        ),
                        child: Text(
                          currentPrompt,
                          textAlign: TextAlign.center,
                          style: AppTypography.practiceTextPaced.copyWith(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isAutoTimerRunning)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer, size: 16, color: AppColors.textTertiary),
                            const SizedBox(width: 6),
                            Text(
                              'Next in ${_stageSecondsRemaining}s',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Stage Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentStageIndex > 0
                        ? () => _goToStage(_currentStageIndex - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentStageIndex < _totalStages - 1
                        ? () => _goToStage(_currentStageIndex + 1)
                        : _finishPractice,
                    icon: Icon(_currentStageIndex < _totalStages - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_currentStageIndex < _totalStages - 1
                        ? 'Next Stage'
                        : 'Finish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
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
  }
}
