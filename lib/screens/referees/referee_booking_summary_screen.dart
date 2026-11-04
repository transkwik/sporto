import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_payment_screen.dart';
import 'widgets/referee_venue_card.dart';

/// Confirm Booking (Quick Book, referee "To Be Assigned") or
/// Booking Summary (Browse, a chosen referee). Both continue to Payment.
class RefereeBookingSummaryScreen extends StatelessWidget {
  const RefereeBookingSummaryScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _gold = Color(0xFFE3B34A);
  static const _card = Color(0xFF141820);

  @override
  Widget build(BuildContext context) {
    final official = draft.official;
    final isQuick = draft.autoMatch || official == null;
    final total = RefereeBookingDraft.rupees(draft.totalAmount);

    return Scaffold(
      backgroundColor: _pageBg,
      body: ColoredBox(
        color: _pageBg,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                  children: [
                    Row(
                      children: [
                        GlassBackButton(
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isQuick ? 'Confirm Booking' : 'Booking Summary',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (isQuick)
                      RefereeVenueCard(draft: draft)
                    else
                      _RefereeHeader(official: official!),
                    const SizedBox(height: 14),

                    // Booking details
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isQuick) ...[
                            const _MetaLabel('Sport'),
                            _MetaValue(draft.sport),
                            const SizedBox(height: 12),
                            const _MetaLabel('Venue'),
                            _MetaValue(draft.venueTitle),
                            const SizedBox(height: 12),
                          ],
                          const _MetaLabel('Location'),
                          _MetaValue(
                            draft.venueSubtitle.isNotEmpty
                                ? draft.venueSubtitle
                                : draft.venueTitle,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF10141A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _StatCell(
                                    label: 'Date',
                                    value: draft.dateLabel,
                                  ),
                                ),
                                const _StatDivider(),
                                Expanded(
                                  child: _StatCell(
                                    label: 'Start Time',
                                    value: draft.timeLabel,
                                  ),
                                ),
                                const _StatDivider(),
                                Expanded(
                                  child: _StatCell(
                                    label: 'Duration',
                                    value: draft.durationLabel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Booking Type: ',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                                children: [
                                  TextSpan(
                                    text: draft.bookingTypeLabel,
                                    style: GoogleFonts.quicksand(
                                      color: _mint,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (draft.endLabel.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Center(
                              child: Text(
                                'Ends: ${draft.endLabel}',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white54,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Info note
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A160C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF6A5420)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.circle, size: 7, color: _gold),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isQuick
                                  ? 'This is a Quick Booking - your request goes out to eligible nearby referees after payment. The first to accept is assigned.'
                                  : 'You have chosen ${official!.name}. The referee is booked as soon as your payment succeeds.',
                              style: GoogleFonts.quicksand(
                                color: _gold,
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Payment breakdown
                    Text(
                      'Payment',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xFF4EB4E8),
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Column(
                        children: [
                          _PayRow(
                            'Referee Fee (${draft.feeBreakdownLabel})',
                            RefereeBookingDraft.rupees(draft.refereeFee),
                          ),
                          const SizedBox(height: 10),
                          _PayRow(
                            'Platform Fee',
                            RefereeBookingDraft.rupees(draft.platformFee),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Color(0xFF2A3140), height: 1),
                          ),
                          Row(
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                total,
                                style: GoogleFonts.quicksand(
                                  color: _gold,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: GestureDetector(
                  onTap: () {
                    // Print the booking API payload in the exact key order.
                    draft.printBookingPayload();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefereePaymentScreen(draft: draft),
                      ),
                    );
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Text(
                      isQuick ? 'Proceed To Booking' : 'Confirm & Pay $total',
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

class _RefereeHeader extends StatelessWidget {
  const _RefereeHeader({required this.official});
  final RefereeOfficial official;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1638), Color(0xFF1A1228)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          RefereeAvatar(official: official, size: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  official.name,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${official.sport}  •  ${official.experienceYears} yrs  •  ${official.level}',
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF3DDC97),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Available',
            style: GoogleFonts.quicksand(
              color: const Color(0xFF3DDC97),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular referee photo with an initials fallback (shared by booking screens).
class RefereeAvatar extends StatelessWidget {
  const RefereeAvatar({super.key, required this.official, this.size = 52});

  final RefereeOfficial official;
  final double size;

  @override
  Widget build(BuildContext context) {
    final parts = official.name.trim().split(RegExp(r'\s+'));
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'
        : official.name.isNotEmpty
        ? official.name[0]
        : 'R';
    final fallback = Container(
      width: size,
      height: size,
      color: const Color(0xFF2A241C),
      alignment: Alignment.center,
      child: Text(
        initials.toUpperCase(),
        style: GoogleFonts.quicksand(
          color: AppColors.amberAccent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: official.photoUrl != null
          ? Image.network(
              official.photoUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            )
          : fallback,
    );
  }
}

class _MetaLabel extends StatelessWidget {
  const _MetaLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12),
    );
  }
}

class _MetaValue extends StatelessWidget {
  const _MetaValue(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        color: Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 11.5),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.quicksand(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 44, color: const Color(0xFF2A3140));
  }
}

class _PayRow extends StatelessWidget {
  const _PayRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
        ),
      ],
    );
  }
}
