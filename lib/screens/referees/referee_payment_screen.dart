import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/referee_info.dart';
import 'referee_found_screen.dart';

/// Booking Summary → Payment (dummy).
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

  @override
  Widget build(BuildContext context) {
    final official = widget.draft.official;
    final assigned = official != null;
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
                    if (assigned)
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
                              style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                            ),
                            const SizedBox(height: 8),
                            Row(
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
                                Column(
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
                                      official.sport,
                                      style: GoogleFonts.quicksand(color: _mint, fontSize: 13, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.location_on_rounded, color: _mint, size: 16),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('KPHB Indoor Stadium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                      Text('Kompally, Hyderabad', style: TextStyle(color: Colors.white54, fontSize: 12.5)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1228), Color(0xFF12161D)],
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
                                  widget.draft.sport,
                                  style: GoogleFonts.quicksand(color: _mint, fontSize: 14.5, fontWeight: FontWeight.w700),
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
                                      Text('KPHB Indoor Stadium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF252A33)),
                      ),
                      child: assigned
                          ? Row(
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
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Text('Referee', style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14)),
                                    const Spacer(),
                                    Text(
                                      'To Be Assigned',
                                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Text(
                                      'Total Amount',
                                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    Text(
                                      total,
                                      style: GoogleFonts.quicksand(color: _gold, fontSize: 16, fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Select Your Payment Method',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13.5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _MethodTab(
                          icon: Icons.credit_card_rounded,
                          label: 'Credit Card',
                          selected: _tab == 0,
                          onTap: () => setState(() => _tab = 0),
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: _MethodTab(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'Wallet',
                          selected: _tab == 1,
                          onTap: () => setState(() => _tab = 1),
                        )),
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RefereeFoundScreen(draft: widget.draft),
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
          border: Border.all(color: selected ? const Color(0xFF3A4250) : const Color(0xFF252A33)),
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
                child: const Icon(Icons.add_rounded, color: Colors.white70, size: 18),
              )
            else
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFFF6A33) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: selected ? null : Border.all(color: Colors.white24),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
