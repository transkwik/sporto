import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Glass card with an amber "pending" ring shown after paying to join a
/// team: a glowing clock badge, a bold "REQUEST SENT!" title, and a short
/// message reminding the player the captain still needs to approve them.
class JoinRequestSentCard extends StatelessWidget {
  const JoinRequestSentCard({super.key, required this.teamName});

  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2430),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.amberAccent.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(color: AppColors.amberAccent.withValues(alpha: 0.18), blurRadius: 30, spreadRadius: 2),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 92,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFC15E), Color(0xFFE3A93D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: AppColors.amberAccent.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 1),
                ],
              ),
              child: const Icon(Icons.schedule_rounded, color: Colors.black87, size: 30),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'REQUEST SENT!',
            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
          Text(
            'Your payment is confirmed. $teamName\'s captain will review your request shortly.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 13.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}
