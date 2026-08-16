import 'package:flutter/material.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/models/scenario_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'session_summary_screen.dart';
import 'widgets/audio_recorder_bar.dart';

class ScenarioPracticeScreen extends StatefulWidget {
  final SpeakingScenario scenario;

  const ScenarioPracticeScreen({
    super.key,
    required this.scenario,
  });

  @override
  State<ScenarioPracticeScreen> createState() => _ScenarioPracticeScreenState();
}

class _ScenarioPracticeScreenState extends State<ScenarioPracticeScreen> {
  final AudioService _audioService = AudioService();
  int _currentStepIndex = 0;
  bool _isRecording = false;
  String? _recordedAudioPath;

  @override
  void dispose() {
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
    } else {
      final started = await _audioService.startRecording();
      if (started) {
        setState(() => _isRecording = true);
      }
    }
  }

  void _finishScenario() {
    final mockExercise = Exercise(
      id: widget.scenario.id,
      title: widget.scenario.title,
      description: widget.scenario.contextDescription,
      clinicalRationale: 'Real-world communicative confidence and desensitization.',
      category: ExerciseCategory.scenario,
      difficulty: ExerciseDifficulty.intermediate,
      promptLines: widget.scenario.steps.map((s) => s.userTargetResponse).toList(),
      tips: ['Maintain eye contact', 'Use natural pauses', 'Own your speaking time'],
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => SessionSummaryScreen(
          exercise: mockExercise,
          durationSeconds: 120,
          bpmUsed: 75,
          audioPath: _recordedAudioPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.scenario.steps[_currentStepIndex];
    final isLastStep = _currentStepIndex == widget.scenario.steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Turn ${_currentStepIndex + 1} of ${widget.scenario.steps.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    widget.scenario.category,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStepIndex + 1) / widget.scenario.steps.length,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),

              // Conversation Bubble: Other Speaker
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withAlpha(120),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 18, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          step.speakerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '"${step.speakerPrompt}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSecondaryContainer,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // User's Turn Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withAlpha(60), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.record_voice_over, size: 18, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Your Suggested Response:',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      step.userTargetResponse,
                      style: AppTypography.practiceText,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withAlpha(100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.accentAmber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              step.speechStrategyTip,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Audio Controls & Next Step
              Center(
                child: AudioRecorderBar(
                  isRecording: _isRecording,
                  onToggleRecord: _toggleRecording,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isLastStep) {
                      _finishScenario();
                    } else {
                      setState(() => _currentStepIndex++);
                    }
                  },
                  child: Text(isLastStep ? 'Finish Scenario' : 'Next Dialogue Turn'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
