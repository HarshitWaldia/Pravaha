import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/data/sound_word_database.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class WordProgressionScreen extends StatefulWidget {
  final SoundModule soundModule;

  const WordProgressionScreen({
    super.key,
    required this.soundModule,
  });

  @override
  State<WordProgressionScreen> createState() => _WordProgressionScreenState();
}

class _WordProgressionScreenState extends State<WordProgressionScreen> {
  final AudioService _audioService = AudioService();
  int _currentWordIndex = 0;
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;
  bool _isRecording = false;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _goToWord(int index) {
    if (index >= 0 && index < widget.soundModule.wordDrills.length) {
      HapticFeedback.lightImpact();
      setState(() => _currentWordIndex = index);
    }
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
    final dummyExercise = Exercise(
      id: 'sound_${widget.soundModule.soundKey.toLowerCase()}',
      title: '${widget.soundModule.title} Phonetic Ladder',
      description: widget.soundModule.mechanicsFocus,
      clinicalRationale: widget.soundModule.description,
      category: ExerciseCategory.articulation,
      difficulty: ExerciseDifficulty.intermediate,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          exercise: dummyExercise,
          durationSeconds: _elapsedSeconds > 0 ? _elapsedSeconds : 1,
          bpmUsed: 0,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drills = widget.soundModule.wordDrills;
    final currentDrill = drills[_currentWordIndex];
    final progress = (drills.isNotEmpty) ? (_currentWordIndex + 1) / drills.length : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.soundModule.title} Progression'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Phonetic Class Info',
            onPressed: () => _showPhoneticInfo(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Ladder Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Target ${_currentWordIndex + 1} of ${drills.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentTeal.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentDrill.progressionLabel,
                      style: const TextStyle(
                        color: AppColors.accentTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Giant Phonetic Hero Card
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentDrill.targetWord,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          currentDrill.phoneticBreakdown,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentDrill.engineInstruction,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Clinical Strategy Box
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withAlpha(50),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.accentAmber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          currentDrill.clinicalTip,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Next / Prev Ladder Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _currentWordIndex > 0
                        ? () => _goToWord(_currentWordIndex - 1)
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous Word'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _currentWordIndex < drills.length - 1
                        ? () => _goToWord(_currentWordIndex + 1)
                        : _finishPractice,
                    icon: Icon(_currentWordIndex < drills.length - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_currentWordIndex < drills.length - 1
                        ? 'Next Word'
                        : 'Complete Ladder'),
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

  void _showPhoneticInfo(BuildContext context) {
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
              Text(
                '${widget.soundModule.title} (${widget.soundModule.phoneticClass})',
                style: AppTypography.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(widget.soundModule.description, style: AppTypography.bodyMedium),
              const SizedBox(height: 16),
              const Text('Anatomical Focus:', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(widget.soundModule.mechanicsFocus, style: AppTypography.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}
