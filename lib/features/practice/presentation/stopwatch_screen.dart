import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class StopwatchScreen extends StatefulWidget {
  final Exercise exercise;

  const StopwatchScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final AudioService _audioService = AudioService();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  int _personalBestSeconds = 0;
  bool _isRecording = false;
  String? _recordedAudioPath;

  @override
  void initState() {
    super.initState();
    _loadPersonalBest();
  }

  Future<void> _loadPersonalBest() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _personalBestSeconds =
          prefs.getInt('pb_${widget.exercise.id}') ?? 0;
    });
  }

  Future<void> _savePersonalBestIfExceeded(int seconds) async {
    if (seconds > _personalBestSeconds) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('pb_${widget.exercise.id}', seconds);
      setState(() {
        _personalBestSeconds = seconds;
      });
      HapticFeedback.vibrate();
    }
  }

  void _toggleStartStop() {
    HapticFeedback.mediumImpact();
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
        final currentSecs = _stopwatch.elapsed.inSeconds;
        _savePersonalBestIfExceeded(currentSecs);
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
          if (mounted) setState(() {});
        });
      }
    });
  }

  void _resetStopwatch() {
    HapticFeedback.lightImpact();
    setState(() {
      _stopwatch.reset();
      if (!_stopwatch.isRunning) {
        _timer?.cancel();
      }
    });
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
    _stopwatch.stop();
    _timer?.cancel();
    final secs = _stopwatch.elapsed.inSeconds;
    _savePersonalBestIfExceeded(secs);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          exercise: widget.exercise,
          durationSeconds: secs > 0 ? secs : 1,
          bpmUsed: 0,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  String _formatElapsed() {
    final ms = _stopwatch.elapsed.inMilliseconds;
    final hundreds = (ms ~/ 10) % 100;
    final secs = (ms ~/ 1000) % 60;
    final mins = (ms ~/ 60000);
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${hundreds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _stopwatch.isRunning;

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

            // Personal Best Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentAmber.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accentAmber.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.accentAmber, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Personal Best: ${_personalBestSeconds}s',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentAmber,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Large Digital Stopwatch Display
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatElapsed(),
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        color: AppColors.primary,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isRunning ? 'AIRFLOW ACTIVE' : 'TAP TO BEGIN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isRunning ? AppColors.accentGreen : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _toggleStartStop,
                          icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                          label: Text(isRunning ? 'STOP' : 'START'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning ? AppColors.accentCoral : AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton.outlined(
                          onPressed: _resetStopwatch,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Reset',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Instruction & Safety Card
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
                        const Row(
                          children: [
                            Icon(Icons.air, color: AppColors.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Airflow Challenge',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.exercise.instructionDetail ?? widget.exercise.description,
                          style: AppTypography.bodyMedium,
                        ),
                        if (widget.exercise.safetyNote != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.accentAmber.withAlpha(20),
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
