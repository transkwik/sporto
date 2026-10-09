import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_payment_screen.dart';

/// Hourly → Confirm Booking (dummy).
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
    final assigned = official != null;
    final refereeFee = assigned ? '₹400' : '₹350';
    final platformFee = assigned ? '₹40' : '₹35';
    final total = assigned ? '₹440' : '₹385';

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
                        GlassBackButton(onTap: () => Navigator.of(context).pop()),
                        const SizedBox(width: 10),
                        Text(
                          assigned ? 'Booking Summary' : 'Confirm Booking',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    assigned
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2A1638), Color(0xFF1A1228)],
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: official.photoUrl != null
                                      ? Image.network(
                                          official.photoUrl!,
                                          width: 52,
                                          height: 52,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const SizedBox(width: 52, height: 52),
                                        )
                                      : const SizedBox(width: 52, height: 52),
                                ),
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
                                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(color: _mint, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Available',
                                      style: GoogleFonts.quicksand(
                                        color: _mint,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1A1228), Color(0xFF12161D)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('🏏', style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(
                                      draft.sport,
                                      style: GoogleFonts.quicksand(
                                        color: _mint,
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    Icon(Icons.location_on_rounded, color: _mint, size: 16),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'KPHB Indoor Stadium',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                          ),
                                          Text('Kompally, Hyderabad', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 14),
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
                          _MetaLabel('Tournament'),
                          _MetaValue('SPOTO Random Cricket — Hyderabad'),
                          const SizedBox(height: 12),
                          _MetaLabel('Venue'),
                          const _MetaValue('KPHB Indoor Stadium'),
                          const SizedBox(height: 12),
                          _MetaLabel('Location'),
                          const _MetaValue('Kompally, Hyderabad'),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF10141A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: const [
                                Expanded(child: _StatCell(label: 'Date', value: '24 Aug 2026')),
                                _StatDivider(),
                                Expanded(child: _StatCell(label: 'Start Time', value: '5:00 PM')),
                                _StatDivider(),
                                Expanded(child: _StatCell(label: 'Duration', value: '2 Hours')),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                text: 'Booking Type: ',
                                style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: draft.hourly ? 'Hourly' : 'Daily',
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
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
                              'This is a Quick Booking - your request goes out to eligible nearby referees after payment. The first to accept is assigned.',
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
                          _PayRow('Referee Fee', refereeFee),
                          const SizedBox(height: 10),
                          _PayRow('Platform Fee', platformFee),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Color(0xFF2A3140), height: 1),
                          ),
                          Row(
                            children: [
                              Text(
                                'Total Paid',
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
                      assigned ? 'Confirm & Pay $total' : 'Proceed To Booking',
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
        Text(label, style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5)),
        const Spacer(),
        Text(value, style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5)),
      ],
    );
  }
}
