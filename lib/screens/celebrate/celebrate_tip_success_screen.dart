import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import 'celebrate_screen.dart';

class CelebrateTipSuccessScreen extends StatelessWidget {
  const CelebrateTipSuccessScreen({super.key, required this.draft});

  final CelebrateTipDraft draft;

  String get _tipId {
    final seed = draft.amount + draft.recipientName.hashCode.abs();
    return 'SPT-TIP-${(138000 + (seed % 9000)).toString()}';
  }

  void _home(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _viewCelebrate(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CelebrateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = draft.campaign;
    final dateLabel = DateFormat('dd MMM yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GlassBackButton(onTap: () => _home(context)),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E222C),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF5AE07A), Color(0xFF1FA85A)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mintGreen.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Icon(Icons.celebration_rounded, color: Color(0xFFE3A93D), size: 22),
                          const SizedBox(height: 10),
                          Text(
                            'Tip Sent Successfully!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: "You've celebrated ",
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: '${draft.recipientName}!',
                                  style: GoogleFonts.quicksand(
                                    color: const Color(0xFFE85AD4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3A1848), Color(0xFF161A22)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: const Color(0xFFE85AD4).withValues(alpha: 0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tournament',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.tournamentTitle,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            draft.recipientName,
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${c.sport}  •  ${c.teamName}',
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        children: [
                          _meta('Tips', '₹${draft.amount}'),
                          const SizedBox(height: 12),
                          _meta('Tip ID', _tipId),
                          const SizedBox(height: 12),
                          _meta('Date', dateLabel),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _home(context),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: AppColors.bannerGradient,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8A1E).withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Done',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: () => _viewCelebrate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1E28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorderStrong),
                          ),
                          child: Text(
                            'View Celebrate',
                            style: GoogleFonts.quicksand(
                              color: Colors.white70,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
