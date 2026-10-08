import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mahder_mobile/core/theme/app_colors.dart';

/// TikTok-style floating navigation buttons for task micro-task navigation
/// Displays as vertical floating buttons on the right side
class TaskNavigationBar extends StatelessWidget {
  final int currentIndex;
  final int totalCount;
  final bool canNavigatePrevious;
  final bool canNavigateNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onHistory;
  final GlobalKey? navigationKey;
  final bool compact;

  const TaskNavigationBar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.canNavigatePrevious,
    required this.canNavigateNext,
    this.onPrevious,
    this.onNext,
    this.onHistory,
    this.navigationKey,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final previousButton = _buildFloatingButton(
      icon: Icons.keyboard_arrow_up_rounded,
      onPressed: onPrevious,
      isEnabled: canNavigatePrevious,
    );
    final nextButton = _buildFloatingButton(
      icon: Icons.keyboard_arrow_down_rounded,
      onPressed: onNext,
      isEnabled: canNavigateNext,
    );
    final historyButton = onHistory == null
        ? null
        : _buildFloatingButton(
            icon: Icons.history_rounded,
            onPressed: onHistory,
          );

    if (compact) {
      return Row(
        key: navigationKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          previousButton,
          const SizedBox(width: 8),
          nextButton,
          if (historyButton != null) ...[
            const SizedBox(width: 8),
            historyButton,
          ],
        ],
      );
    }

    return Column(
      key: navigationKey,
      mainAxisSize: MainAxisSize.min,
      children: [
        previousButton,

        const SizedBox(height: 12),

        // Page indicator
        // _buildPageIndicator(),
        // const SizedBox(height: 12),

        nextButton,

        // History button (if provided)
        if (historyButton != null) ...[
          const SizedBox(height: 12),
          historyButton,
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    VoidCallback? onPressed,
    bool isEnabled = true,
  }) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            // Outer glow
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
            // Inner shadow for depth
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    Colors.white.withValues(alpha: 0.2),
                  ],
                  stops: const [0.0, 1.0],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2,
                ),
                boxShadow: [
                  // Inner highlight
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 4,
                    offset: const Offset(-2, -2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isEnabled ? onPressed : null,
                  customBorder: const CircleBorder(),
                  splashColor: AppColors.primary.withValues(alpha: 0.3),
                  highlightColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: 22,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
