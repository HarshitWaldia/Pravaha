import 'package:flutter/material.dart';
import '../../../../core/data/exercise_library.dart';
import '../../../../core/data/sound_word_database.dart';
import '../../../../core/models/exercise_model.dart';
import '../../../../core/models/scenario_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'alpha_grid_screen.dart';
import 'gentle_onset_screen.dart';
import 'paced_practice_screen.dart';
import 'rep_counter_screen.dart';
import 'scenario_practice_screen.dart';
import 'stepper_exercise_screen.dart';
import 'stopwatch_screen.dart';
import 'timed_exercise_screen.dart';
import 'word_progression_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ExerciseCategory? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _launchExercise(Exercise exercise) {
    switch (exercise.exerciseType) {
      case ExerciseType.timer:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TimedExerciseScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.repCounter:
      case ExerciseType.holdRelease:
      case ExerciseType.fiveAttribute:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RepCounterScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.stopwatch:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StopwatchScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.stepper:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StepperExerciseScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.alphaGrid:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AlphaGridScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.textPrompt:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GentleOnsetScreen(exercise: exercise),
          ),
        );
        break;
      case ExerciseType.metronome:
      case ExerciseType.wordProgression:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PacedPracticeScreen(exercise: exercise),
          ),
        );
        break;
    }
  }

  void _launchSoundModule(SoundModule soundModule) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WordProgressionScreen(soundModule: soundModule),
      ),
    );
  }

  void _launchScenario(SpeakingScenario scenario) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScenarioPracticeScreen(scenario: scenario),
      ),
    );
  }

  List<Exercise> get _filteredExercises {
    if (_selectedCategoryFilter == null) {
      return ClinicalExerciseLibrary.allExercises;
    }
    return ClinicalExerciseLibrary.allExercises
        .where((e) => e.category == _selectedCategoryFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Library', style: AppTypography.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Clinical Modules (32+)'),
            Tab(text: 'Sound Drills (S, CH, F, P)'),
            Tab(text: 'Speaking Scenarios'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildClinicalModulesTab(),
          _buildSoundDrillsTab(),
          _buildScenariosTab(),
        ],
      ),
    );
  }

  Widget _buildClinicalModulesTab() {
    final categories = [
      null, // All
      ExerciseCategory.articulation,
      ExerciseCategory.oralMotor,
      ExerciseCategory.breathSupport,
      ExerciseCategory.fluencyPacing,
      ExerciseCategory.cognitiveLinguistic,
      ExerciseCategory.stutteringModification,
      ExerciseCategory.reading,
    ];

    final filtered = _filteredExercises;

    return Column(
      children: [
        // Category Filter Chips Carousel
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final isSelected = _selectedCategoryFilter == cat;
              final label = cat == null ? 'All (${ClinicalExerciseLibrary.allExercises.length})' : _getCategoryShortName(cat);

              return ChoiceChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    _selectedCategoryFilter = val ? cat : null;
                  });
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  ),
                ),
              );
            },
          ),
        ),

        // Exercise List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            separatorBuilder: (_, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final exercise = filtered[index];
              return InkWell(
                onTap: () => _launchExercise(exercise),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(exercise.category).withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              exercise.categoryDisplayName,
                              style: TextStyle(
                                color: _getCategoryColor(exercise.category),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            exercise.difficultyDisplayName,
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(exercise.title, style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        exercise.description,
                        style: AppTypography.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(_getExerciseTypeIcon(exercise.exerciseType),
                              size: 15, color: AppColors.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            _getExerciseTypeLabel(exercise),
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSoundDrillsTab() {
    final modules = SoundWordDatabase.soundModules;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: modules.length,
      separatorBuilder: (_, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final sm = modules[index];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.surfaceVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(6),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.pacerGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          sm.soundKey,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentTeal.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${sm.wordDrills.length} Targets',
                        style: const TextStyle(
                          color: AppColors.accentTeal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(sm.title, style: AppTypography.titleLarge),
                const SizedBox(height: 2),
                Text(
                  sm.phoneticClass,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(sm.description, style: AppTypography.bodyMedium),
                const SizedBox(height: 14),
                // Word Chips preview
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: sm.wordDrills.map((d) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        d.targetWord,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchSoundModule(sm),
                    icon: const Icon(Icons.play_arrow),
                    label: Text('Practice ${sm.title} Ladder'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScenariosTab() {
    final scenarios = ScenarioLibrary.allScenarios;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: scenarios.length,
      separatorBuilder: (_, index) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final scenario = scenarios[index];
        return InkWell(
          onTap: () => _launchScenario(scenario),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentTeal.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    color: AppColors.accentTeal,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario.category,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(scenario.title, style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        scenario.contextDescription,
                        style: AppTypography.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textTertiary),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCategoryShortName(ExerciseCategory cat) {
    switch (cat) {
      case ExerciseCategory.articulation:
        return 'Articulation (6)';
      case ExerciseCategory.oralMotor:
        return 'Oral Motor (6)';
      case ExerciseCategory.breathSupport:
        return 'Breath & Volume (5)';
      case ExerciseCategory.fluencyPacing:
        return 'Fluency/Pacing (4)';
      case ExerciseCategory.cognitiveLinguistic:
        return 'Cognitive (5)';
      case ExerciseCategory.stutteringModification:
        return 'Modification (6)';
      case ExerciseCategory.reading:
        return 'Reading';
      case ExerciseCategory.scenario:
        return 'Scenarios';
    }
  }

  Color _getCategoryColor(ExerciseCategory cat) {
    switch (cat) {
      case ExerciseCategory.articulation:
        return const Color(0xFF00838F);
      case ExerciseCategory.oralMotor:
        return const Color(0xFFE65100);
      case ExerciseCategory.breathSupport:
        return const Color(0xFF0288D1);
      case ExerciseCategory.fluencyPacing:
        return AppColors.primary;
      case ExerciseCategory.cognitiveLinguistic:
        return const Color(0xFF6A1B9A);
      case ExerciseCategory.stutteringModification:
        return const Color(0xFF2E7D32);
      case ExerciseCategory.reading:
        return AppColors.secondary;
      case ExerciseCategory.scenario:
        return AppColors.accentTeal;
    }
  }

  IconData _getExerciseTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.timer:
        return Icons.timer_outlined;
      case ExerciseType.repCounter:
        return Icons.touch_app_outlined;
      case ExerciseType.holdRelease:
        return Icons.fitness_center_outlined;
      case ExerciseType.stopwatch:
        return Icons.speed;
      case ExerciseType.stepper:
        return Icons.format_list_numbered;
      case ExerciseType.metronome:
        return Icons.graphic_eq;
      case ExerciseType.wordProgression:
        return Icons.stairs;
      case ExerciseType.textPrompt:
        return Icons.record_voice_over_outlined;
      case ExerciseType.alphaGrid:
        return Icons.grid_view;
      case ExerciseType.fiveAttribute:
        return Icons.checklist;
    }
  }

  String _getExerciseTypeLabel(Exercise e) {
    switch (e.exerciseType) {
      case ExerciseType.timer:
        return '${e.durationSeconds}s Countdown';
      case ExerciseType.repCounter:
        return '${e.repTarget ?? 10} Reps';
      case ExerciseType.holdRelease:
        return '${e.holdSeconds ?? 5}s Hold / ${e.repTarget ?? 10} Cycles';
      case ExerciseType.stopwatch:
        return 'Stopwatch & PB Tracking';
      case ExerciseType.stepper:
        return '${e.stageTitles?.length ?? 4} Stages';
      case ExerciseType.metronome:
        return '${e.defaultBpm} BPM Metronome';
      case ExerciseType.wordProgression:
        return 'Phonetic Ladder';
      case ExerciseType.textPrompt:
        return 'Guided Reading';
      case ExerciseType.alphaGrid:
        return 'A-Z Letter Grid';
      case ExerciseType.fiveAttribute:
        return '5-Attribute Check';
    }
  }
}
