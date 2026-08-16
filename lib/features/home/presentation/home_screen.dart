import 'package:flutter/material.dart';
import '../../../../core/data/exercise_library.dart';
import '../../../../core/data/sound_word_database.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/models/scenario_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/technique_card.dart';
import '../../practice/presentation/alpha_grid_screen.dart';
import '../../practice/presentation/gentle_onset_screen.dart';
import '../../practice/presentation/paced_practice_screen.dart';
import '../../practice/presentation/rep_counter_screen.dart';
import '../../practice/presentation/scenario_practice_screen.dart';
import '../../practice/presentation/stepper_exercise_screen.dart';
import '../../practice/presentation/stopwatch_screen.dart';
import '../../practice/presentation/timed_exercise_screen.dart';
import '../../practice/presentation/word_progression_screen.dart';


class HomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToLibrary;

  const HomeScreen({
    super.key,
    required this.onNavigateToLibrary,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _streakDays = 1;
  int _todayMinutes = 0;
  int _goalMinutes = 10;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _streakDays = storage.getStreakDays();
      _todayMinutes = storage.getTodayPracticeMinutes();
      _goalMinutes = storage.getDailyGoalMinutes();
      _isLoading = false;
    });
  }

  void _launchExercise(Exercise exercise) {
    Widget screen;
    switch (exercise.exerciseType) {
      case ExerciseType.timer:
        screen = TimedExerciseScreen(exercise: exercise);
        break;
      case ExerciseType.repCounter:
      case ExerciseType.holdRelease:
      case ExerciseType.fiveAttribute:
        screen = RepCounterScreen(exercise: exercise);
        break;
      case ExerciseType.stopwatch:
        screen = StopwatchScreen(exercise: exercise);
        break;
      case ExerciseType.stepper:
        screen = StepperExerciseScreen(exercise: exercise);
        break;
      case ExerciseType.alphaGrid:
        screen = AlphaGridScreen(exercise: exercise);
        break;
      case ExerciseType.textPrompt:
        screen = GentleOnsetScreen(exercise: exercise);
        break;
      case ExerciseType.metronome:
      case ExerciseType.wordProgression:
        screen = PacedPracticeScreen(exercise: exercise);
        break;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => screen))
        .then((_) => _loadProgress());
  }

  void _launchSoundModule(SoundModule soundModule) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WordProgressionScreen(soundModule: soundModule),
      ),
    ).then((_) => _loadProgress());
  }

  void _launchScenario(SpeakingScenario scenario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScenarioPracticeScreen(scenario: scenario),
      ),
    ).then((_) => _loadProgress());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProgress,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pravāha प्रवाहः',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Find your natural speech cadence',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.surfaceVariant),
                            ),
                            child: const Icon(
                              Icons.self_improvement,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Daily Progress & Streak Card
                if (!_isLoading)
                  DailyGoalCard(
                    streakDays: _streakDays,
                    todayMinutes: _todayMinutes,
                    goalMinutes: _goalMinutes,
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 28),

                // Featured Technique Cards
                const Text(
                  'Quick Start Techniques',
                  style: AppTypography.titleLarge,
                ),
                const SizedBox(height: 12),

                TechniqueCard(
                  title: 'Visual Syllable Pacer',
                  subtitle: 'Synchronized rhythm pacing for motor speech ease (75 BPM)',
                  icon: Icons.graphic_eq,
                  gradient: AppColors.pacerGradient,
                  onTap: () => _launchExercise(ClinicalExerciseLibrary.allExercises[0]),
                ),
                const SizedBox(height: 12),

                TechniqueCard(
                  title: 'Gentle Voicing Onset',
                  subtitle: 'Soft exhalation before vowel starts to prevent blocks',
                  icon: Icons.air,
                  gradient: AppColors.breathGradient,
                  onTap: () => _launchExercise(ClinicalExerciseLibrary.allExercises[14]),
                ),
                const SizedBox(height: 12),

                TechniqueCard(
                  title: 'Cafe Scenario Practice',
                  subtitle: 'Roleplay ordering food under real-world time pressure',
                  icon: Icons.coffee,
                  gradient: AppColors.scenarioGradient,
                  onTap: () => _launchScenario(ScenarioLibrary.allScenarios[0]),
                ),
                const SizedBox(height: 24),


                // Targeted Sound Mastery (S, CH, F, P)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Target Trouble Sounds',
                      style: AppTypography.titleLarge,
                    ),
                    TextButton(
                      onPressed: widget.onNavigateToLibrary,
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: SoundWordDatabase.soundModules.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final sm = SoundWordDatabase.soundModules[index];
                      return InkWell(
                        onTap: () => _launchSoundModule(sm),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 140,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.surfaceVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  gradient: AppColors.pacerGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    sm.soundKey,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                sm.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${sm.wordDrills.length} Targets',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 28),



                // Mindful Speech Philosophy Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primaryContainer),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield_outlined, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'The Pravāha Mindset',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Fluency is about ease, not perfection. When you feel a block, pause, exhale gently, and let words flow with effortless timing.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
