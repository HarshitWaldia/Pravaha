enum SoundProgressionLevel {
  initialVowel,
  medialPosition,
  finalPosition,
  consonantBlend,
  doubleTarget,
  complexTransition,
}

class SoundWordDrill {
  final String id;
  final String soundTarget;
  final String targetWord;
  final String phoneticBreakdown;
  final SoundProgressionLevel progressionLevel;
  final String progressionLabel;
  final String engineInstruction;
  final String clinicalTip;

  const SoundWordDrill({
    required this.id,
    required this.soundTarget,
    required this.targetWord,
    required this.phoneticBreakdown,
    required this.progressionLevel,
    required this.progressionLabel,
    required this.engineInstruction,
    required this.clinicalTip,
  });
}

class SoundModule {
  final String soundKey;
  final String title;
  final String phoneticClass;
  final String mechanicsFocus;
  final String description;
  final List<SoundWordDrill> wordDrills;

  const SoundModule({
    required this.soundKey,
    required this.title,
    required this.phoneticClass,
    required this.mechanicsFocus,
    required this.description,
    required this.wordDrills,
  });
}

class SoundWordDatabase {
  static const List<SoundModule> soundModules = [
    // Sound Module 1: The "S" Sound (Sibilant Fricative)
    SoundModule(
      soundKey: 'S',
      title: 'The "S" Sound',
      phoneticClass: 'Sibilant Alveolar Fricative',
      mechanicsFocus:
          'Managing tongue-tip air channel and maintaining continuous airflow without whistling or blocking.',
      description:
          'S-blocks occur when the tongue jams hard against the alveolar ridge, cutting off air. Practice maintaining a continuous stream of relaxed hiss.',
      wordDrills: [
        SoundWordDrill(
          id: 's_01',
          soundTarget: 'S',
          targetWord: 'Sun',
          phoneticBreakdown: 'Sssss — un',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '1. Initial Vowel',
          engineInstruction:
              'Continuous airflow check. Do not stop between the "S" and "un".',
          clinicalTip:
              'Start with a soft, steady sigh of air on "S" and gently glide into "un".',
        ),
        SoundWordDrill(
          id: 's_02',
          soundTarget: 'S',
          targetWord: 'Sea',
          phoneticBreakdown: 'Sssss — ee',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '2. Initial Vowel',
          engineInstruction:
              'Keep teeth close together, smile slightly to channel air forward.',
          clinicalTip:
              'Maintain soft cheek muscles. Avoid pressing the tongue hard to the teeth.',
        ),
        SoundWordDrill(
          id: 's_03',
          soundTarget: 'S',
          targetWord: 'Messy',
          phoneticBreakdown: 'Meh — ssss — ee',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '3. Medial Position',
          engineInstruction:
              'Hold the middle "S" for an extra second before hitting the final vowel.',
          clinicalTip:
              'Transition smoothly from the vowel "Meh" into the stream of "S".',
        ),
        SoundWordDrill(
          id: 's_04',
          soundTarget: 'S',
          targetWord: 'Castle',
          phoneticBreakdown: 'Ca — ssss — el',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '4. Medial Position',
          engineInstruction:
              'Avoid dropping the tongue early. Ensure the "S" is crisp before transitioning.',
          clinicalTip:
              'Keep continuous vocal cord tone going without abrupt restarts.',
        ),
        SoundWordDrill(
          id: 's_05',
          soundTarget: 'S',
          targetWord: 'Bus',
          phoneticBreakdown: 'Buh — sssss',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '5. Final Position',
          engineInstruction:
              'Extend the final tail of the word. Do not cut the air short.',
          clinicalTip:
              'Release the "s" into a gentle trailing breath instead of clamping the jaw shut.',
        ),
        SoundWordDrill(
          id: 's_06',
          soundTarget: 'S',
          targetWord: 'Pass',
          phoneticBreakdown: 'Pah — sssss',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '6. Final Position',
          engineInstruction:
              'Smooth transition from a lip sound (P) to a tongue air sound (S).',
          clinicalTip:
              'Keep the "P" light (light contact) so the vocal tract stays relaxed for the "S".',
        ),
        SoundWordDrill(
          id: 's_07',
          soundTarget: 'S',
          targetWord: 'Spoon',
          phoneticBreakdown: 'Sssss — poon',
          progressionLevel: SoundProgressionLevel.consonantBlend,
          progressionLabel: '7. Consonant Blend',
          engineInstruction:
              'Blend seamlessly. Keep the "S" soft to avoid explosive tension on the "P".',
          clinicalTip:
              'Think of "spoon" as riding the wave of air created by "ssss".',
        ),
        SoundWordDrill(
          id: 's_08',
          soundTarget: 'S',
          targetWord: 'Stop',
          phoneticBreakdown: 'Sssss — top',
          progressionLevel: SoundProgressionLevel.consonantBlend,
          progressionLabel: '8. Consonant Blend',
          engineInstruction:
              'Prevent a block on the "T" by keeping the preceding "S" flowing.',
          clinicalTip:
              'Touch the tongue tip lightly for "T" rather than pressing hard.',
        ),
      ],
    ),

    // Sound Module 2: The "CH" Sound (Affricate)
    SoundModule(
      soundKey: 'CH',
      title: 'The "CH" Sound',
      phoneticClass: 'Voiceless Postalveolar Affricate',
      mechanicsFocus:
          'Building explosive, sharp air release without dragging it out into an "SH" sound or jamming the tongue.',
      description:
          'CH combines a T-stop with an SH-release. Learn to trap air briefly and burst out without laryngeal tension.',
      wordDrills: [
        SoundWordDrill(
          id: 'ch_01',
          soundTarget: 'CH',
          targetWord: 'Chair',
          phoneticBreakdown: 'T-S-H — air',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '1. Initial Vowel',
          engineInstruction:
              'Explode the sound out sharply. Imagine it as a clean, effortless sneeze.',
          clinicalTip:
              'Pucker the lips slightly forward and drop the jaw freely into "air".',
        ),
        SoundWordDrill(
          id: 'ch_02',
          soundTarget: 'CH',
          targetWord: 'Chip',
          phoneticBreakdown: 'T-S-H — ip',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '2. Initial Vowel',
          engineInstruction:
              'Push tongue against roof of mouth lightly, then release cleanly into "ip".',
          clinicalTip:
              'Do not press with excessive jaw tension; let the air do the work.',
        ),
        SoundWordDrill(
          id: 'ch_03',
          soundTarget: 'CH',
          targetWord: 'Kitchen',
          phoneticBreakdown: 'Kih — tsch — en',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '3. Medial Position',
          engineInstruction:
              'Trap the air completely in the middle of the word before bursting into "en".',
          clinicalTip:
              'Use light articulatory contact on the "tsch" midpoint.',
        ),
        SoundWordDrill(
          id: 'ch_04',
          soundTarget: 'CH',
          targetWord: 'Nature',
          phoneticBreakdown: 'Nay — tsch — er',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '4. Medial Position',
          engineInstruction:
              'Clean mid-word transition. Ensure lips pucker forward slightly on "CH".',
          clinicalTip:
              'Glide effortlessly from the open vowel "Nay" into the affricate.',
        ),
        SoundWordDrill(
          id: 'ch_05',
          soundTarget: 'CH',
          targetWord: 'Match',
          phoneticBreakdown: 'Mah — tsch',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '5. Final Position',
          engineInstruction:
              'Stop the sound crisp at the end of the word. No trailing unvoiced air.',
          clinicalTip:
              'Close the word with a sharp, definite tongue lift.',
        ),
        SoundWordDrill(
          id: 'ch_06',
          soundTarget: 'CH',
          targetWord: 'Peach',
          phoneticBreakdown: 'Pee — tsch',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '6. Final Position',
          engineInstruction:
              'Transitions from closed lip (P) to sharp palate burst (CH).',
          clinicalTip:
              'Keep both consonant contacts light and bouncy.',
        ),
        SoundWordDrill(
          id: 'ch_07',
          soundTarget: 'CH',
          targetWord: 'Church',
          phoneticBreakdown: 'Tsch — er — tsch',
          progressionLevel: SoundProgressionLevel.doubleTarget,
          progressionLabel: '7. Double Target',
          engineInstruction:
              'High difficulty. Requires a clean initial burst and an identical final burst.',
          clinicalTip:
              'Use continuous phonation through the middle vowel "er".',
        ),
        SoundWordDrill(
          id: 'ch_08',
          soundTarget: 'CH',
          targetWord: 'Chips',
          phoneticBreakdown: 'Tsch — ip — sssss',
          progressionLevel: SoundProgressionLevel.complexTransition,
          progressionLabel: '8. Complex Transition',
          engineInstruction:
              'Sharp burst transitioning immediately to smooth flowing air on "S".',
          clinicalTip:
              'Combine CH burst with a relaxed S-tail release.',
        ),
      ],
    ),

    // Sound Module 3: The "F" Sound (Labiodental Fricative)
    SoundModule(
      soundKey: 'F',
      title: 'The "F" Sound',
      phoneticClass: 'Voiceless Labiodental Fricative',
      mechanicsFocus:
          'Correctly placing top teeth onto the bottom lip without biting down with hard, block-inducing tension.',
      description:
          'F-blocks occur when you clamp top teeth into the lower lip and stop airflow. Keep the contact light and air streaming.',
      wordDrills: [
        SoundWordDrill(
          id: 'f_01',
          soundTarget: 'F',
          targetWord: 'Fan',
          phoneticBreakdown: 'Ffffff — an',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '1. Initial Vowel',
          engineInstruction:
              'Bite lower lip gently. Blow air steadily before saying "an".',
          clinicalTip:
              'Feel the warm air escaping between upper teeth and lower lip.',
        ),
        SoundWordDrill(
          id: 'f_02',
          soundTarget: 'F',
          targetWord: 'Fox',
          phoneticBreakdown: 'Ffffff — ox',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '2. Initial Vowel',
          engineInstruction:
              'Keep vocal cords quiet during the "F" sound; it should be pure frictionless air.',
          clinicalTip:
              'Engage voicing smoothly only when opening into "ox".',
        ),
        SoundWordDrill(
          id: 'f_03',
          soundTarget: 'F',
          targetWord: 'Coffee',
          phoneticBreakdown: 'Caw — ffffff — ee',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '3. Medial Position',
          engineInstruction:
              'Keep lips relaxed during the middle transition.',
          clinicalTip:
              'Maintain vocal resonance so sound does not drop out.',
        ),
        SoundWordDrill(
          id: 'f_04',
          soundTarget: 'F',
          targetWord: 'Office',
          phoneticBreakdown: 'Aw — ffffff — is',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '4. Medial Position',
          engineInstruction:
              'Smoothly flow through the "F" straight into your other challenge sound ("S").',
          clinicalTip:
              'Move teeth from lower lip to alveolar ridge with fluid rhythm.',
        ),
        SoundWordDrill(
          id: 'f_05',
          soundTarget: 'F',
          targetWord: 'Leaf',
          phoneticBreakdown: 'Lee — ffffff',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '5. Final Position',
          engineInstruction:
              'Let the word fade out into a soft puff of air on your bottom lip.',
          clinicalTip:
              'Avoid clamping the jaw shut at the end.',
        ),
        SoundWordDrill(
          id: 'f_06',
          soundTarget: 'F',
          targetWord: 'Roof',
          phoneticBreakdown: 'Roo — ffffff',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '6. Final Position',
          engineInstruction:
              'Ensure lips do not close completely into a "B" or "P" sound.',
          clinicalTip:
              'Keep the lower lip slightly tucked under the upper incisors.',
        ),
        SoundWordDrill(
          id: 'f_07',
          soundTarget: 'F',
          targetWord: 'Flag',
          phoneticBreakdown: 'Ffffff — lag',
          progressionLevel: SoundProgressionLevel.consonantBlend,
          progressionLabel: '7. Consonant Blend',
          engineInstruction:
              'Slide tongue up to roof of mouth for "L" while blowing the "F".',
          clinicalTip:
              'Let the airflow bridge the tooth-lip position into the tongue elevation.',
        ),
        SoundWordDrill(
          id: 'f_08',
          soundTarget: 'F',
          targetWord: 'Frog',
          phoneticBreakdown: 'Ffffff — rog',
          progressionLevel: SoundProgressionLevel.consonantBlend,
          progressionLabel: '8. Consonant Blend',
          engineInstruction:
              'Avoid flattening the lip structure. Keep the "F" airy before pulling back into "R".',
          clinicalTip:
              'Start with a soft sigh through the teeth and sweep the tongue back for "rog".',
        ),
      ],
    ),

    // Sound Module 4: The "P" Sound (Bilabial Plosive)
    SoundModule(
      soundKey: 'P',
      title: 'The "P" Sound',
      phoneticClass: 'Voiceless Bilabial Plosive',
      mechanicsFocus:
          'Building clean lip-seal pressure and releasing cleanly without creating an internal throat block.',
      description:
          'P-blocks happen when lips press together with excessive isometric tension. Use Light Articulatory Contact to release with an effortless pop.',
      wordDrills: [
        SoundWordDrill(
          id: 'p_01',
          soundTarget: 'P',
          targetWord: 'Pen',
          phoneticBreakdown: 'P! — en',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '1. Initial Vowel',
          engineInstruction:
              'Press lips together gently, build light air pressure, and pop cleanly into "en".',
          clinicalTip:
              'Think of your lips as butterfly wings barely touching.',
        ),
        SoundWordDrill(
          id: 'p_02',
          soundTarget: 'P',
          targetWord: 'Pool',
          phoneticBreakdown: 'h-P! — ool',
          progressionLevel: SoundProgressionLevel.initialVowel,
          progressionLabel: '2. Initial Vowel',
          engineInstruction:
              'Use an "Easy Onset" approach: let out a tiny breath of air right before popping ("h-Pool").',
          clinicalTip:
              'Soft airflow prevents the vocal folds from clamping shut.',
        ),
        SoundWordDrill(
          id: 'p_03',
          soundTarget: 'P',
          targetWord: 'Happy',
          phoneticBreakdown: 'Ha — p! — ee',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '3. Medial Position',
          engineInstruction:
              'A brief, crisp micro-pause right on the double "P" before releasing into "ee".',
          clinicalTip:
              'Keep the chest and shoulders relaxed during the pause.',
        ),
        SoundWordDrill(
          id: 'p_04',
          soundTarget: 'P',
          targetWord: 'Open',
          phoneticBreakdown: 'Oh — p! — en',
          progressionLevel: SoundProgressionLevel.medialPosition,
          progressionLabel: '4. Medial Position',
          engineInstruction:
              'Transition cleanly from a wide open vowel into a light lip seal.',
          clinicalTip:
              'Maintain soft abdominal breath support.',
        ),
        SoundWordDrill(
          id: 'p_05',
          soundTarget: 'P',
          targetWord: 'Cup',
          phoneticBreakdown: 'Cuh — p!',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '5. Final Position',
          engineInstruction:
              'Pop the lips open sharply at the absolute end of the word.',
          clinicalTip:
              'Release the air cleanly rather than holding the lips closed.',
        ),
        SoundWordDrill(
          id: 'p_06',
          soundTarget: 'P',
          targetWord: 'Help',
          phoneticBreakdown: 'Hel — p!',
          progressionLevel: SoundProgressionLevel.finalPosition,
          progressionLabel: '6. Final Position',
          engineInstruction:
              'Ensure tongue drops down cleanly from "L" so lips can seal for "P".',
          clinicalTip:
              'Sequential movement: tongue touches ridge, drops, lips touch lightly, pop.',
        ),
        SoundWordDrill(
          id: 'p_07',
          soundTarget: 'P',
          targetWord: 'Plan',
          progressionLevel: SoundProgressionLevel.consonantBlend,
          progressionLabel: '7. Consonant Blend',
          phoneticBreakdown: 'P! — lan',
          engineInstruction:
              'Explode lips open directly into an upward tongue sweep for the "L".',
          clinicalTip:
              'Do not hesitate between the "P" pop and the "L" vowel glide.',
        ),
        SoundWordDrill(
          id: 'p_08',
          soundTarget: 'P',
          targetWord: 'Passport',
          phoneticBreakdown: 'P! — a — ssss — p! — ort',
          progressionLevel: SoundProgressionLevel.complexTransition,
          progressionLabel: '8. Complex Multi-Target',
          engineInstruction:
              'Boss Level: Double "P" targets combined with a sustained middle "S" flow.',
          clinicalTip:
              'Breakdown: Light P pop -> open "a" -> continuous "ssss" -> light P pop -> "ort".',
        ),
      ],
    ),
  ];
}
