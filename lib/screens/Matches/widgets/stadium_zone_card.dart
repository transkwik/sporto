import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Single stadium zone row: zone name + occupancy on top, and a full-width
/// amber "Check In Here" pill underneath.
class StadiumZoneCard extends StatelessWidget {
  const StadiumZoneCard({
    super.key,
    required this.zoneName,
    required this.occupancyLabel,
    this.onCheckIn,
  });

  final String zoneName;
  final String occupancyLabel;
  final VoidCallback? onCheckIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  zoneName,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                occupancyLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onCheckIn,
            child: Container(
              width: double.infinity,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.amberAccent,
                borderRadius: BorderRadius.circular(23),
              ),
              child: const Text(
                'Check In Here',
                style: TextStyle(color: Colors.black, fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
