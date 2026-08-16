class ScenarioDialogueStep {
  final String speakerName;
  final String speakerPrompt;
  final String userTargetResponse;
  final String speechStrategyTip;

  const ScenarioDialogueStep({
    required this.speakerName,
    required this.speakerPrompt,
    required this.userTargetResponse,
    required this.speechStrategyTip,
  });
}

class SpeakingScenario {
  final String id;
  final String title;
  final String category;
  final String contextDescription;
  final String iconName;
  final List<ScenarioDialogueStep> steps;

  const SpeakingScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.contextDescription,
    required this.iconName,
    required this.steps,
  });
}

class ScenarioLibrary {
  static const List<SpeakingScenario> allScenarios = [
    SpeakingScenario(
      id: 'scenario_cafe',
      title: 'Ordering at a Cafe',
      category: 'Daily Situations',
      contextDescription: 'Practice pacing and gentle onsets when ordering food under slight time pressure.',
      iconName: 'coffee',
      steps: [
        ScenarioDialogueStep(
          speakerName: 'Barista',
          speakerPrompt: 'Hi there! What can I get started for you today?',
          userTargetResponse: 'Hello! I would like a warm oat milk cappuccino, please.',
          speechStrategyTip: 'Take a calm breath before saying "Hello". Use gentle onset on "I would like".',
        ),
        ScenarioDialogueStep(
          speakerName: 'Barista',
          speakerPrompt: 'Sure thing. What size would you like for that?',
          userTargetResponse: 'A medium size, please. And could I also get a blueberry muffin?',
          speechStrategyTip: 'Use continuous phonation to link "medium size" without rushing.',
        ),
        ScenarioDialogueStep(
          speakerName: 'Barista',
          speakerPrompt: 'That will be five dollars. Would you like a receipt?',
          userTargetResponse: 'No thank you, that is everything. Have a great day!',
          speechStrategyTip: 'Smoothly connect "Have a great day" with an easy smile and relaxed shoulders.',
        ),
      ],
    ),
    SpeakingScenario(
      id: 'scenario_phone',
      title: 'Answering a Phone Call',
      category: 'Work & Professional',
      contextDescription: 'Practice self-introduction and clear articulation during phone openings.',
      iconName: 'phone',
      steps: [
        ScenarioDialogueStep(
          speakerName: 'Caller',
          speakerPrompt: 'Hello, is this the design department?',
          userTargetResponse: 'Good morning! Yes, you have reached the design team. My name is Harshit.',
          speechStrategyTip: 'Exhale slightly before voicing "Good morning". Give your name with deliberate, relaxed pacing.',
        ),
        ScenarioDialogueStep(
          speakerName: 'Caller',
          speakerPrompt: 'Great! Could you tell me when the project review meeting is scheduled for?',
          userTargetResponse: 'The meeting is scheduled for tomorrow at two in the afternoon.',
          speechStrategyTip: 'Pace each number clearly: "two... in the... af-ter-noon."',
        ),
      ],
    ),
    SpeakingScenario(
      id: 'scenario_intro',
      title: 'Group Self-Introduction',
      category: 'Social & Confidence',
      contextDescription: 'Introduce yourself in a meeting or social circle with composure and breath support.',
      iconName: 'group',
      steps: [
        ScenarioDialogueStep(
          speakerName: 'Host',
          speakerPrompt: 'Let us go around the circle and have everyone introduce themselves.',
          userTargetResponse: 'Hi everyone. I am pleased to be here today and look forward to our discussion.',
          speechStrategyTip: 'Pause for 1 second before starting. Release tension in your jaw and chest.',
        ),
      ],
    ),
  ];
}
