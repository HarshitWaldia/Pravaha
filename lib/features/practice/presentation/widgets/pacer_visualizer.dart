import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PacerVisualizer extends StatefulWidget {
  final int bpm;
  final bool isPlaying;
  final VoidCallback? onBeat;

  const PacerVisualizer({
    super.key,
    required this.bpm,
    this.isPlaying = true,
    this.onBeat,
  });

  @override
  State<PacerVisualizer> createState() => _PacerVisualizerState();
}

class _PacerVisualizerState extends State<PacerVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    // 60,000ms / BPM = millisecond duration per beat cycle
    final durationMs = (60000 / widget.bpm).round();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.18)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.18, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 4.0, end: 24.0),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 24.0, end: 4.0),
        weight: 50.0,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onBeat?.call();
      }
    });

    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PacerVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bpm != widget.bpm) {
      _controller.dispose();
      _initController();
    } else if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ambient ripple ring
              Container(
                width: 220 * _scaleAnimation.value,
                height: 220 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withAlpha(20),
                  border: Border.all(
                    color: AppColors.primary.withAlpha(40),
                    width: 2,
                  ),
                ),
              ),

              // Middle glow pulse
              Container(
                width: 170 * _scaleAnimation.value,
                height: 170 * _scaleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryContainer.withAlpha(180),
                      AppColors.primary.withAlpha(60),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Core breathing sphere
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF004D40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.graphic_eq,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.bpm} BPM',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
