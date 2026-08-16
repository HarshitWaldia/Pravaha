import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/models/practice_session_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SessionSummaryScreen extends StatefulWidget {
  final Exercise exercise;
  final int durationSeconds;
  final int bpmUsed;
  final String? audioPath;

  const SessionSummaryScreen({
    super.key,
    required this.exercise,
    required this.durationSeconds,
    required this.bpmUsed,
    this.audioPath,
  });

  @override
  State<SessionSummaryScreen> createState() => _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends State<SessionSummaryScreen> {
  final AudioService _audioService = AudioService();
  double _tensionRating = 2.0; // 1 (Relaxed) to 5 (Tense)
  double _confidenceRating = 4.0; // 1 (Low) to 5 (High)
  final TextEditingController _notesController = TextEditingController();
  bool _isPlayingAudio = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _audioService.player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (widget.audioPath == null) return;
    if (_isPlayingAudio) {
      await _audioService.stopAudio();
      setState(() => _isPlayingAudio = false);
    } else {
      await _audioService.playAudio(widget.audioPath!);
      setState(() => _isPlayingAudio = true);
    }
  }

  Future<void> _saveSession() async {
    setState(() => _isSaving = true);
    final storage = await StorageService.getInstance();

    final session = PracticeSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      exerciseId: widget.exercise.id,
      exerciseTitle: widget.exercise.title,
      timestamp: DateTime.now(),
      durationSeconds: widget.durationSeconds,
      bpmUsed: widget.bpmUsed,
      audioFilePath: widget.audioPath,
      tensionRating: _tensionRating.round(),
      confidenceRating: _confidenceRating.round(),
      notes: _notesController.text.trim(),
    );

    await storage.saveSession(session);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session saved to your progress history!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Summary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.accentTeal, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Completed ${widget.durationSeconds}s Practice',
                      style: const TextStyle(
                        color: AppColors.accentTeal,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.exercise.title,
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Audio Playback Section (if recorded)
            if (widget.audioPath != null && File(widget.audioPath!).existsSync()) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Listen to Your Voice',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Notice smooth transitions and relaxed pauses without judging yourself.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: _toggleAudio,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: Icon(
                            _isPlayingAudio ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            _isPlayingAudio ? 'Playing recording...' : 'Tap to play recording',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Self-Assessment: Tension Rating
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Physical Throat & Chest Tension',
                        style: AppTypography.titleMedium,
                      ),
                      Text(
                        _tensionRating == 1
                            ? 'Very Calm (1/5)'
                            : _tensionRating <= 3
                                ? 'Mild (3/5)'
                                : 'High Tension (5/5)',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _tensionRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: (val) => setState(() => _tensionRating = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Self-Assessment: Confidence Rating
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Felt Confidence & Ease',
                        style: AppTypography.titleMedium,
                      ),
                      Text(
                        '${_confidenceRating.round()} / 5',
                        style: const TextStyle(
                          color: AppColors.accentTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _confidenceRating,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    activeColor: AppColors.accentTeal,
                    onChanged: (val) => setState(() => _confidenceRating = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reflection Notes
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add private reflection notes (optional)...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.surfaceVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.surfaceVariant),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveSession,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save to History & Finish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
