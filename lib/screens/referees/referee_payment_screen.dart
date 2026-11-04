import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_booking_summary_screen.dart' show RefereeAvatar;
import 'referee_found_screen.dart';
import 'widgets/referee_venue_card.dart';

/// Payment for both flows.
///
/// * Quick Book: after paying, a random available referee nearby is assigned.
/// * Browse: the chosen referee is booked.
class RefereePaymentScreen extends StatefulWidget {
  const RefereePaymentScreen({super.key, required this.draft});

  final RefereeBookingDraft draft;

  @override
  State<RefereePaymentScreen> createState() => _RefereePaymentScreenState();
}

class _RefereePaymentScreenState extends State<RefereePaymentScreen> {
  static const _pageBg = Color(0xFF0B0D12);
  static const _mint = Color(0xFF3DDC97);
  static const _gold = Color(0xFFE3B34A);
  static const _card = Color(0xFF141820);

  int _tab = 1;
  int _method = 0;
  bool _isPaying = false;

  bool get _isQuick => widget.draft.autoMatch || widget.draft.official == null;

  /// Picks a random available referee for the sport (Quick Book).
  RefereeOfficial _pickRandomReferee() {
    final sport = widget.draft.sport.toLowerCase();
    var pool = dummyAvailableReferees
        .where((o) => o.available && o.sport.toLowerCase() == sport)
        .toList();
    if (pool.isEmpty) {
      pool = dummyAvailableReferees.where((o) => o.available).toList();
    }
    if (pool.isEmpty) pool = List.of(dummyAvailableReferees);
    return pool[Random().nextInt(pool.length)];
  }

  Future<void> _pay() async {
    if (_isPaying) return;
    setState(() => _isPaying = true);

    // Processing / matching loader.
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (_) => _ProcessingDialog(isQuick: _isQuick),
    );

    // TODO: replace with the real payment + booking API.
    await Future.delayed(Duration(milliseconds: _isQuick ? 2600 : 1500));
    if (!mounted) return;
    Navigator.of(context).pop(); // close loader

    final bookedDraft = _isQuick
        ? widget.draft.copyWith(autoMatch: true, official: _pickRandomReferee())
        : widget.draft;
    // TODO: send `widget.draft.toBookingPayload()` to the booking API.

    setState(() => _isPaying = false);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RefereeFoundScreen(draft: bookedDraft)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final official = widget.draft.official;
    final total = RefereeBookingDraft.rupees(widget.draft.totalAmount);

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
                          'Payment',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!_isQuick && official != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1638), Color(0xFF1A1228)],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Referee',
                              style: GoogleFonts.quicksand(
                                color: Colors.white54,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RefereeAvatar(official: official, size: 52),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        official.sport,
                                        style: GoogleFonts.quicksand(
                                          color: _mint,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: _mint,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    widget.draft.location,
                                    style: GoogleFonts.quicksand(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      RefereeVenueCard(draft: widget.draft),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Referee',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _isQuick
                                    ? 'To Be Assigned'
                                    : (official?.name ?? '—'),
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Schedule',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${widget.draft.dateLabel} • ${widget.draft.timeLabel}',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: Color(0xFF2A3140), height: 1),
                          ),
                          Row(
                            children: [
                              Text(
                                'Total Amount',
                                style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontSize: 16,
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
                    const SizedBox(height: 20),
                    Text(
                      'Select Your Payment Method',
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _MethodTab(
                            icon: Icons.credit_card_rounded,
                            label: 'Credit Card',
                            selected: _tab == 0,
                            onTap: () => setState(() => _tab = 0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MethodTab(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Wallet',
                            selected: _tab == 1,
                            onTap: () => setState(() => _tab = 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _OptionRow(
                      label: 'G Pay',
                      selected: _method == 0,
                      add: false,
                      onTap: () => setState(() => _method = 0),
                    ),
                    const SizedBox(height: 10),
                    _OptionRow(
                      label: 'Add UPI',
                      selected: false,
                      add: true,
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _OptionRow(
                      label: 'Add New Wallet',
                      selected: false,
                      add: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: GestureDetector(
                  onTap: _pay,
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
                      'Pay $total',
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

/// Loader shown while paying (and, for Quick Book, matching a referee).
class _ProcessingDialog extends StatelessWidget {
  const _ProcessingDialog({required this.isQuick});
  final bool isQuick;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 270,
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
            decoration: BoxDecoration(
              color: const Color(0xFF141820),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF252A33)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF3DDC97),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isQuick
                      ? 'Finding a referee near you…'
                      : 'Processing payment…',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isQuick
                      ? 'Payment received. Sending your request to eligible referees.'
                      : 'Please wait while we confirm your booking.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    color: Colors.white54,
                    fontSize: 12.5,
                    height: 1.35,
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

class _MethodTab extends StatelessWidget {
  const _MethodTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF3A4250) : const Color(0xFF252A33),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.add,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool add;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F28),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (add)
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              )
            else
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFFF6A33)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: selected ? null : Border.all(color: Colors.white24),
                ),
                child: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
