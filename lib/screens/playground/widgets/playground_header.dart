import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Top row of the Playground screen: page title + a location dropdown on
/// the left, wallet balance chip and notification bell on the right.
class PlaygroundHeader extends StatelessWidget {
  const PlaygroundHeader({
    super.key,
    required this.location,
    required this.walletBalance,
    required this.onLocationTap,
    required this.onAddFunds,
    required this.onNotificationsTap,
  });

  final String location;
  final String walletBalance;
  final VoidCallback onLocationTap;
  final VoidCallback onAddFunds;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Playground',
                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: onLocationTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.amberAccent, size: 14),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.amberAccent, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.amberAccent, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onNotificationsTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.glassFillLighter,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.only(left: 12, right: 4, top: 4, bottom: 4),
          decoration: BoxDecoration(
            color: AppColors.glassFillLighter,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                walletBalance,
                style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAddFunds,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(color: AppColors.amberAccent, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add_rounded, color: Colors.black87, size: 17),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
