import 'package:shared_preferences/shared_preferences.dart';
import '../models/practice_session_model.dart';

class StorageService {
  static const String _keySessions = 'pravaha_sessions';
  static const String _keyStreak = 'pravaha_streak';
  static const String _keyLastPracticeDate = 'pravaha_last_practice_date';
  static const String _keyDailyGoalMinutes = 'pravaha_daily_goal_minutes';

  static StorageService? _instance;
  final SharedPreferences _prefs;

  StorageService._(this._prefs);

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = StorageService._(prefs);
    }
    return _instance!;
  }

  /// Get all recorded practice sessions (sorted latest first)
  List<PracticeSession> getSessions() {
    final rawList = _prefs.getStringList(_keySessions) ?? [];
    return rawList
        .map((s) {
          try {
            return PracticeSession.fromJson(s);
          } catch (_) {
            return null;
          }
        })
        .whereType<PracticeSession>()
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Save a newly completed practice session and update streaks
  Future<void> saveSession(PracticeSession session) async {
    final sessions = getSessions();
    sessions.insert(0, session);

    final encodedList = sessions.map((s) => s.toJson()).toList();
    await _prefs.setStringList(_keySessions, encodedList);

    await _updateStreakOnPractice();
  }

  /// Delete a practice session
  Future<void> deleteSession(String sessionId) async {
    final sessions = getSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    final encodedList = sessions.map((s) => s.toJson()).toList();
    await _prefs.setStringList(_keySessions, encodedList);
  }

  /// Current practice streak (in days)
  int getStreakDays() {
    return _prefs.getInt(_keyStreak) ?? 1;
  }

  /// Daily goal in minutes (default 10 mins)
  int getDailyGoalMinutes() {
    return _prefs.getInt(_keyDailyGoalMinutes) ?? 10;
  }

  Future<void> setDailyGoalMinutes(int minutes) async {
    await _prefs.setInt(_keyDailyGoalMinutes, minutes);
  }

  /// Total practice minutes completed today
  int getTodayPracticeMinutes() {
    final today = DateTime.now();
    final sessions = getSessions();
    final todaySeconds = sessions
        .where((s) =>
            s.timestamp.year == today.year &&
            s.timestamp.month == today.month &&
            s.timestamp.day == today.day)
        .fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return (todaySeconds / 60).ceil();
  }

  /// Total practice sessions completed all-time
  int getTotalSessionsCount() {
    return getSessions().length;
  }

  /// Total practice minutes all-time
  int getTotalPracticeMinutes() {
    final sessions = getSessions();
    final totalSeconds =
        sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return (totalSeconds / 60).ceil();
  }

  Future<void> _updateStreakOnPractice() async {
    final now = DateTime.now();
    final lastDateStr = _prefs.getString(_keyLastPracticeDate);
    var currentStreak = _prefs.getInt(_keyStreak) ?? 0;

    if (lastDateStr == null) {
      currentStreak = 1;
    } else {
      final lastDate = DateTime.parse(lastDateStr);
      final differenceDays = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
          .inDays;

      if (differenceDays == 1) {
        currentStreak += 1;
      } else if (differenceDays > 1) {
        currentStreak = 1; // Reset streak if missed a day
      }
      // If differenceDays == 0, already practiced today, keep streak
    }

    await _prefs.setInt(_keyStreak, currentStreak);
    await _prefs.setString(_keyLastPracticeDate, now.toIso8601String());
  }
}
