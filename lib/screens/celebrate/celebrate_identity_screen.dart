import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/celebrate_info.dart';
import '../auth/providers/auth_provider.dart';
import 'celebrate_confirm_tip_screen.dart';
import 'celebrate_tip_screen.dart';
import 'widgets/celebrate_team_hero.dart';

class CelebrateIdentityScreen extends StatefulWidget {
  const CelebrateIdentityScreen({
    super.key,
    required this.campaign,
    required this.kind,
    required this.amount,
    this.message = '',
    this.player,
  });

  final CelebrateCampaign campaign;
  final CelebrateTipKind kind;
  final int amount;
  final String message;
  final CelebrateChampionPlayer? player;

  @override
  State<CelebrateIdentityScreen> createState() => _CelebrateIdentityScreenState();
}

class _CelebrateIdentityScreenState extends State<CelebrateIdentityScreen> {
  static const _pink = Color(0xFFE85AD4);

  bool _showName = true;
  String _displayName = 'Zoto';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<AuthProvider>().checkResponse?['user']?['profile'] ?? {};
    final name = (profile['full_name'] as String?)?.trim();
    if (name != null && name.isNotEmpty) _displayName = name.split(' ').first;
  }

  void _continue() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CelebrateConfirmTipScreen(
          draft: CelebrateTipDraft(
            campaign: widget.campaign,
            isPlayer: widget.kind == CelebrateTipKind.player,
            amount: widget.amount,
            showName: _showName,
            displayName: _displayName,
            player: widget.player,
            message: widget.message,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(width: 10),
                    Text(
                      'Your Identity',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    CelebrateTeamHero(campaign: widget.campaign),
                    const SizedBox(height: 22),
                    Text(
                      'How should the champion see your support?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _IdentityOption(
                      selected: _showName,
                      title: 'Show My Name',
                      subtitle: 'Displayed as "$_displayName"',
                      onTap: () => setState(() => _showName = true),
                    ),
                    const SizedBox(height: 10),
                    _IdentityOption(
                      selected: !_showName,
                      title: 'Tip Anonymously',
                      subtitle: 'Displayed as "Anonymous Fan"',
                      onTap: () => setState(() => _showName = false),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _continue,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: _pink.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Continue',
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

class _IdentityOption extends StatelessWidget {
  const _IdentityOption({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFFFF8A1E) : Colors.transparent,
                border: selected ? null : Border.all(color: Colors.white38, width: 1.5),
              ),
              child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
