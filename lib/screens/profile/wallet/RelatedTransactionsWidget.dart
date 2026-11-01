import 'package:flutter/material.dart';

class RelatedTransactionsWidget extends StatelessWidget {
  const RelatedTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 14),
        // ===== Header =====
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 4, 18, 25), // light sky blue
                Color.fromARGB(255, 5, 30, 41), // slightly deeper
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Related Transactions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ===== Transaction Cards =====
        _TransactionCard(
          icon: Icons.emoji_events_rounded,
          iconColor: const Color(0xFFFFB300),
          title: 'Match Award',
          subtitle: 'Man of the Match • Kondapur Super Over Cup...',
          amount: '+ ₹ 3,000',
          isCredit: true,
          date: 'Aug 2, 2026',
        ),
        const SizedBox(height: 10),
        _TransactionCard(
          icon: Icons.celebration_rounded,
          iconColor: const Color(0xFFFF6B9D),
          title: 'Fan Tip',
          subtitle: 'Sent to Rohit Naik • Team Thunder',
          amount: '- ₹200',
          isCredit: false,
          date: 'Aug 2, 2026',
        ),
        const SizedBox(height: 10),
        _TransactionCard(
          icon: Icons.replay_rounded,
          iconColor: Colors.white70,
          title: 'Refund',
          subtitle: 'Cancelled registration • Ameerpet League',
          amount: '+ ₹200',
          isCredit: true,
          date: 'Aug 2, 2026',
        ),
        const SizedBox(height: 10),
        _TransactionCard(
          icon: Icons.emoji_events_rounded,
          iconColor: const Color(0xFFFFB300),
          title: 'Team Award',
          subtitle: 'Best Team • Kondapur Super Over Cup Final',
          amount: '+ ₹5,000',
          isCredit: true,
          date: 'Aug 2, 2026',
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;
  final String date;

  const _TransactionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 14),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Amount + Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: isCredit ? const Color(0xFF4ADE80) : Colors.white,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
