import '../data/exercise_library.dart';

enum ExerciseCategory {
  articulation,
  oralMotor,
  breathSupport,
  fluencyPacing,
  cognitiveLinguistic,
  stutteringModification,
  stammeringTypes,
  reading,
  scenario,
}


enum ExerciseType {
  timer,           // Countdown timer (Bite Block, Jaw Drops)
  repCounter,      // Tap counter (Spot Tap, Lip Pop)
  holdRelease,     // Hold & release state machine (Tongue Roof-Press, Fish Face)
  stopwatch,       // User-controlled stopwatch (Hissing Exhale, Ah Sustenance)
  stepper,         // Multi-stage progression (Volume Escalator, Plosive Drills)
  metronome,       // Syllable/Finger metronome (Paced Syllables, Tapping)
  wordProgression, // Phonetic sound ladder (S, CH, F, P)
  textPrompt,      // Gentle onset / chunked / legato text
  alphaGrid,       // A-Z interactive object hunt grid
  fiveAttribute,   // 5-checkbox object descriptor
}

enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
}

class Exercise {
  final String id;
  final String title;
  final String description;
  final String clinicalRationale;
  final ExerciseCategory category;
  final ExerciseType exerciseType;
  final ExerciseDifficulty difficulty;
  final int defaultBpm;
  final List<String> promptLines;
  final List<String> tips;
  final int durationSeconds;
  final int? holdSeconds;
  final int? restSeconds;
  final int? repTarget;
  final List<String>? stageTitles;
  final List<String>? stagePrompts;
  final String? instructionDetail;
  final String? safetyNote;
  final String? targetSound;
  final bool splitTimer;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.clinicalRationale,
    required this.category,
    this.exerciseType = ExerciseType.metronome,
    required this.difficulty,
    this.defaultBpm = 80,
    this.promptLines = const [],
    this.tips = const [],
    this.durationSeconds = 120,
    this.holdSeconds,
    this.restSeconds,
    this.repTarget,
    this.stageTitles,
    this.stagePrompts,
    this.instructionDetail,
    this.safetyNote,
    this.targetSound,
    this.splitTimer = false,
  });

  String get categoryDisplayName {
    switch (category) {
      case ExerciseCategory.articulation:
        return 'Articulation & Precision';
      case ExerciseCategory.oralMotor:
        return 'Oral Motor Conditioning';
      case ExerciseCategory.breathSupport:
        return 'Breath Support & Volume';
      case ExerciseCategory.fluencyPacing:
        return 'Fluency & Pacing';
      case ExerciseCategory.cognitiveLinguistic:
        return 'Cognitive-Linguistic';
      case ExerciseCategory.stutteringModification:
        return 'Stuttering Modification';
      case ExerciseCategory.stammeringTypes:
        return 'Stammering Types & Block Mastery';
      case ExerciseCategory.reading:
        return 'Paired Reading';

      case ExerciseCategory.scenario:
        return 'Real-World Scenario';
    }
  }

  String get difficultyDisplayName {
    switch (difficulty) {
      case ExerciseDifficulty.beginner:
        return 'Gentle';
      case ExerciseDifficulty.intermediate:
        return 'Moderate';
      case ExerciseDifficulty.advanced:
        return 'Challenging';
    }
  }
}

/// Legacy alias for backward compatibility.
class ExerciseLibrary {
  static List<Exercise> get allExercises => ClinicalExerciseLibrary.allExercises;
}

