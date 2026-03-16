import 'package:flutter/material.dart';
import 'package:fruit_hub/core/utils/app_colors.dart';

class AnimatedOrderSuccessBadge extends StatefulWidget {
  const AnimatedOrderSuccessBadge({super.key});

  @override
  State<AnimatedOrderSuccessBadge> createState() =>
      _AnimatedOrderSuccessBadgeState();
}

class _AnimatedOrderSuccessBadgeState extends State<AnimatedOrderSuccessBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _badgeScale;
  late final Animation<double> _checkOpacity;
  late final Animation<double> _checkScale;

  static const List<Offset> _badgeOffsets = <Offset>[
    Offset(0, -34),
    Offset(24, -24),
    Offset(34, 0),
    Offset(24, 24),
    Offset(0, 34),
    Offset(-24, 24),
    Offset(-34, 0),
    Offset(-24, -24),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    _badgeScale = Tween<double>(
      begin: 0.88,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _checkOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 1, curve: Curves.easeOut),
    );
    _checkScale = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 1, curve: Curves.elasticOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(top: 22, left: 30, child: _DecorativeDot(size: 10)),
          const Positioned(
            top: 36,
            right: 26,
            child: _DecorativeDot(size: 14, opacity: 0.7),
          ),
          const Positioned(
            left: 20,
            child: _DecorativeDot(size: 8, opacity: 0.85),
          ),
          const Positioned(
            right: 18,
            bottom: 52,
            child: _DecorativeDot(size: 8, opacity: 0.85),
          ),
          const Positioned(
            bottom: 34,
            left: 40,
            child: _DecorativeDot(size: 12, outlined: true),
          ),
          const Positioned(
            bottom: 18,
            right: 34,
            child: _DecorativeDot(size: 10),
          ),
          ScaleTransition(
            scale: _badgeScale,
            child: SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (final offset in _badgeOffsets)
                    Transform.translate(
                      offset: offset,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.22),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: FadeTransition(
                      opacity: _checkOpacity,
                      child: ScaleTransition(
                        scale: _checkScale,
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeDot extends StatelessWidget {
  const _DecorativeDot({
    required this.size,
    this.outlined = false,
    this.opacity = 1,
  });

  final double size;
  final bool outlined;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF97B8A4).withValues(alpha: opacity);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: outlined ? Colors.transparent : color,
        border: outlined ? Border.all(color: const Color(0xFF60C587)) : null,
      ),
    );
  }
}
