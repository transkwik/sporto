import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import 'payment_method_screen.dart';

/// Shown after a squad is confirmed, before payment.
class TournamentRegisteredScreen extends StatelessWidget {
  const TournamentRegisteredScreen({
    super.key,
    required this.tournament,
    required this.team,
  });

  final Map<String, dynamic> tournament;
  final Map<String, dynamic> team;

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name']?.toString() ?? 'Your team';
    final tournamentName = tournament['name']?.toString() ?? 'the tournament';
    final fee = tournament['registration_fee']?.toString() ?? '999';

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GlassBackButton(onTap: () => Navigator.of(context).pop()),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 36, 24, 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1E28),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 88,
                        height: 88,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2F3A),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2EDB4C),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2EDB4C).withValues(alpha: 0.45),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 34),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'REGISTERED!',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$teamName is confirmed for\n$tournamentName',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaymentMethodScreen(
                          tournament: tournament,
                          team: team,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      'Pay ₹$fee',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
