import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class AlphaGridScreen extends StatefulWidget {
  final Exercise exercise;

  const AlphaGridScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<AlphaGridScreen> createState() => _AlphaGridScreenState();
}

class _AlphaGridScreenState extends State<AlphaGridScreen> {
  final AudioService _audioService = AudioService();
  final List<String> _alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  final Set<String> _foundLetters = {};
  final Set<String> _skippedLetters = {};
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

  void _toggleLetter(String letter) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_foundLetters.contains(letter)) {
        _foundLetters.remove(letter);
      } else {
        _foundLetters.add(letter);
        _skippedLetters.remove(letter);
      }
    });
  }

  void _skipNextLetter() {
    for (final l in _alphabet) {
      if (!_foundLetters.contains(l) && !_skippedLetters.contains(l)) {
        HapticFeedback.mediumImpact();
        setState(() => _skippedLetters.add(l));
        break;
      }
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
    final completedCount = _foundLetters.length;
    final progress = completedCount / _alphabet.length;

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
            const SizedBox(height: 12),

            // Top Status & Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found: $completedCount / ${_alphabet.length} Letters',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _skipNextLetter,
                    icon: const Icon(Icons.skip_next, size: 16),
                    label: const Text('Skip Letter', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // A-Z Grid
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _alphabet.length,
                  itemBuilder: (context, index) {
                    final letter = _alphabet[index];
                    final isFound = _foundLetters.contains(letter);
                    final isSkipped = _skippedLetters.contains(letter);

                    Color bg = AppColors.surface;
                    Color border = AppColors.surfaceVariant;
                    Color text = AppColors.textPrimary;

                    if (isFound) {
                      bg = AppColors.accentGreen;
                      border = AppColors.accentGreen;
                      text = Colors.white;
                    } else if (isSkipped) {
                      bg = AppColors.surfaceVariant.withAlpha(80);
                      text = AppColors.textTertiary;
                    }

                    return InkWell(
                      onTap: () => _toggleLetter(letter),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Center(
                          child: Text(
                            letter,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: text,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Instruction Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text(
                'Scan the room. Name an object starting with each letter out loud, then tap it.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall,
              ),
            ),

            // Recording & Completion Bar
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
