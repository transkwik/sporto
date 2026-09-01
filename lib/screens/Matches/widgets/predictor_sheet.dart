import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Bottom-sheet mini-game that asks the viewer to predict the next ball
/// outcome for streak points, then reveal the result.
class PredictorSheet extends StatefulWidget {
  const PredictorSheet({super.key, this.onRevealResult});

  final VoidCallback? onRevealResult;

  static Future<void> show(BuildContext context, {VoidCallback? onRevealResult}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PredictorSheet(onRevealResult: onRevealResult),
    );
  }

  @override
  State<PredictorSheet> createState() => _PredictorSheetState();
}

class _PredictorSheetState extends State<PredictorSheet> {
  static const List<(String label, String points)> _options = [
    ('W', '+40 pt'),
    ('1', '+15 pt'),
    ('2', '+20 pt'),
    ('3', '+25 pt'),
    ('4s', '+30 pt'),
    ('6s', '+45 pt'),
    ('Wd', '+20 pt'),
    ('Nb', '+20 pt'),
  ];

  int? _selectedIndex;

  void _handleReveal() {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onRevealResult?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: maxHeight),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          decoration: const BoxDecoration(
            color: Color(0xFF151B28),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Predictor',
                        style: TextStyle(color: AppColors.infoBlue, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.glassFillLight,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: const Text(
                          '0',
                          style: TextStyle(color: AppColors.infoBlue, fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "What's the next ball?",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Streak x1.0 multiplier active',
                    style: TextStyle(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cellWidth = (constraints.maxWidth - 36) / 4;
                      final cellHeight = cellWidth * 0.95;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          for (var i = 0; i < _options.length; i++)
                            SizedBox(
                              width: cellWidth,
                              height: cellHeight,
                              child: _OutcomeTile(
                                label: _options[i].$1,
                                points: _options[i].$2,
                                selected: _selectedIndex == i,
                                onTap: () => setState(() => _selectedIndex = i),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Free to predict • Points shown per outcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _handleReveal,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.infoBlue.withValues(alpha: 0.35),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Reveal Result',
                        style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutcomeTile extends StatelessWidget {
  const _OutcomeTile({
    required this.label,
    required this.points,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String points;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.infoBlue.withValues(alpha: 0.22) : const Color(0xFF1C2436),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.infoBlue : AppColors.glassBorder,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              points,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
