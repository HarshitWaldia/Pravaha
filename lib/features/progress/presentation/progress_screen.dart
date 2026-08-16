import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/practice_session_model.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final AudioService _audioService = AudioService();
  List<PracticeSession> _sessions = [];
  int _totalMinutes = 0;
  int _streakDays = 1;
  String? _currentlyPlayingPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _audioService.player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _currentlyPlayingPath = null);
      }
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final storage = await StorageService.getInstance();
    setState(() {
      _sessions = storage.getSessions();
      _totalMinutes = storage.getTotalPracticeMinutes();
      _streakDays = storage.getStreakDays();
      _isLoading = false;
    });
  }

  Future<void> _togglePlayRecording(String path) async {
    if (_currentlyPlayingPath == path) {
      await _audioService.stopAudio();
      setState(() => _currentlyPlayingPath = null);
    } else {
      await _audioService.playAudio(path);
      setState(() => _currentlyPlayingPath = path);
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    final storage = await StorageService.getInstance();
    await storage.deleteSession(sessionId);
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice & Progress', style: AppTypography.titleLarge),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHistory,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Stats Row
                    Row(
                      children: [
                        _buildStatBox(
                          icon: Icons.local_fire_department,
                          color: AppColors.accentAmber,
                          title: 'Streak',
                          value: '$_streakDays Days',
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          icon: Icons.timer,
                          color: AppColors.primary,
                          title: 'Total Time',
                          value: '$_totalMinutes Mins',
                        ),
                        const SizedBox(width: 12),
                        _buildStatBox(
                          icon: Icons.check_circle_outline,
                          color: AppColors.accentTeal,
                          title: 'Sessions',
                          value: '${_sessions.length}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Recordings & Practice History
                    const Text(
                      'Saved Practice Recordings',
                      style: AppTypography.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Listen back to trace your progression in vocal ease and confidence.',
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    if (_sessions.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.surfaceVariant),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.mic_none, size: 48, color: AppColors.textTertiary),
                            SizedBox(height: 12),
                            Text(
                              'No recordings yet',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Complete an exercise to see your history here.',
                              style: AppTypography.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _sessions.length,
                        separatorBuilder: (_, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final session = _sessions[index];
                          final hasAudio = session.audioFilePath != null &&
                              File(session.audioFilePath!).existsSync();
                          final isPlaying =
                              _currentlyPlayingPath == session.audioFilePath;
                          final dateStr = DateFormat('MMM d, h:mm a')
                              .format(session.timestamp);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.surfaceVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (hasAudio)
                                      IconButton.filled(
                                        onPressed: () => _togglePlayRecording(
                                            session.audioFilePath!),
                                        style: IconButton.styleFrom(
                                          backgroundColor: isPlaying
                                              ? AppColors.accentCoral
                                              : AppColors.primary,
                                        ),
                                        icon: Icon(
                                          isPlaying
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceVariant,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.check,
                                            color: AppColors.textTertiary,
                                            size: 20),
                                      ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            session.exerciseTitle,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '$dateStr • ${session.durationSeconds}s @ ${session.bpmUsed} BPM',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textTertiary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          size: 20,
                                          color: AppColors.textTertiary),
                                      onPressed: () =>
                                          _deleteSession(session.id),
                                    ),
                                  ],
                                ),
                                if (session.notes.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Note: ${session.notes}',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
