import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

/// Top greeting row: time-of-day greeting + username on the left, wallet
/// balance chip and notification bell on the right.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.userName,
    required this.walletBalance,
    required this.onAddFunds,
    required this.onNotificationsTap,
  });

  final String greeting;
  final String userName;
  final String walletBalance;
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
              Text(
                greeting,
                style: GoogleFonts.quicksand(color: AppColors.amberAccent, fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.only(left: 12, right: 0, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: AppColors.glassFillLighter,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                walletBalance,
                style:GoogleFonts.quicksand(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onAddFunds,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration:   BoxDecoration(
                    borderRadius: BorderRadius. only( topRight: Radius.circular(7),  bottomRight: Radius.circular(7)),
                    
                    color: Color.fromARGB(255, 254, 148, 19), 
                    // shape: BoxShape.circle
                    ),
                  child: const Icon(Icons.add_rounded, color: Colors.black, size: 17),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onNotificationsTap,
          child: Container(
            // width: 40,
            // height: 40,
            // decoration: BoxDecoration(
            //   color: AppColors.glassFillLighter,
            //   shape: BoxShape.circle,
            //   border: Border.all(color: AppColors.glassBorder),
            // ),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 20),
          ),
        ),
      ],
    );
  }
}
