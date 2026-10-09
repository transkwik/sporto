import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_hub_screen.dart';
import 'widgets/referee_cta_button.dart';

/// Step 3: OTP-secured confirmation.
class RefereeConfirmedScreen extends StatefulWidget {
  const RefereeConfirmedScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereeConfirmedScreen> createState() => _RefereeConfirmedScreenState();
}

class _RefereeConfirmedScreenState extends State<RefereeConfirmedScreen> {
  final _otp = TextEditingController(text: '4821');

  @override
  void dispose() {
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final official = widget.draft.official;
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Confirmed',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Step 3 of 3',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                  children: [
                    Text(
                      'OTP-secured start and finish for every session',
                      style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141820),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            official?.name ?? 'Assigned official',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${widget.draft.sport}  •  ${widget.draft.location}',
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                          ),
                          if (official != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              official.feePerMatchLabel,
                              style: GoogleFonts.quicksand(
                                color: AppColors.amberAccent,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Session OTP',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 54,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLighter,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text(
                        _otp.text,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: RefereeCtaButton(
                  label: 'Go to Bookings',
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const RefereeHubScreen()),
                      (route) => route.isFirst,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
