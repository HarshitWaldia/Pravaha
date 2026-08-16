import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class RepCounterScreen extends StatefulWidget {
  final Exercise exercise;

  const RepCounterScreen({
    super.key,
    required this.exercise,
  });

  @override
  State<RepCounterScreen> createState() => _RepCounterScreenState();
}

class _RepCounterScreenState extends State<RepCounterScreen>
    with SingleTickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  int _currentReps = 0;
  late int _targetReps;
  int _elapsedSeconds = 0;
  Timer? _sessionTimer;
  bool _isRecording = false;
  String? _recordedAudioPath;

  // Hold & Release State
  bool _isHolding = false;
  int _holdTimeRemaining = 0;
  Timer? _holdReleaseTimer;

  // 5-Attribute checkboxes state
  final List<bool> _attributeChecked = [false, false, false, false, false];
  final List<String> _attributeLabels = [
    '1. Material (e.g. ceramic, metal, wood)',
    '2. Color (e.g. navy-blue, emerald)',
    '3. Shape (e.g. cylindrical, rectangular)',
    '4. Weight / Size (e.g. heavy, compact)',
    '5. Function / Purpose (e.g. drinking tea)',
  ];

  @override
  void initState() {
    super.initState();
    _targetReps = widget.exercise.repTarget ?? 10;
    _startSessionTimer();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _holdReleaseTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _incrementRep() {
    if (_currentReps < _targetReps) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentReps++;
      });
      if (_currentReps == _targetReps) {
        HapticFeedback.vibrate();
      }
    }
  }

  void _startHoldCycle() {
    if (_holdReleaseTimer != null && _holdReleaseTimer!.isActive) return;

    final holdSecs = widget.exercise.holdSeconds ?? 5;
    final restSecs = widget.exercise.restSeconds ?? 2;

    setState(() {
      _isHolding = true;
      _holdTimeRemaining = holdSecs;
    });
    HapticFeedback.heavyImpact();

    _holdReleaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_isHolding) {
          if (_holdTimeRemaining > 1) {
            _holdTimeRemaining--;
          } else {
            // Switch to Rest phase
            _isHolding = false;
            _holdTimeRemaining = restSecs;
            _currentReps++;
            HapticFeedback.mediumImpact();
            if (_currentReps >= _targetReps) {
              timer.cancel();
              HapticFeedback.vibrate();
            }
          }
        } else {
          if (_holdTimeRemaining > 1) {
            _holdTimeRemaining--;
          } else {
            // Start next hold if reps remain
            if (_currentReps < _targetReps) {
              _isHolding = true;
              _holdTimeRemaining = holdSecs;
              HapticFeedback.heavyImpact();
            } else {
              timer.cancel();
            }
          }
        }
      });
    });
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
    _holdReleaseTimer?.cancel();
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
    final isHoldMode = widget.exercise.exerciseType == ExerciseType.holdRelease;
    final isFiveAttrMode =
        widget.exercise.exerciseType == ExerciseType.fiveAttribute;
    final progress = _targetReps > 0 ? _currentReps / _targetReps : 0.0;

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

            // Top Rep Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: $_currentReps / $_targetReps ${isHoldMode ? "Cycles" : "Reps"}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
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
                  minHeight: 8,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _currentReps >= _targetReps
                        ? AppColors.accentGreen
                        : AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Main Interactive Section
            Expanded(
              flex: 4,
              child: Center(
                child: isFiveAttrMode
                    ? _buildFiveAttributeList()
                    : (isHoldMode
                        ? _buildHoldReleaseButton()
                        : _buildTapCounterButton()),
              ),
            ),

            // Prompt & Guidance Card
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
                            const Icon(
                              Icons.accessibility_new,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Target Mechanics',
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
                          widget.exercise.instructionDetail ??
                              widget.exercise.description,
                          style: AppTypography.bodyMedium,
                        ),
                        if (widget.exercise.promptLines.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.exercise.promptLines
                                  .map(
                                    (line) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        line,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
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

  Widget _buildTapCounterButton() {
    return GestureDetector(
      onTap: _incrementRep,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 190,
        height: 190,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.pacerGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(60),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_currentReps',
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const Text(
              'TAP TO LOG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoldReleaseButton() {
    final isTimerActive =
        _holdReleaseTimer != null && _holdReleaseTimer!.isActive;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: isTimerActive ? null : _startHoldCycle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !isTimerActive
                  ? AppColors.primary
                  : (_isHolding ? AppColors.accentGreen : AppColors.secondary),
              boxShadow: [
                BoxShadow(
                  color: (!isTimerActive
                          ? AppColors.primary
                          : (_isHolding
                              ? AppColors.accentGreen
                              : AppColors.secondary))
                      .withAlpha(80),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isTimerActive) ...[
                  const Icon(Icons.play_arrow, size: 48, color: Colors.white),
                  const SizedBox(height: 4),
                  const Text(
                    'START CYCLE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ] else ...[
                  Text(
                    '$_holdTimeRemaining',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _isHolding ? 'HOLD TENSION' : 'RELEASE & REST',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isTimerActive
              ? (_isHolding ? 'Squeeze & hold firm' : 'Breathe & completely relax')
              : 'Tap above to start automatic hold-release cycles',
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }

  Widget _buildFiveAttributeList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _attributeLabels.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            color: _attributeChecked[index]
                ? AppColors.accentGreen.withAlpha(20)
                : AppColors.surface,
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: _attributeChecked[index]
                    ? AppColors.accentGreen
                    : AppColors.surfaceVariant,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                _attributeLabels[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _attributeChecked[index]
                      ? AppColors.accentGreen
                      : AppColors.textPrimary,
                ),
              ),
              value: _attributeChecked[index],
              activeColor: AppColors.accentGreen,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                setState(() {
                  _attributeChecked[index] = val ?? false;
                  _currentReps = _attributeChecked.where((b) => b).length;
                });
              },
            ),
          );
        },
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
