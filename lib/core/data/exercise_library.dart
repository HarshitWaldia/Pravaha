import '../models/exercise_model.dart';
import 'sentence_practice_database.dart';


/// Complete, 100% offline clinical exercise library for Pravāha.
/// Covers:
/// 1. Articulation & Precision Practice (6 drills)
/// 2. Oral Motor Conditioning (6 drills)
/// 3. Breath Support & Vocal Volume (5 drills)
/// 4. Fluency, Pacing & Rhythm (4 drills)
/// 5. Cognitive-Linguistic & Word Finding (5 drills)
/// 6. Stuttering Modification & Stamurai Techniques (6 drills)
/// Plus Paired Reading & Scenarios.
class ClinicalExerciseLibrary {
  static final List<Exercise> allExercises = [

    // =========================================================================
    // MODULE 1: ARTICULATION & PRECISION (6 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'art_01_bite_block',
      title: 'The Bite Block Reader',
      description:
          'Read aloud with a clean obstacle between front teeth to force dramatic oral opening and immediate clarity.',
      clinicalRationale:
          'Bite blocks eliminate reliance on jaw closure and force the tongue and lips to work independently with heightened articulation force.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      splitTimer: true,
      instructionDetail:
          'Phase 1 (60s): Place a clean pen, cork, or knuckle gently between your front teeth. Read any text out loud while fighting to enunciate every single syllable clearly.\n\nPhase 2 (60s): Remove the object immediately and continue reading. Feel the effortless lightness and clarity.',
      tips: [
        'Do not bite down hard; hold the object gently.',
        'Over-articulate every consonant during the obstructed phase.',
        'Notice how wide your mouth opens naturally in Phase 2.',
      ],
      promptLines: [
        'Phase 1: Read with bite block in place.',
        'Focus on crisp consonants despite the obstruction.',
        'Phase 2: Remove object now. Read freely.',
        'Notice the effortless lightness in your tongue and lips.',
      ],
    ),
    Exercise(
      id: 'art_02_plosive_drills',
      title: 'Plosive Explosion Drills',
      description:
          'Rapidly repeat sharp plosive consonants to sharpen lip and tongue-tip reaction speed.',
      clinicalRationale:
          'Plosives (/p/, /t/, /k/, /b/) require rapid intraoral air pressure buildup and clean release. Fast repetitions condition the neuromuscular speech mechanism.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.stepper,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 40,
      stageTitles: ['P-P-P-P', 'T-T-T-T', 'K-K-K-K', 'B-B-B-B'],
      stagePrompts: [
        'P-P-P-P-P: Sharp lip bursts. Rapid and crisp for 10 seconds.',
        'T-T-T-T-T: Tongue-tip strikes the roof of the mouth sharply.',
        'K-K-K-K-K: Back of tongue explodes air against soft palate.',
        'B-B-B-B-B: Voiced bilateral lip release with light touch.',
      ],
      instructionDetail:
          'Take a deep breath. For each 10-second stage, rapidly repeat the explosive consonant sound as cleanly and sharply as possible.',
      tips: [
        'Focus on crisp release of air rather than loud volume.',
        'Keep jaw relaxed and let lips/tongue do the work.',
      ],
    ),
    Exercise(
      id: 'art_03_tongue_alternation',
      title: 'Front-to-Back Tongue Alternation',
      description:
          'Force the tongue to rapidly switch motor focus between the tip and the back.',
      clinicalRationale:
          'Alternating anterior (/t/, /p/) and posterior (/k/) articulatory targets conditions rapid motor planning and prevents articulatory locking.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 60,
      splitTimer: true,
      instructionDetail:
          'First 30s: Repeat "T-K, T-K, T-K" continuously.\nNext 30s: Switch to "P-K, P-K, P-K".',
      tips: [
        'Maintain a steady, metronome-like rhythm.',
        'Keep teeth slightly parted so tongue moves freely.',
      ],
      promptLines: [
        'Stage 1 (0-30s): T-K, T-K, T-K, T-K...',
        'Stage 2 (30-60s): P-K, P-K, P-K, P-K...',
      ],
    ),
    Exercise(
      id: 'art_04_phoneme_ladders',
      title: 'Consonant-Vowel Phoneme Ladders',
      description:
          'Run a target consonant sequentially through the five cardinal vowels.',
      clinicalRationale:
          'Systematically builds coarticulation pathways between consonants and various tongue-height vowel positions.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.beginner,
      repTarget: 5,
      instructionDetail:
          'Say: "Lah, Lee, Lie, Loh, Loo" slowly and deliberately. Tap the counter for each full set of 5 vowels completed. Repeat for 5 sets.',
      tips: [
        'Exaggerate the vowel shapes (wide open on "ah", smile on "ee").',
        'Ensure the initial consonant reaches precise anatomical contact every time.',
      ],
      promptLines: [
        'Lah — Lee — Lie — Loh — Loo',
        'Sah — See — Sigh — Soh — Soo',
        'Rah — Ree — Rye — Roh — Roo',
        'Fah — Fee — Fie — Foh — Foo',
      ],
    ),
    Exercise(
      id: 'art_05_jaw_drops',
      title: 'Exaggerated Jaw Drops',
      description:
          'Over-extend lower jaw on every open vowel to stretch masseter muscles and eliminate closed-mouth tension.',
      clinicalRationale:
          'Many people who stutter develop hypertonic jaw clenching. Exaggerated vertical opening deconditions the masseter clamp.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 60,
      instructionDetail:
          'Read any text aloud. Artificially drop your lower jaw twice as wide as normal on every open vowel sound (ah, oh, aw) for 60 seconds.',
      tips: [
        'Feel the deep stretch in your jaw hinges.',
        'Do not force past comfortable range; maintain smooth vertical motion.',
      ],
      promptLines: [
        'Open wide: "All our auto options are awesome."',
        'Drop lower: "Father bought a large modern barn."',
      ],
    ),
    Exercise(
      id: 'art_06_dental_labial',
      title: 'Dental-Labial Shifts',
      description:
          'Rapidly alternate between tooth-on-lip and lip-on-lip positions.',
      clinicalRationale:
          'Rapid shifting between labiodental (/f/) and bilabial (/p/) postures develops fine-motor agonist/antagonist lip coordination.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 30,
      instructionDetail:
          'Repeat the sequence "F-P, F-P, F-P" as fast and cleanly as possible for 30 seconds without mispronouncing.',
      tips: [
        'Top teeth touch lower lip for F; lips press together for P.',
        'Keep airflow continuous and effortless.',
      ],
      promptLines: [
        'F-P, F-P, F-P, F-P, F-P...',
      ],
    ),

    // =========================================================================
    // MODULE 2: ORAL MOTOR CONDITIONING (6 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'oral_01_roof_press',
      title: 'The Tongue Roof-Press',
      description:
          'Press the flat surface of the tongue firmly against the hard palate to build tongue-base strength.',
      clinicalRationale:
          'Conditions the genioglossus and palatoglossus muscles, enhancing lingual control required for fluent consonant articulation.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.holdRelease,
      difficulty: ExerciseDifficulty.beginner,
      holdSeconds: 5,
      restSeconds: 2,
      repTarget: 10,
      instructionDetail:
          'Open your mouth moderately wide. Press the flat, top surface of your tongue firmly against the roof of your mouth. Squeeze and hold for 5 seconds, then relax for 2 seconds. Complete 10 reps.',
      tips: [
        'Cover as much of the hard palate as possible with your tongue.',
        'Keep breathing calmly through your nose during the hold.',
      ],
    ),
    Exercise(
      id: 'oral_02_cheek_pushes',
      title: 'Inside-Cheek Resistance Pushes',
      description:
          'Push tongue into cheek against external finger resistance to build lateral lingual stability.',
      clinicalRationale:
          'Strengthens unilateral lingual control and counteracts asymmetrical tongue tension.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.holdRelease,
      difficulty: ExerciseDifficulty.beginner,
      holdSeconds: 3,
      restSeconds: 2,
      repTarget: 10,
      instructionDetail:
          'Close mouth. Push tongue firmly into left cheek. Place index finger on outside of cheek and press back to create resistance. Hold for 3s. Alternate to right cheek. Complete 5 on each side (10 total).',
      tips: [
        'Create firm, steady isometric pressure.',
        'Keep facial muscles relaxed on the opposite side.',
      ],
    ),
    Exercise(
      id: 'oral_03_tongue_circles',
      title: 'Tongue Tip Circles',
      description:
          'Trace large circles around the mouth cavity between teeth and lips.',
      clinicalRationale:
          'Full-range circumduction lubricates the oral cavity, stretches lingual frenulum, and expands neuromuscular range of motion.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.beginner,
      repTarget: 10,
      instructionDetail:
          'Keep lips closed. Insert tongue between teeth and lips. Trace a slow, full circle around the entire mouth: top teeth -> right cheek -> bottom teeth -> left cheek. Complete 5 clockwise, then 5 counter-clockwise.',
      tips: [
        'Make the circles as wide and deliberate as possible.',
        'Feel the stretch in all four quadrants.',
      ],
    ),
    Exercise(
      id: 'oral_04_fish_to_smile',
      title: 'Fish Face to Wide Smile Shift',
      description:
          'Alternate rapidly between extreme lip puckering and wide ear-to-ear smiling.',
      clinicalRationale:
          'Warms up the orbicularis oris and zygomaticus muscles, training rapid transitions between rounded (/u/, /w/) and retracted (/i/) vowels.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.holdRelease,
      difficulty: ExerciseDifficulty.beginner,
      holdSeconds: 3,
      restSeconds: 1,
      repTarget: 10,
      instructionDetail:
          'Suck cheeks in tightly to create a puckered "fish face". Hold for 3 seconds. Instantly transition into a massive, wide open-mouth smile for 3 seconds. Repeat 10 times.',
      tips: [
        'Exaggerate both extremes fully.',
        'Feel the facial warm-up and increased blood circulation.',
      ],
    ),
    Exercise(
      id: 'oral_05_spot_tap',
      title: 'The Alveolar Ridge "Spot" Tap',
      description:
          'Tap tongue tip independently to the ridge behind upper teeth without moving the jaw.',
      clinicalRationale:
          'Develops lingual-mandibular dissociation (moving the tongue without moving the jaw), essential for fluent speech without jaw jerks.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.intermediate,
      repTarget: 20,
      instructionDetail:
          'Open mouth wide and keep jaw completely still. Touch the tip of your tongue to the bumpy ridge right behind your top front teeth. Tap that spot 20 times using ONLY independent tongue muscle.',
      tips: [
        'Place a thumb under your chin to ensure your jaw does not move.',
        'Every tap should be crisp and clean.',
      ],
    ),
    Exercise(
      id: 'oral_06_lip_pop',
      title: 'The Lip Pop',
      description:
          'Build up intraoral air pressure behind tight lips and release with a loud, clean pop.',
      clinicalRationale:
          'Strengthens lip-seal competence and trains precise pressure regulation for bilabial plosives.',
      category: ExerciseCategory.oralMotor,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.beginner,
      repTarget: 10,
      instructionDetail:
          'Roll lips slightly inward and press tightly together. Build air pressure behind them in the mouth, then release suddenly to create a sharp, distinct "pop" sound. Complete 10 pops.',
      tips: [
        'Listen for a clean acoustic pop on every repetition.',
        'Keep throat and vocal cords relaxed.',
      ],
    ),

    // =========================================================================
    // MODULE 3: BREATH SUPPORT & VOCAL VOLUME (5 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'breath_01_diaphragmatic',
      title: 'Diaphragmatic Belly Book Balance',
      description:
          'Practice deep belly breathing to replace shallow, anxiety-inducing chest breathing.',
      clinicalRationale:
          'Diaphragmatic breathing lowers heart rate, reduces sympathetic nervous system arousal, and provides steady aerodynamic subglottic pressure.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Lie flat on your back (or sit comfortably with a hand on your belly). Inhale deeply through your nose for 4s—watch your belly rise while chest stays still. Exhale slowly through mouth for 6s as belly falls. Follow the calming timer for 2 minutes.',
      tips: [
        'Shoulders should remain completely relaxed and still.',
        'Feel the core expand 360 degrees on the inhale.',
      ],
      promptLines: [
        'Inhale slowly through the nose (Belly rises)',
        'Exhale gently through the mouth (Belly falls)',
      ],
    ),
    Exercise(
      id: 'breath_02_hissing_exhale',
      title: 'The Hissing Resistance Exhale',
      description:
          'Exhale as slowly and evenly as possible on a continuous "Sssss" hiss to master air-stream control.',
      clinicalRationale:
          'Resistance exhales train fine-motor control over the abdominal and intercostal expiratory muscles, preventing sudden air dumping.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.stopwatch,
      difficulty: ExerciseDifficulty.intermediate,
      instructionDetail:
          'Take a deep diaphragmatic breath. Tap "Start" and begin a continuous, steady "Sssssss" hiss. Keep volume perfectly uniform. Tap "Stop" when you run out of air to log your personal best.',
      tips: [
        'Aim for smooth, consistent sound—no surges or drop-offs.',
        'Target goal: 15 to 25 seconds of clean hiss.',
      ],
    ),
    Exercise(
      id: 'breath_03_pitch_glissando',
      title: 'The Pitch Glissando (Siren)',
      description:
          'Glide vocal pitch smoothly from bottom to top and back down on "Oooo".',
      clinicalRationale:
          'Flexes and stretches the cricothyroid and vocalis muscles across their full dynamic range, eliminating vocal cord stiffness.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.intermediate,
      repTarget: 5,
      instructionDetail:
          'Take a deep breath. Starting at your lowest comfortable pitch saying "Oooo", slowly glide your pitch upward like a ship siren to your highest comfortable note, then glide back down to the bottom. Tap the counter for each full siren. Complete 5 rounds.',
      tips: [
        'Keep sound continuous and resonant without cracking.',
        'Support the highest notes with steady abdominal airflow.',
      ],
    ),
    Exercise(
      id: 'breath_04_volume_escalator',
      title: 'Volume Escalator (1 to 5)',
      description:
          'Count from 1 to 5, stepping up vocal projection at each digit without straining the throat.',
      clinicalRationale:
          'Builds conscious control over vocal volume, training diaphragmatic projection rather than throat squeezing.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.stepper,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 30,
      stageTitles: [
        '1: Whisper',
        '2: Soft Voice',
        '3: Conversational',
        '4: Boardroom',
        '5: Presentation'
      ],
      stagePrompts: [
        'Level 1: "One" — Whispered breath (no vocal fold vibration)',
        'Level 2: "Two" — Soft, gentle private voice',
        'Level 3: "Three" — Comfortable everyday conversational voice',
        'Level 4: "Four" — Loud, confident boardroom projecting voice',
        'Level 5: "Five" — Strong, resonant presentation hall projection',
      ],
      instructionDetail:
          'Count from 1 to 5 across the 5 volume levels. Step through each digit and feel how volume increases from diaphragmatic air power, not throat tension.',
      tips: [
        'On Level 5, project from your belly, never yell or scratch the throat.',
        'Repeat the 5-step ladder 3 to 5 times.',
      ],
    ),
    Exercise(
      id: 'breath_05_wall_sit_ah',
      title: 'The Wall-Sit "Ah" Sustenance',
      description:
          'Sustain a clear "Ah" while in a wall-sit squat to link speech airflow directly to core activation.',
      clinicalRationale:
          'Engaging the quadriceps and core during phonation activates the somatic grounding response, forcing natural subglottic breath support.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.stopwatch,
      difficulty: ExerciseDifficulty.advanced,
      safetyNote:
          'Safety Note: If your legs tire or feel unstable, stand up safely and continue the sustained breath standing normally.',
      instructionDetail:
          'Stand with your back flat against a wall and lower into a comfortable slight squat. Take a deep breath, tap "Start", and sustain a clear, resonant "Ahhhhh" sound for as long as your breath naturally lasts. Tap "Stop" when done.',
      tips: [
        'Keep jaw relaxed and throat wide open.',
        'Feel how the leg engagement anchors your breath.',
      ],
    ),

    // =========================================================================
    // MODULE 4: FLUENCY, PACING & RHYTHM (4 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'fluency_01_syllable_tapping',
      title: 'Finger Syllable Tapping',
      description:
          'Sync motor speech cadence with physical fingertip taps at an adjustable BPM pace.',
      clinicalRationale:
          'Multi-modal rhythmic pacing: linking syllable generation with a somatic motor anchor (finger tap) resets the brain speech timing network.',
      category: ExerciseCategory.fluencyPacing,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.beginner,
      defaultBpm: 70,
      durationSeconds: 90,
      instructionDetail:
          'Set a comfortable pace on the slider. For every pulse of the bubble, tap your finger firmly on your thigh and speak exactly one syllable.',
      tips: [
        'Match the tap exactly to the start of the syllable.',
        'Do not rush ahead of the visual metronome.',
      ],
      promptLines: [
        'I — am — speak — ing — with — a — stead — y — rhythm.',
        'Each — sin — gle — word — has — its — own — space.',
        'Prac — tice — cre — ates — calm — and — con — trol.',
        'My — voice — is — clear — and — un — hur — ried.',
      ],
    ),
    Exercise(
      id: 'fluency_02_phrase_chunking',
      title: 'The Paused Phrase Chunk Check',
      description:
          'Read sentences grouped into 3-4 word chunks with deliberate resting breath pauses.',
      clinicalRationale:
          'Breaks the habit of rushing through long sentences and eliminates mid-utterance air starvation.',
      category: ExerciseCategory.fluencyPacing,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Speak only the words within one chunk. Completely pause, take a relaxed diaphragmatic breath, and only then read the next chunk.',
      tips: [
        'Honor the pause—it is where relaxation happens.',
        'Keep shoulders relaxed during every breath gap.',
      ],
      promptLines: [
        'Early in the morning... / I take a quiet walk... / through the green park.',
        'When we speak calmly... / every listener has time... / to understand our thoughts.',
        'Fluency is not about speed... / it is about ease... / and natural connection.',
      ],
    ),
    Exercise(
      id: 'fluency_03_easy_onset_phrases',
      title: 'Easy Onset Breathed Phrases',
      description:
          'Prefix initial words with a gentle puff of silent air ("hhhh-") to prevent glottal blockages.',
      clinicalRationale:
          'Gentle Onset transitions the vocal folds from an open (abducted) respiratory state to gentle phonation without hard impact.',
      category: ExerciseCategory.fluencyPacing,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Before voicing each word, let out a tiny whisper/puff of air ("hhhh-"). Transition smoothly into the vowel without clamping the throat.',
      tips: [
        'The "hhhh" should be soft and easy, like a sigh of relief.',
        'Gradually blend the breath into the vowel sound.',
      ],
      promptLines: [
        'hhhh — Apple on the table.',
        'hhhh — Always choose patience.',
        'hhhh — Open your mind to progress.',
        'hhhh — Early morning sunshine.',
        'hhhh — Every breath brings ease.',
      ],
    ),
    Exercise(
      id: 'fluency_04_legato_reading',
      title: 'Continuous Phonation Legato',
      description:
          'Connect the final sound of every word directly into the next without stopping vocal cord vibration.',
      clinicalRationale:
          'Stuttering blocks occur almost exclusively at the initiation of voicing. Continuous phonation eliminates the restart points.',
      category: ExerciseCategory.fluencyPacing,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      instructionDetail:
          'Read the passage like a continuous piece of music. Stretch vowels slightly so your voice never stops vibrating between words.',
      tips: [
        'Think of your voice as a cello bow moving continuously across a string.',
        'Do not worry if it sounds slightly stretched—this is motor training.',
      ],
      promptLines: [
        'Theeee — aaandeeees — moooouuuntaaaains — aaare — maaaagnificennnt.',
        'Sssmoooth — cooonneeectionnns — creeeeaaate — naaatural — rhyyythm.',
        'Unnnbrrrooookennn — streeeeam — ooof — caaalm — voooicaaal — soouuund.',
      ],
    ),

    // =========================================================================
    // MODULE 5: COGNITIVE-LINGUISTIC (WORD FINDING) (5 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'cog_01_convergent_naming',
      title: 'Rapid Convergent Naming',
      description:
          'View 3 specific items and immediately identify their overarching umbrella category.',
      clinicalRationale:
          'Strengthens top-down semantic categorization and reduces word retrieval hesitation in conversation.',
      category: ExerciseCategory.cognitiveLinguistic,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.beginner,
      repTarget: 10,
      instructionDetail:
          'Read the 3 items aloud, then immediately say their common category out loud as fast as possible. Tap the counter to advance.',
      tips: [
        'Speak the category cleanly without fillers (um, uh).',
        'Use gentle onset when stating the category.',
      ],
      promptLines: [
        'Pillow, Blanket, Mattress  ->  "BEDDING!"',
        'Apple, Banana, Orange  ->  "FRUITS!"',
        'Hammer, Wrench, Pliers  ->  "TOOLS!"',
        'Guitar, Piano, Violin  ->  "INSTRUMENTS!"',
        'Shirt, Trousers, Jacket  ->  "CLOTHING!"',
        'Rose, Tulip, Sunflower  ->  "FLOWERS!"',
        'Doctor, Engineer, Teacher  ->  "PROFESSIONS!"',
        'Car, Bicycle, Train  ->  "VEHICLES!"',
        'Table, Chair, Sofa  ->  "FURNITURE!"',
        'Eagle, Sparrow, Penguin  ->  "BIRDS!"',
      ],
    ),
    Exercise(
      id: 'cog_02_divergent_sprint',
      title: 'Divergent Category Sprint',
      description:
          'Name as many distinct items belonging to a single category as possible in 60 seconds.',
      clinicalRationale:
          'Trains rapid lexical search, word retrieval pathways, and fluent speech under mild time constraints.',
      category: ExerciseCategory.cognitiveLinguistic,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 60,
      instructionDetail:
          'When the timer starts, speak as many items fitting the prompted category as possible. Aim for 15+ items before time runs out.',
      tips: [
        'Maintain relaxed breath support—do not hold your breath.',
        'If stuck, visualize a specific room or scene.',
      ],
      promptLines: [
        'Category: "Things you find in a Kitchen"',
        'Category: "Animals in the Wild"',
        'Category: "Items in an Office or Study"',
        'Category: "Countries in the World"',
      ],
    ),
    Exercise(
      id: 'cog_03_word_chains',
      title: 'Word Association Chains',
      description:
          'Build a continuous chain of 20 spoken association words without hesitating.',
      clinicalRationale:
          'Conditions fluid associative memory transitions and reduces fear of pauses during spontaneous discourse.',
      category: ExerciseCategory.cognitiveLinguistic,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.intermediate,
      repTarget: 20,
      instructionDetail:
          'Start with the root word. Say it aloud, then immediately say a related word, and another related to that one, up to 20 words in a row. Tap "Count Word" for each word.',
      tips: [
        'Example: Clock -> Time -> Watch -> Wrist -> Hand -> Glove...',
        'Any association is valid; prioritize momentum over logic.',
      ],
      promptLines: [
        'Root Word: "OCEAN" (-> Water -> Wave -> Beach -> Sand -> Castle...)',
        'Root Word: "GARDEN" (-> Flower -> Bee -> Honey -> Sweet -> Tea...)',
      ],
    ),
    Exercise(
      id: 'cog_04_alphabet_hunt',
      title: 'Alphabetical Object Hunt',
      description:
          'Scan your room or environment and name an object starting with each letter from A to Z.',
      clinicalRationale:
          'Combines visual scanning with phonetic phoneme matching across all 26 consonant/vowel positions.',
      category: ExerciseCategory.cognitiveLinguistic,
      exerciseType: ExerciseType.alphaGrid,
      difficulty: ExerciseDifficulty.beginner,
      instructionDetail:
          'Look around your room. Find an object starting with "A" and say it aloud, then tap "A". Move to "B", "C", and through the entire alphabet. Use "Skip" for rare letters.',
      tips: [
        'Look out the window or picture items if a letter is not physically present.',
        'Pronounce each object with clear articulation.',
      ],
    ),
    Exercise(
      id: 'cog_05_five_attribute',
      title: '5-Attribute Object Description',
      description:
          'Pick up any object and describe it fluently using 5 distinct structural attributes in one sentence.',
      clinicalRationale:
          'Exercises tactile observation, rapid adjective retrieval, and complex syntactic sentence assembly.',
      category: ExerciseCategory.cognitiveLinguistic,
      exerciseType: ExerciseType.fiveAttribute,
      difficulty: ExerciseDifficulty.intermediate,
      repTarget: 5,
      instructionDetail:
          'Pick up an object near you (e.g., a coffee mug). Describe it in one fluent sentence covering: 1. Material, 2. Color, 3. Shape, 4. Weight/Size, 5. Function. Check off all 5 attributes.',
      tips: [
        'Example: "This is a ceramic, navy-blue, cylindrical, heavy mug used for drinking tea."',
        'Speak the complete sentence smoothly in one breath.',
      ],
    ),

    // =========================================================================
    // MODULE 6: STUTTERING MODIFICATION / STAMURAI TECHNIQUES (6 EXERCISES)
    // =========================================================================
    Exercise(
      id: 'mod_01_preparatory_sets',
      title: 'Preparatory Sets (Pre-Blocks)',
      description:
          'Anticipate a feared word and deliberately ease muscular tension before saying it.',
      clinicalRationale:
          'Van Riperian Preparatory Set: actively reconfigures the articulators into a relaxed, loose posture BEFORE phonation begins.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      instructionDetail:
          'Before speaking the capitalized target word, pause for 1 second. Consciously relax your lips, tongue, and throat, then ease into the word with light contact.',
      tips: [
        'Do not rush to "get it over with".',
        'Approach the target word with open curiosity and relaxed breath.',
      ],
      promptLines: [
        'I would like to order a warm [COFFEE] please.',
        'Let us schedule our next [PROJECT] meeting.',
        'We are traveling to [SPAIN] this summer.',
        'My favorite season of the year is [SPRING].',
      ],
    ),
    Exercise(
      id: 'mod_02_pull_outs',
      title: 'Pull-Outs (Ease-Outs)',
      description:
          'When caught in an active stutter block, smoothly slide and ease your way out without stopping.',
      clinicalRationale:
          'Van Riperian Pull-Out: trains conscious voluntary control during the involuntary block, transforming struggle into smooth prolongation.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 120,
      instructionDetail:
          'If you feel a block starting, DO NOT force through it with hard pressure. Slow down, release the tight tension in your mouth, and stretch the sound out smoothly into the rest of the word.',
      tips: [
        'Think of pulling a tight knot loose with gentle fingers.',
        'Transform hard tension into a smooth, loose glide.',
      ],
      promptLines: [
        'P-p-p... [Plllllease] take a seat.',
        'T-t-t... [Tiiiime] is on our side.',
        'S-s-s... [Sssstay] calm and focused.',
        'C-c-c... [Cllllear] communication flows.',
      ],
    ),
    Exercise(
      id: 'mod_03_cancellations',
      title: 'Cancellations (Post-Block Review)',
      description:
          'After experiencing a stuttered word, pause completely, analyze the tension, and repeat it with ease.',
      clinicalRationale:
          'Van Riperian Cancellation: breaks the negative reinforcement loop of stutter struggle by giving the motor system a successful fluent repetition immediately following a block.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      instructionDetail:
          '1. Speak the phrase.\n2. If you stutter on a word, finish it, then PAUSE for 2 seconds.\n3. Identify where the tension was.\n4. Say the word a second time with deliberate lightness and gentle onset.',
      tips: [
        'The pause is essential for neuromuscular resetting.',
        'Celebrate the second, easy repetition.',
      ],
      promptLines: [
        'The [TRAIN] arrived right on time.',
        'We had a wonderful [CONVERSATION].',
        'Practice brings lasting [CONFIDENCE].',
        'Every day is a fresh [OPPORTUNITY].',
      ],
    ),
    Exercise(
      id: 'mod_04_light_contacts',
      title: 'Light Articulatory Contacts',
      description:
          'Make feather-light, soft contact with lips, tongue, and teeth on hard consonants.',
      clinicalRationale:
          'Reduces isometric muscle contraction in the oral articulators, preventing the physical locks that cause blockages.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Pronounce consonants with the absolute minimum physical touch required—like butterfly wings brushing a flower. Feel no pressure in your lips or tongue.',
      tips: [
        'Notice how little force is actually required to make a clear "P", "T", or "K".',
        'Keep jaw loose and teeth slightly parted.',
      ],
      promptLines: [
        'Paper — Peter — People — Purpose',
        'Table — Tiger — Time — Talent',
        'Cookie — Candle — Coffee — Comfort',
      ],
    ),
    Exercise(
      id: 'mod_05_prolongation',
      title: 'Prolongation (Stretched Speech)',
      description:
          'Deliberately stretch the initial sound of each word to establish smooth speech momentum.',
      clinicalRationale:
          'Stretching initial sounds keeps the phonatory system continuously activated and allows auditory feedback calibration.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.beginner,
      defaultBpm: 60,
      durationSeconds: 120,
      instructionDetail:
          'Stretch the first sound of each word for 1 to 2 beats of the pacer, then glide through the rest of the syllable.',
      tips: [
        'Maintain continuous breath support through the stretch.',
        'Keep sound soft and melodious.',
      ],
      promptLines: [
        'Mmmmorning is a fresh start.',
        'Ssssummer brings warm sunshine.',
        'Llllearning brings steady growth.',
        'Fffflowing like a quiet river.',
      ],
    ),
    Exercise(
      id: 'mod_06_muscle_relaxation',
      title: 'Progressive Speech Muscle Relaxation',
      description:
          'Tense and release jaw, tongue, and neck muscles to cultivate acute bodily tension awareness.',
      clinicalRationale:
          'Jacobsonian progressive relaxation trains proprioceptive discrimination between hypertonic tension and true somatic ease.',
      category: ExerciseCategory.stutteringModification,
      exerciseType: ExerciseType.holdRelease,
      difficulty: ExerciseDifficulty.beginner,
      holdSeconds: 5,
      restSeconds: 5,
      repTarget: 6,
      instructionDetail:
          'Cycle 1-2: Clench jaw gently (5s), then drop open completely (5s).\nCycle 3-4: Press tongue to palate (5s), then let tongue rest flat (5s).\nCycle 5-6: Shrug shoulders to ears (5s), then drop shoulders down (5s).',
      tips: [
        'Feel the stark contrast between the tight state and the limp, relaxed state.',
        'Take a deep belly breath every time you release.',
      ],
    ),

    // =========================================================================
    // MODULE 7: PAIRED READING & SCENARIOS (EXISTING EXPANDED)
    // =========================================================================
    Exercise(
      id: 'reading_01_ocean',
      title: 'Passage: The Serene Ocean',
      description:
          'Full reading passage with synchronized sentence rhythm cues.',
      clinicalRationale:
          'Connected reading strengthens fluency generalization across extended discourse paragraphs.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.intermediate,
      defaultBpm: 80,
      durationSeconds: 180,
      tips: [
        'Pause at natural commas and full stops.',
        'Take a silent, relaxing breath before each sentence.',
      ],
      promptLines: [
        'Along the quiet shore, waves gently rise and fall with an effortless cadence.',
        'The rhythmic sound of the sea reminds us that natural flow requires no force or hurry.',
        'When we allow each breath to guide our voice, speech becomes as natural as the tide.',
        'Patience and consistency are the foundations of true vocal freedom.',
      ],
    ),

    // =========================================================================
    // MODULE 3 EXTENDED: 8 ADVANCED BREATHING EXERCISES
    // =========================================================================
    Exercise(
      id: 'breath_06_box_breathing',
      title: 'Box Breathing (4-4-4-4)',
      description:
          'Inhale 4s, hold 4s, exhale 4s, hold 4s. Navy SEAL protocol for autonomic speech anxiety reset.',
      clinicalRationale:
          'Equalizes sympathetic and parasympathetic autonomic branches, reducing heart rate and pre-speech panic spikes.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Follow the soothing 4-phase box: Inhale 4s -> Hold full 4s -> Exhale 4s -> Hold empty 4s. Complete for 2 calming minutes.',
      tips: [
        'Keep shoulders relaxed during the breath holds.',
        'Do not clamp the throat during the holds; close the airway gently.',
      ],
      promptLines: [
        'Phase 1: Inhale through nose (4s)',
        'Phase 2: Hold gently (4s)',
        'Phase 3: Exhale smoothly (4s)',
        'Phase 4: Rest empty (4s)',
      ],
    ),
    Exercise(
      id: 'breath_07_resonant_breathing',
      title: 'Resonant 5.5s Breathing',
      description:
          'Inhale for 5.5s and exhale for 5.5s (approx. 5.5 breaths per minute) to maximize Heart Rate Variability.',
      clinicalRationale:
          '5.5 BPM breathing synchronizes respiratory sinus arrhythmia with baroreflex oscillations for maximal neurovascular relaxation.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Breathe in slowly for 5.5 seconds expanding the belly, then release gently for 5.5 seconds. Repeat for 2 minutes before challenging speaking tasks.',
      tips: [
        'Feel the smooth circular transition between in-breath and out-breath.',
        'Keep chest still and expand belly 360 degrees.',
      ],
      promptLines: [
        'Inhale slowly (5.5s) — Belly expands gently',
        'Exhale smoothly (5.5s) — Belly falls naturally',
      ],
    ),
    Exercise(
      id: 'breath_08_staccato_exhale',
      title: 'Staccato "Ha-Ha-Ha" Breath',
      description:
          'Pulsed abdominal contractions on rapid unvoiced breaths to condition diaphragm response speed.',
      clinicalRationale:
          'Conditions the rapid recruitment of the rectus abdominis and transversus abdominis for quick subglottic air replenishment.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.repCounter,
      difficulty: ExerciseDifficulty.intermediate,
      repTarget: 5,
      instructionDetail:
          'Take a deep breath. Release 5 rapid, pulsed "Ha! Ha! Ha! Ha! Ha!" bursts from your belly without voicing. Tap counter for each set of 5. Complete 5 sets.',
      tips: [
        'Place your hand on your navel—feel it bounce inward on every "Ha".',
        'Keep throat wide and silent.',
      ],
    ),
    Exercise(
      id: 'breath_09_pursed_lip',
      title: 'Pursed Lip Resistance Exhale',
      description:
          'Exhale through tiny puckered lips to create back-pressure and lengthen the expiratory speaking phase.',
      clinicalRationale:
          'Increases positive end-expiratory pressure, strengthening respiratory muscle endurance and steadying phonatory airflow.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.stopwatch,
      difficulty: ExerciseDifficulty.intermediate,
      instructionDetail:
          'Inhale deeply through nose. Pucker lips like whistling. Tap Start and exhale through the tiny opening as slowly and evenly as possible. Tap Stop when empty to log your Personal Best.',
      tips: [
        'Aim for a thin, steady stream of cool air.',
        'Target goal: 20 to 35 seconds.',
      ],
    ),
    Exercise(
      id: 'breath_10_lateral_ribcage',
      title: 'Lateral Ribcage 3D Expansion',
      description:
          'Place hands on lower ribs and expand horizontally like an accordion on the inhale.',
      clinicalRationale:
          'Trains lower intercostal activation and prevents upper-clavicular shallow panic breathing.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Place both palms firmly against your lower side ribs. Inhale deeply and push your hands outward with your expanding ribcage. Exhale as ribs knit back inward.',
      tips: [
        'Feel the side and back expansion, not just front belly.',
        'Keep neck muscles completely limp.',
      ],
      promptLines: [
        'Inhale: Push ribs outward into your hands.',
        'Exhale: Feel ribs gently recoil inward.',
      ],
    ),
    Exercise(
      id: 'breath_11_candle_flame',
      title: 'The Candle Flame Sustain',
      description:
          'Hold finger 4 inches from mouth. Exhale a steady air stream that would bend a flame without blowing it out.',
      clinicalRationale:
          'Develops laminar airflow regulation, eliminating turbulent air surges that trigger laryngeal spasms.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.stopwatch,
      difficulty: ExerciseDifficulty.intermediate,
      instructionDetail:
          'Hold index finger in front of lips. Inhale deeply. Tap Start and blow a micro-thin, steady, warm stream of air. Maintain unbroken pressure until empty. Tap Stop to record your PB.',
      tips: [
        'The air temperature on your finger should feel consistently warm and gentle.',
        'Do not let the stream flicker or sputter.',
      ],
    ),
    Exercise(
      id: 'breath_12_4_7_8_calm',
      title: '4-7-8 Pre-Speech Anxiety Calming',
      description:
          'Inhale 4s through nose, hold 7s, whoosh exhale 8s. Proven vagus nerve stimulator before presentations.',
      clinicalRationale:
          'Dr. Andrew Weil’s 4-7-8 breathing triggers parasympathetic acetylcholine release, relaxing hypertonic speech musculature.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      instructionDetail:
          'Inhale quietly through nose for 4s. Hold breath comfortably for 7s. Make a whoosh sound exhaling through mouth for 8s. Repeat for 4 full cycles (2 mins).',
      tips: [
        'The 8-second exhale is the most important part.',
        'Feel your heartbeat slow down naturally.',
      ],
      promptLines: [
        'Inhale through nose (4s)',
        'Hold breath calmly (7s)',
        'Whoosh exhale through mouth (8s)',
      ],
    ),
    Exercise(
      id: 'breath_13_sigh_to_speech',
      title: 'The Sigh-to-Speech Glide',
      description:
          'Release a relaxed audible sigh ("Ahhhh") and effortlessly glide directly into a spoken phrase.',
      clinicalRationale:
          'Bridges natural vegetative phonation (sighing) into intentional propositional speech without throat locks.',
      category: ExerciseCategory.breathSupport,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Let the sigh be 100% genuine and heavy.',
        'Ride the wave of the sigh straight into the words.',
      ],
      promptLines: SentencePracticeDatabase.breathSpeechIntegration.take(12).toList(),
    ),

    // =========================================================================
    // MODULE 1 EXTENDED: 5-LEVEL BITE-BLOCK / PEN-IN-MOUTH MASTERY
    // =========================================================================
    Exercise(
      id: 'art_07_bite_block_l1',
      title: 'Bite Block Level 1: Isolated Sounds',
      description:
          'Hold a clean pen/cork gently between front teeth and articulate pure consonant targets (/s/, /p/, /t/, /k/).',
      clinicalRationale:
          'De-links jaw movement from isolated tongue and lip placements, training pure articulatory independence.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 60,
      instructionDetail:
          'Place pen gently between incisors. Rapidly produce the target sounds with maximum clarity for 60 seconds.',
      tips: [
        'Hold pen lightly with teeth; do not bite down with jaw tension.',
        'Move only your tongue and lips.',
      ],
      promptLines: [
        'S-S-S-S (Tongue channels air over groove)',
        'P-P-P-P (Lips seal around the pen and pop)',
        'T-T-T-T (Tongue tip strikes alveolar ridge)',
        'K-K-K-K (Back of tongue lifts to soft palate)',
      ],
    ),
    Exercise(
      id: 'art_08_bite_block_l2',
      title: 'Bite Block Level 2: Single Words',
      description:
          'Pronounce 1-2 syllable target words with pen between teeth, then repeat freely without pen.',
      clinicalRationale:
          'Conditions coarticulation agility under mechanical obstruction.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 90,
      splitTimer: true,
      instructionDetail:
          'Phase 1 (45s): Read words with pen in mouth, enunciating every syllable.\nPhase 2 (45s): Remove pen and repeat words freely with effortless openness.',
      tips: [
        'Over-exaggerate lip and tongue motions during Phase 1.',
        'Notice how light and crisp your speech feels in Phase 2.',
      ],
      promptLines: [
        'Phase 1 (Pen in): Sun, Chair, Fan, Pool, Tiger, Ocean, Kitchen, Paper',
        'Phase 2 (Pen out): Repeat freely with effortless oral opening.',
      ],
    ),
    Exercise(
      id: 'art_09_bite_block_l3',
      title: 'Bite Block Level 3: Short Sentences',
      description:
          'Read 5-8 word sentences with pen obstruction (60s), then freely (60s).',
      clinicalRationale:
          'Generalizes lingual-mandibular dissociation to connected syntactic phrases.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      splitTimer: true,
      instructionDetail:
          'Phase 1 (60s): Place pen between teeth and read sentences out loud.\nPhase 2 (60s): Remove pen and read with wide, relaxed jaw drops.',
      tips: [
        'Do not let consonants slur during Phase 1.',
        'Feel the dramatic surge in clarity during Phase 2.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.take(6).toList(),
    ),
    Exercise(
      id: 'art_10_bite_block_l4',
      title: 'Bite Block Level 4: Paragraph Reading',
      description:
          'Read a full literary paragraph with bite block (90s), followed by open expressive reading (90s).',
      clinicalRationale:
          'Builds prolonged articulatory endurance and hyper-clarity across extended paragraph reading.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 180,
      splitTimer: true,
      instructionDetail:
          'Phase 1 (90s): Read the passage with pen between teeth.\nPhase 2 (90s): Remove pen immediately and read with full vocal projection and effortless ease.',
      tips: [
        'Take deep belly breaths at commas.',
        'Enjoy the effortless sensation in Phase 2.',
      ],
      promptLines: [
        SentencePracticeDatabase.bookReadingPassages[0],
        SentencePracticeDatabase.bookReadingPassages[1],
      ],
    ),
    Exercise(
      id: 'art_11_bite_block_l5',
      title: 'Bite Block Level 5: Conversational Q&A',
      description:
          'Answer simulated real-world questions with pen between teeth, then answer freely.',
      clinicalRationale:
          'Spontaneous cognitive-linguistic formulation under articulatory load trains subconscious muscle clarity.',
      category: ExerciseCategory.articulation,
      exerciseType: ExerciseType.timer,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 180,
      splitTimer: true,
      instructionDetail:
          'Phase 1 (90s): Answer the questions aloud with pen in mouth.\nPhase 2 (90s): Remove pen and speak freely with crystal clarity.',
      tips: [
        'Speak in full, complete sentences.',
        'Maintain eye contact with your reflection or an object in the room.',
      ],
      promptLines: [
        'Q1: What are your three favorite hobbies and why?',
        'Q2: Describe your ideal morning routine step-by-step.',
        'Q3: What is a project or skill you are currently working on?',
      ],
    ),

    // =========================================================================
    // MODULE 8: 16 TARGETED STAMMERING TYPE & BLOCK MASTERY EXERCISES
    // =========================================================================
    // TYPE 1: INITIAL WORD BLOCKS (5 EXERCISES)
    Exercise(
      id: 'st_init_01_s',
      title: 'Type 1: Initial "S" Block Mastery',
      description:
          'Master initial S-blocks ("S-s-s-un") using continuous air-channeling and easy glide onsets.',
      clinicalRationale:
          'Initial S-blocks occur when tongue jams hard against the alveolar ridge. Continuous airflow sighing prevents the pressure lock.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Start with a soft, trailing hiss of air before voicing the vowel.',
        'Keep teeth close but cheek muscles soft.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.where((s) => s.startsWith('Sssss')).take(10).toList(),
    ),
    Exercise(
      id: 'st_init_02_p',
      title: 'Type 1: Initial "P" Block Mastery',
      description:
          'Master initial P-blocks ("P-p-p-en") using butterfly-light lip contact and breathed "h-P!" onsets.',
      clinicalRationale:
          'Initial P-blocks happen from high isometric lip squeeze. Breathed onset and micro-touch releases pressure effortlessly.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Let out a tiny puff of air right before popping ("h-Pool").',
        'Touch lips together as gently as butterfly wings.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.where((s) => s.startsWith('P!')).take(10).toList(),
    ),
    Exercise(
      id: 'st_init_03_ch',
      title: 'Type 1: Initial "CH" Block Mastery',
      description:
          'Master initial CH-blocks ("Ch-ch-chair") using palatal preparatory sets and clean affricate bursts.',
      clinicalRationale:
          'Initial CH-blocks combine tongue clamping and laryngeal tension. Proper lip pucker and light contact creates an effortless burst.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'Pucker lips slightly forward and drop jaw freely into the vowel.',
        'Explode the sound out like a soft sneeze without throat squeeze.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.where((s) => s.startsWith('T-S-H')).take(10).toList(),
    ),
    Exercise(
      id: 'st_init_04_f',
      title: 'Type 1: Initial "F" Block Mastery',
      description:
          'Master initial F-blocks ("F-f-f-an") by gently placing top teeth on bottom lip without biting.',
      clinicalRationale:
          'F-blocks occur from hard downward incisor biting. Light positioning allows continuous airflow escape.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Feel the warm air escaping freely between teeth and lip.',
        'Voice only when opening into the vowel.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.where((s) => s.startsWith('Ffffff')).take(10).toList(),
    ),
    Exercise(
      id: 'st_init_05_vowel',
      title: 'Type 1: Initial Vowel & Glottal Blocks',
      description:
          'Master hard vowel blocks ("A-a-apple") using soft "hhhh-" Easy Onset breath prefixes.',
      clinicalRationale:
          'Vowel initial blocks are hard glottal attacks where vocal folds slam shut. An unvoiced breath prefix guarantees open fold phonation.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Prefix every word with a gentle whisper of air ("hhhh-Apple").',
        'Open throat wide like a morning yawn.',
      ],
      promptLines: SentencePracticeDatabase.initialBlocks.where((s) => s.startsWith('hhhh')).take(10).toList(),
    ),

    // TYPE 2: MEDIAL WORD BLOCKS (4 EXERCISES)
    Exercise(
      id: 'st_med_01_plosive',
      title: 'Type 2: Medial Plosive Escape',
      description:
          'Overcome middle-of-word locks on "captain", "happy", "apple" using Van Riper Pull-Outs.',
      clinicalRationale:
          'Medial blocks happen during the transition from vowel to consonant. Slowing down and stretching the medial consonant eases out the block.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'On the medial consonant, ease muscular pressure and stretch the sound out.',
        'Do not stop voicing; pull out smoothly into the final vowel.',
      ],
      promptLines: SentencePracticeDatabase.medialBlocks.take(12).toList(),
    ),
    Exercise(
      id: 'st_med_02_fricative',
      title: 'Type 2: Medial Fricative Flow',
      description:
          'Flow through middle fricatives in "coffee", "office", "messy" with continuous phonation.',
      clinicalRationale:
          'Maintains unbroken laryngeal vibration across the middle syllable boundary.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'Hold the middle consonant for an extra half-second without stopping airflow.',
        'Keep lips and cheeks soft and relaxed.',
      ],
      promptLines: SentencePracticeDatabase.medialBlocks.skip(12).take(12).toList(),
    ),
    Exercise(
      id: 'st_med_03_affricate',
      title: 'Type 2: Medial Affricate Light Touch',
      description:
          'Master middle affricates in "kitchen", "nature", "bridge" with light articulatory contact.',
      clinicalRationale:
          'Prevents palatal suction locks in multi-syllabic words through feather-touch placement.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'Trap air lightly in the middle of the word and release with a soft pop.',
        'Keep vocal tone resonant throughout the word.',
      ],
      promptLines: SentencePracticeDatabase.medialBlocks.skip(24).take(12).toList(),
    ),
    Exercise(
      id: 'st_med_04_vowel_bridge',
      title: 'Type 2: Medial Vowel-to-Vowel Bridge',
      description:
          'Connect multi-syllabic words like "beautiful", "restaurant", "patience" without mid-word hesitation.',
      clinicalRationale:
          'Stretches the vowel resonance channel across intermediate consonants, eliminating restart points.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'Think of the word as a single continuous vowel stream carrying light consonants.',
        'Maintain diaphragmatic air support through the middle of the word.',
      ],
      promptLines: SentencePracticeDatabase.medialBlocks.skip(36).take(12).toList(),
    ),

    // TYPE 3: FINAL WORD BLOCKS (3 EXERCISES)
    Exercise(
      id: 'st_fin_01_plosive',
      title: 'Type 3: Final Plosive Release',
      description:
          'End words cleanly on "stop", "cup", "help" with a trailing pop and relaxed jaw release.',
      clinicalRationale:
          'Final blocks occur when speakers clamp articulators shut at word end in anticipation of finishing. Releasing into open breath prevents clamping.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Pop the final consonant and immediately drop your jaw into relaxed open air.',
        'Do not clamp lips or tongue shut at the end of the word.',
      ],
      promptLines: SentencePracticeDatabase.finalBlocks.take(12).toList(),
    ),
    Exercise(
      id: 'st_fin_02_fricative',
      title: 'Type 3: Final Fricative Stream',
      description:
          'End words smoothly on "bus", "leaf", "roof" with an effortless fading air stream.',
      clinicalRationale:
          'Maintains open vocal tract posture right through the completion of phonation.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Let the final sound fade out like a gentle sigh on your bottom lip.',
        'Avoid chopping the trailing sound short.',
      ],
      promptLines: SentencePracticeDatabase.finalBlocks.skip(12).take(12).toList(),
    ),
    Exercise(
      id: 'st_fin_03_cancellation',
      title: 'Type 3: Post-Block Cancellation Drill',
      description:
          'If you block on a word: finish it -> pause 2s -> analyze tension -> repeat with gentle ease.',
      clinicalRationale:
          'Van Riperian Cancellation gives the speech motor cortex a successful, relaxed repetition immediately following a struggle, extinguishing fear pathways.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 120,
      tips: [
        'The 2-second pause is essential for neuromuscular resetting.',
        'Say the second repetition with 50% less physical effort.',
      ],
      promptLines: SentencePracticeDatabase.finalBlocks.skip(24).take(12).toList(),
    ),

    // TYPE 4: CONNECTED SPEECH & INTER-WORD BLOCKS (2 EXERCISES)
    Exercise(
      id: 'st_conn_01_interword',
      title: 'Type 4: Inter-Word Legato Linking',
      description:
          'Link the ending of every word directly into the start of the next like a flowing musical piece.',
      clinicalRationale:
          'Connected speech blocks happen at the restart of vocal cord vibration between words. Continuous linking eliminates the restarts entirely.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.intermediate,
      defaultBpm: 60,
      durationSeconds: 120,
      tips: [
        'Do not stop vocal cord vibration between words.',
        'Think of your voice as a cello bow moving continuously across strings.',
      ],
      promptLines: SentencePracticeDatabase.connectedSpeechBlocks.take(12).toList(),
    ),
    Exercise(
      id: 'st_conn_02_chunking',
      title: 'Type 4: Paused Phrase Chunking',
      description:
          'Read sentences in 3-4 word chunked groups with deliberate diaphragmatic resets at every slash.',
      clinicalRationale:
          'Prevents air starvation and rush-induced connected speech blocks during long sentences.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 120,
      tips: [
        'Honor the slash pause—take a silent belly breath.',
        'Speak each chunk smoothly on a single exhale.',
      ],
      promptLines: SentencePracticeDatabase.connectedSpeechBlocks.skip(12).take(12).toList(),
    ),

    // COMBINED ALL-TYPE MASTER EXERCISES (2 EXERCISES)
    Exercise(
      id: 'st_comb_01_full_cascade',
      title: 'Combined: The Full Cascade Drill',
      description:
          'Practice sentences containing all 4 block positions (Initial, Medial, Final, and Connected) in one phrase.',
      clinicalRationale:
          'Comprehensive multi-position motor integration builds robust speech confidence across all phonetic environments.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 180,
      tips: [
        'Apply easy onset on initial words, pull-outs on medial words, clean release on final words, and legato linking between.',
        'Take your time and celebrate full control.',
      ],
      promptLines: SentencePracticeDatabase.combinedAllTypes.take(15).toList(),
    ),
    Exercise(
      id: 'st_comb_02_real_world',
      title: 'Combined: Conversational Mastery',
      description:
          'Real-world conversational sentences with mixed block targets for complete day-to-day generalization.',
      clinicalRationale:
          'Prepares the speaker for spontaneous, high-pressure conversations in professional and social settings.',
      category: ExerciseCategory.stammeringTypes,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.advanced,
      defaultBpm: 75,
      durationSeconds: 180,
      tips: [
        'Match each syllable to the pacer pulse.',
        'Keep your body grounded, shoulders down, and breath deep.',
      ],
      promptLines: SentencePracticeDatabase.combinedAllTypes.skip(15).take(15).toList(),
    ),

    // =========================================================================
    // MODULE 7 EXTENDED: 8 FULL READING PASSAGES
    // =========================================================================
    Exercise(
      id: 'reading_02_mountain',
      title: 'Passage: The Mountain Sanctuary',
      description:
          'Extended reading passage targeting initial and medial S-sound flow.',
      clinicalRationale:
          'Sustained reading builds long-term vocal stamina and automaticity of continuous airflow channels.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 180,
      tips: [
        'Take a quiet diaphragmatic breath at every full stop.',
        'Sigh gently into each "S" sound.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[0]],
    ),
    Exercise(
      id: 'reading_03_slow_living',
      title: 'Passage: The Art of Slow Living',
      description:
          'Extended reading passage targeting initial and medial P-sound light contacts.',
      clinicalRationale:
          'Trains conscious slow pacing and soft bilabial closure across literary prose.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 180,
      tips: [
        'Touch lips together with minimal pressure on all P-words.',
        'Read with an unhurried, calm tempo.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[1]],
    ),
    Exercise(
      id: 'reading_04_architecture',
      title: 'Passage: The Architecture of Change',
      description:
          'Extended reading passage targeting clean CH-affricate releases.',
      clinicalRationale:
          'Develops palatal agility and confident consonant release in connected discourse.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 180,
      tips: [
        'Pucker lips slightly on CH words and drop the jaw cleanly.',
        'Maintain steady diaphragmatic breath support.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[2]],
    ),
    Exercise(
      id: 'reading_05_forest',
      title: 'Passage: The Flow of the Forest',
      description:
          'Extended reading passage targeting soft F-sound tooth-on-lip placement.',
      clinicalRationale:
          'Conditions continuous air-stream flow through labiodental fricatives.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.intermediate,
      durationSeconds: 180,
      tips: [
        'Feel the warm air escaping on every F-word without biting down.',
        'Allow the voice to glide naturally from word to word.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[3]],
    ),
    Exercise(
      id: 'reading_06_ocean_tide',
      title: 'Passage: The Ocean’s Rhythm',
      description:
          'Connected speech passage designed for unbroken legato reading.',
      clinicalRationale:
          'Develops musical prosody and eliminates articulatory hesitation between words.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.metronome,
      difficulty: ExerciseDifficulty.intermediate,
      defaultBpm: 75,
      durationSeconds: 180,
      tips: [
        'Keep vocal cords vibrating continuously through word boundaries.',
        'Match the steady rhythm of the pacer.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[4]],
    ),
    Exercise(
      id: 'reading_07_wisdom_pause',
      title: 'Passage: The Wisdom of the Pause',
      description:
          'Reflective passage highlighting the strategic power of pausing in speech.',
      clinicalRationale:
          'Reconditions the psychological relationship with conversational silence.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 180,
      tips: [
        'Take generous, calm pauses at commas and periods.',
        'Notice how relaxed your body feels during every pause.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[5]],
    ),
    Exercise(
      id: 'reading_08_neuroplasticity',
      title: 'Passage: The Science of Neuroplasticity',
      description:
          'Scientific passage exploring how deliberate practice rewires the brain’s speech networks.',
      clinicalRationale:
          'Combines high-level cognitive engagement with motor speech execution.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.advanced,
      durationSeconds: 180,
      tips: [
        'Enunciate multi-syllabic scientific terms with light contacts.',
        'Breathe from your lower abdomen throughout.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[8]],
    ),
    Exercise(
      id: 'reading_09_letter_future',
      title: 'Passage: A Letter to My Future Voice',
      description:
          'Emotional and motivational passage cementing speech self-acceptance and freedom.',
      clinicalRationale:
          'Reduces speech-related shame and autonomic fear conditioning through self-compassion.',
      category: ExerciseCategory.reading,
      exerciseType: ExerciseType.textPrompt,
      difficulty: ExerciseDifficulty.beginner,
      durationSeconds: 180,
      tips: [
        'Read with genuine emotion, warmth, and unhurried ease.',
        'Feel the deep resonance of your voice in your chest.',
      ],
      promptLines: [SentencePracticeDatabase.bookReadingPassages[19]],
    ),
  ];
}

