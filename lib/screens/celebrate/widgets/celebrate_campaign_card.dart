import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/celebrate_info.dart';

class CelebrateCampaignCard extends StatelessWidget {
  const CelebrateCampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
    this.onAction,
  });

  final CelebrateCampaign campaign;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  static const _pink = Color(0xFFE85AD4);
  static const _gold = Color(0xFFE3A93D);

  @override
  Widget build(BuildContext context) {
    final c = campaign;
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _gold.withValues(alpha: 0.55)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: _gold, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      c.badge,
                      style: GoogleFonts.quicksand(
                        color: _gold,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    size: 13,
                    color: c.isOpen ? _pink : _pink.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    c.isOpen ? 'Fan Support Open' : 'Fan Support Closed',
                    style: GoogleFonts.quicksand(
                      color: c.isOpen ? _pink : Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppAssets.sportoLogo,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44,
                    height: 44,
                    color: const Color(0xFF222632),
                    alignment: Alignment.center,
                    child: Icon(c.sportIcon, color: Colors.white70, size: 22),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.teamName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: c.sport,
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '  •  ${c.tournamentTitle}',
                            style: GoogleFonts.quicksand(
                              color: AppColors.infoBlue,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white38, size: 13),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            c.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.favorite_rounded, color: _pink, size: 14),
              const SizedBox(width: 5),
              Text(
                '${c.fans} Fans',
                style: GoogleFonts.quicksand(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${c.amountLabel} ',
                style: GoogleFonts.quicksand(
                  color: _pink,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Fan Support',
                style: GoogleFonts.quicksand(
                  color: _pink.withValues(alpha: 0.85),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (c.isOpen)
            Row(
              children: [
                const Icon(Icons.schedule_rounded, color: _gold, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    c.remainingLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: _pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.celebration_rounded, color: Colors.white, size: 15),
                        const SizedBox(width: 6),
                        Text(
                          'Celebrate',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          else
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2230),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF3A4A62)),
                  ),
                  child: Text(
                    'View Fan Support',
                    style: GoogleFonts.quicksand(
                      color: const Color(0xFF8AA0C0),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
