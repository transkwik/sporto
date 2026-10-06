import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/award_info.dart';

/// My Awards list → sponsor, prize, squad split (team), and payout meta.
class AwardDetailsScreen extends StatelessWidget {
  const AwardDetailsScreen({super.key, required this.award});

  final AwardPrize award;

  @override
  Widget build(BuildContext context) {
    final team = award.kind == AwardKind.teamSplit;
    final highlightLabel = team ? 'Your Share' : award.title;
    final highlightIcon = team ? Icons.celebration_rounded : Icons.emoji_events_rounded;
    final statusColor = award.isPaid ? AppColors.mintGreen : const Color(0xFFFF8A1E);
    final statusLabel = award.isPaid ? 'Paid' : 'Processing';

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Awards Details',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${award.referenceId}  ·  ${award.dateLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _SponsorCard(
                      award: award,
                      highlightLabel: highlightLabel,
                      highlightIcon: highlightIcon,
                    ),
                    if (team && award.teamPoolAmount != null) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1E28),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Total Team Award  ',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white70,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: award.teamPoolAmount,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (team && award.squad.isNotEmpty) ...[
                      const SizedBox(height: 22),
                      Text(
                        'Split Among Squad',
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                      ),
                      const SizedBox(height: 10),
                      for (final member in award.squad) ...[
                        _SquadRow(member: member),
                        const SizedBox(height: 8),
                      ],
                    ],
                    const SizedBox(height: 14),
                    Text(
                      'Awarded For',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xFF222632),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(award.sportIcon, color: Colors.white70, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  team ? award.title : award.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (team) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    award.subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Payment',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 10),
                    _Panel(
                      child: Column(
                        children: [
                          _MetaRow(label: 'Status', value: statusLabel, valueColor: statusColor),
                          const SizedBox(height: 12),
                          _MetaRow(label: 'Sponsorship ID', value: award.sponsorshipId),
                          const SizedBox(height: 12),
                          _MetaRow(label: 'Transaction Ref', value: award.transactionRef),
                          if (award.disbursedDate != null) ...[
                            const SizedBox(height: 12),
                            _MetaRow(label: 'Disbursed', value: award.disbursedDate!),
                          ],
                        ],
                      ),
                    ),
                    if (!award.isPaid) ...[
                      const SizedBox(height: 12),
                      Text(
                        '*Payout is being processed and will appear in your wallet once complete.',
                        style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12, height: 1.4),
                      ),
                    ],
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

class _SponsorCard extends StatelessWidget {
  const _SponsorCard({
    required this.award,
    required this.highlightLabel,
    required this.highlightIcon,
  });

  final AwardPrize award;
  final String highlightLabel;
  final IconData highlightIcon;

  @override
  Widget build(BuildContext context) {
    final badgeColor = award.sponsorActive ? const Color(0xFFFF8A1E) : AppColors.mintGreen;
    final badgeLabel = award.sponsorActive ? 'Active' : 'Completed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF222632),
                  shape: BoxShape.circle,
                ),
                child: Icon(award.sportIcon, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      award.sponsorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: AppColors.infoBlue,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Award sponsor',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: badgeColor),
                ),
                child: Text(
                  badgeLabel,
                  style: GoogleFonts.quicksand(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D2A1C), Color(0xFF1A5A38)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(highlightIcon, color: const Color(0xFFFFD56A), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      highlightLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFFB8E86A),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    award.amountLabel,
                    style: GoogleFonts.quicksand(
                      color: AppColors.mintGreen,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SquadRow extends StatelessWidget {
  const _SquadRow({required this.member});

  final AwardSquadShare member;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: member.isYou ? null : const Color(0xFF161A22),
        gradient: member.isYou
            ? const LinearGradient(
                colors: [Color(0xFF0D2A1C), Color(0xFF1A5A38)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: member.isYou ? null : Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: member.isYou ? const Color(0xFF2A4A38) : const Color(0xFF2A303C),
            child: Text(
              member.initials,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(
                color: member.isYou ? AppColors.mintGreen : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            member.amountLabel,
            style: GoogleFonts.quicksand(
              color: member.isYou ? AppColors.mintGreen : Colors.white70,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: child,
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: GoogleFonts.quicksand(
              color: valueColor ?? Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
