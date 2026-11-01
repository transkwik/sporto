import 'package:flutter/material.dart';

/// Prize Details page (Individual Player Prize)
class PrizeDetailsScreenindividualPrise extends StatelessWidget {
  const PrizeDetailsScreenindividualPrise({super.key});

  static const List<_ProgressStep> _steps = [
    _ProgressStep('Tournament Completed', '26 Sep, 6:42 PM', _StepStatus.done),
    _ProgressStep('Final Result Verified', '26 Sep, 7:05 PM', _StepStatus.done),
    _ProgressStep('Winner Confirmed', '26 Sep, 7:06 PM', _StepStatus.done),
    _ProgressStep('Prize Calculated', '26 Sep, 7:20 PM', _StepStatus.done),
    _ProgressStep(
      'Prize Distribution Processing',
      'In progress',
      _StepStatus.active,
    ),
    _ProgressStep('Prize Credited to Wallet', null, _StepStatus.pending),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: _C.card,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prize Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '10 Aug 2026',
                        style: TextStyle(fontSize: 11, color: _C.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tournament card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cricket',
                      style: TextStyle(color: _C.orange, fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'ABC PREMIER LEAGUE 2026',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Chip(
                          label: 'Completed',
                          icon: Icons.check_circle_outline_rounded,
                          color: _C.green,
                        ),
                        _Chip(
                          label: 'Prize Processing',
                          icon: Icons.access_time_rounded,
                          color: _C.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Distribution progress
              const _SectionTitle('Distribution Progress'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                decoration: BoxDecoration(
                  color: _C.cardDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _steps.length; i++)
                      _TimelineRow(
                        step: _steps[i],
                        isLast: i == _steps.length - 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Individual player prize
              const _SectionTitle('Individual Player Prize'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _C.cardDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('🏆', style: TextStyle(fontSize: 13)),
                        SizedBox(width: 6),
                        Text(
                          'Best Batsmen Award',
                          style: TextStyle(color: _C.orangeDeep, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: _C.card,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.sports_cricket_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Shravan Prajapati',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Color(0xFF262B35),
                      height: 1,
                      thickness: 1,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Winning Prize',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Text(
                          '₹5,000',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _C.blue,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const _Chip(
                          label: 'Processing',
                          icon: Icons.access_time_rounded,
                          color: _C.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _C.orange, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'View Wallet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _C.orange,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Tournament Details',
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SecondaryButton(
                      label: 'Tournament History',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Need help with this prize?',
                    style: TextStyle(color: _C.green, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------
class _C {
  static const background = Color(0xFF0A0D14);
  static const card = Color(0xFF1B1F27);
  static const cardDark = Color(0xFF12161E);
  static const chip = Color(0xFF232A36);
  static const orange = Color(0xFFF5A00F);
  static const orangeDeep = Color(0xFFE8890C);
  static const green = Color(0xFF2EB872);
  static const blue = Color(0xFF4DB6F0);
  static const textSecondary = Color(0xFF8A8F99);
}

enum _StepStatus { done, active, pending }

class _ProgressStep {
  final String title;
  final String? subtitle;
  final _StepStatus status;
  const _ProgressStep(this.title, this.subtitle, this.status);
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 14, color: Color(0xFFB4B8C0)),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _Chip({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _C.chip,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final _ProgressStep step;
  final bool isLast;
  const _TimelineRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final lineColor = step.status == _StepStatus.done
        ? _C.green
        : const Color(0xFF3A3F49);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 26,
            child: Column(
              children: [
                _Indicator(status: step.status),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: step.subtitle == null ? 5 : 0,
                    ),
                    child: Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        color: step.status == _StepStatus.pending
                            ? _C.textSecondary
                            : Colors.white,
                      ),
                    ),
                  ),
                  if (step.subtitle != null)
                    Text(
                      step.subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _C.textSecondary,
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

class _Indicator extends StatelessWidget {
  final _StepStatus status;
  const _Indicator({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case _StepStatus.done:
        return Container(
          height: 26,
          width: 26,
          decoration: const BoxDecoration(
            color: _C.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 16,
            color: Color(0xFF0A2A1A),
          ),
        );
      case _StepStatus.active:
        return Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF16324A),
            border: Border.all(color: _C.blue, width: 2),
          ),
          child: Center(
            child: Container(
              height: 12,
              width: 12,
              decoration: const BoxDecoration(
                color: _C.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case _StepStatus.pending:
        return Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF3A3F49), width: 1.5),
          ),
        );
    }
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _C.card,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 44,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, color: _C.blue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
