import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_up_info.dart';
import 'team_up_payment_screen.dart';

/// Register Individually → Confirm Registration.
class TeamUpConfirmScreen extends StatelessWidget {
  const TeamUpConfirmScreen({super.key, required this.tournament});

  final TeamUpTournament tournament;

  String get _title {
    return tournament.title.replaceAll('\n', ' ').replaceAll(' - ', ' — ').replaceAll(' -', ' —');
  }

  void _confirm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TeamUpPaymentScreen(tournament: tournament)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = tournament;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Confirm Registration',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
                  children: [
                    Text(
                      'Tournament',
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161A22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF12151C),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.glassBorderStrong),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(t.sportIcon, color: Colors.white70, size: 18),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sport',
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      t.sport,
                                      style: GoogleFonts.quicksand(
                                        color: Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: Color(0xFF2A2E38), height: 1),
                          const SizedBox(height: 16),
                          _LabeledValue(label: 'Tournament', value: _title),
                          const SizedBox(height: 16),
                          _LabeledValue(label: 'Venue', value: t.venue),
                          const SizedBox(height: 16),
                          _LabeledValue(label: 'Format', value: t.formatLine),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _LabeledValue(label: 'Date', value: t.dateLabel),
                              ),
                              Container(
                                width: 1,
                                height: 42,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                                color: const Color(0xFF2A2E38),
                              ),
                              Expanded(
                                child: _LabeledValue(
                                  label: 'Entry Fee',
                                  value: '₹${t.entryFee}',
                                  alignEnd: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'By continuing you agree that SPOTO will assign you to a randomly balanced team - team requests are not accepted.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: Colors.white38,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _confirm(context),
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
                          'Confirm & Register',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
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
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final cross = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: cross,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.white38,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
