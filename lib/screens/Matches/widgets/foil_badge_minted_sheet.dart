import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Success bottom sheet shown after checking in at a stadium zone: confirms
/// the foil badge was minted for this match/zone with a points reward.
class FoilBadgeMintedSheet extends StatelessWidget {
  const FoilBadgeMintedSheet({
    super.key,
    required this.roundLabel,
    required this.teamAName,
    required this.teamBName,
    required this.zoneName,
    this.serialNumber = 185,
    this.pointsEarned = 50,
    this.onNice,
  });

  final String roundLabel;
  final String teamAName;
  final String teamBName;
  final String zoneName;
  final int serialNumber;
  final int pointsEarned;
  final VoidCallback? onNice;

  static Future<void> show(
    BuildContext context, {
    required String roundLabel,
    required String teamAName,
    required String teamBName,
    required String zoneName,
    int serialNumber = 185,
    int pointsEarned = 50,
    VoidCallback? onNice,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FoilBadgeMintedSheet(
        roundLabel: roundLabel,
        teamAName: teamAName,
        teamBName: teamBName,
        zoneName: zoneName,
        serialNumber: serialNumber,
        pointsEarned: pointsEarned,
        onNice: onNice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          decoration: const BoxDecoration(
            color: Color(0xFF151B28),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'FOIL BADGE MINTED',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.infoBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2436),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.55)),
                        ),
                        child: Text(
                          roundLabel,
                          style: const TextStyle(
                            color: AppColors.mintGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        '$teamAName Vs $teamBName',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$zoneName · Serial #$serialNumber',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2436),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Text(
                      '+$pointsEarned points earned 🎉',
                      style: const TextStyle(
                        color: AppColors.amberAccent,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onNice?.call();
                    });
                  },
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
                      'Nice!',
                      style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
