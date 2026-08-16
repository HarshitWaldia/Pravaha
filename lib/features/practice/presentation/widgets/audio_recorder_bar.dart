import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AudioRecorderBar extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onToggleRecord;
  final VoidCallback? onReset;

  const AudioRecorderBar({
    super.key,
    required this.isRecording,
    required this.onToggleRecord,
    this.onReset,
  });

  @override
  State<AudioRecorderBar> createState() => _AudioRecorderBarState();
}

class _AudioRecorderBarState extends State<AudioRecorderBar> {
  int _recordDurationSeconds = 0;
  Timer? _timer;

  @override
  void didUpdateWidget(covariant AudioRecorderBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _startTimer();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _stopTimer();
    }
  }

  void _startTimer() {
    _recordDurationSeconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordDurationSeconds++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: widget.isRecording
              ? AppColors.accentCoral.withAlpha(120)
              : AppColors.surfaceVariant,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isRecording) ...[
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentCoral,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatDuration(_recordDurationSeconds),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.accentCoral,
              ),
            ),
            const SizedBox(width: 16),
          ],
          IconButton.filled(
            onPressed: widget.onToggleRecord,
            style: IconButton.styleFrom(
              backgroundColor: widget.isRecording
                  ? AppColors.accentCoral
                  : AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(12),
            ),
            icon: Icon(
              widget.isRecording ? Icons.stop : Icons.mic,
              size: 26,
            ),
          ),
          if (widget.onReset != null && !widget.isRecording) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.onReset,
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
              tooltip: 'Reset Exercise',
            ),
          ],
        ],
      ),
    );
  }
}
