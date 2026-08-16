import 'dart:convert';

class PracticeSession {
  final String id;
  final String exerciseId;
  final String exerciseTitle;
  final DateTime timestamp;
  final int durationSeconds;
  final int bpmUsed;
  final String? audioFilePath;
  final int tensionRating; // 1 (Relaxed) to 5 (High tension)
  final int confidenceRating; // 1 (Low) to 5 (High confidence)
  final double estimatedWpm;
  final String notes;

  const PracticeSession({
    required this.id,
    required this.exerciseId,
    required this.exerciseTitle,
    required this.timestamp,
    required this.durationSeconds,
    required this.bpmUsed,
    this.audioFilePath,
    this.tensionRating = 2,
    this.confidenceRating = 4,
    this.estimatedWpm = 0.0,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'exerciseTitle': exerciseTitle,
      'timestamp': timestamp.toIso8601String(),
      'durationSeconds': durationSeconds,
      'bpmUsed': bpmUsed,
      'audioFilePath': audioFilePath,
      'tensionRating': tensionRating,
      'confidenceRating': confidenceRating,
      'estimatedWpm': estimatedWpm,
      'notes': notes,
    };
  }

  factory PracticeSession.fromMap(Map<String, dynamic> map) {
    return PracticeSession(
      id: map['id'] as String,
      exerciseId: map['exerciseId'] as String,
      exerciseTitle: map['exerciseTitle'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      bpmUsed: map['bpmUsed'] as int? ?? 80,
      audioFilePath: map['audioFilePath'] as String?,
      tensionRating: map['tensionRating'] as int? ?? 2,
      confidenceRating: map['confidenceRating'] as int? ?? 4,
      estimatedWpm: (map['estimatedWpm'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PracticeSession.fromJson(String source) =>
      PracticeSession.fromMap(json.decode(source) as Map<String, dynamic>);
}
