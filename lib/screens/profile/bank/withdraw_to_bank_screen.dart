import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bank_utils.dart';
import '../../../core/widgets/glass_back_button.dart';
import 'bank_actions.dart';
import 'providers/bank_provider.dart';

/// Wallet → Withdraw to bank: pick a payout account or add one.
class WithdrawToBankScreen extends StatefulWidget {
  const WithdrawToBankScreen({super.key});

  @override
  State<WithdrawToBankScreen> createState() => _WithdrawToBankScreenState();
}

class _WithdrawToBankScreenState extends State<WithdrawToBankScreen> {
  static const _cyan = Color(0xFF3ADFA0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = context.read<BankProvider>();
      p.reset();
      p.fetchBanks();
    });
  }

  Future<void> _refresh() =>
      context.read<BankProvider>().fetchBanks(refresh: true);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    final accounts = provider.accounts;
    // The picked account, else the one flagged `is_default` by the API,
    // else the first one.
    final Map<String, dynamic>? selected = provider.selected;
    final int? selectedId = selected == null ? null : BankUtils.id(selected);

    Widget body;
    if (provider.isLoading && accounts.isEmpty) {
      body = const Center(
        child: CircularProgressIndicator(color: AppColors.mintGreen),
      );
    } else if (provider.error != null && accounts.isEmpty) {
      body = BankActions.errorView(
        message: provider.error!,
        onRetry: () => provider.fetchBanks(),
      );
    } else if (accounts.isEmpty) {
      body = RefreshIndicator(
        color: AppColors.mintGreen,
        backgroundColor: AppColors.secondary,
        onRefresh: _refresh,
        child: _EmptyState(onAdd: () => BankActions.openAdd(context)),
      );
    } else {
      body = RefreshIndicator(
        color: AppColors.mintGreen,
        backgroundColor: AppColors.secondary,
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 12, 12, 12),
              decoration: BoxDecoration(
                color: const Color(0xFF121A1E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _cyan.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      accounts.length == 1
                          ? '1 Bank Account'
                          : '${accounts.length} Banks Accounts',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _AddBankPill(onTap: () => BankActions.openAdd(context)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            for (final account in accounts) ...[
              _BankTile(
                account: account,
                selected: BankUtils.id(account) == selectedId,
                onTap: () => provider.select(BankUtils.id(account)),
              ),
              const SizedBox(height: 14),
            ],
            const SizedBox(height: 18),
            Center(
              child: GestureDetector(
                onTap: selected == null
                    ? null
                    : () => BankActions.toast(
                        context,
                        'Withdrawal to ${BankUtils.shortBankLabel(selected) ?? 'bank'} requested',
                      ),
                child: Opacity(
                  opacity: selected == null ? 0.5 : 1,
                  child: Container(
                    width: 290,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: AppColors.bannerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFF8A1E,
                          ).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      selected == null
                          ? 'Select a bank'
                          : 'Withdraw to ${BankUtils.shortBankLabel(selected) ?? 'bank'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
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
                      'Withdraw to bank',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1418),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE85A6B).withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFE85A6B),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No Bank Found! Please add your bank account.',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onAdd,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Add Bank',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Dashed rounded-rectangle "Add bank" pill from the design.
class _AddBankPill extends StatelessWidget {
  const _AddBankPill({required this.onTap});

  final VoidCallback onTap;

  static const _cyan = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: _cyan.withValues(alpha: 0.6),
          radius: 14,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: _cyan, size: 18),
              const SizedBox(width: 4),
              Text(
                'Add bank',
                style: GoogleFonts.quicksand(
                  color: _cyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

/// One bank in the withdraw list: logo box, bank name, holder, masked number
/// and a "Selected" mark. Anything the API does not send is simply left out.
class _BankTile extends StatelessWidget {
  const _BankTile({
    required this.account,
    required this.selected,
    required this.onTap,
  });

  final Map<String, dynamic> account;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF3ADFA0);

  @override
  Widget build(BuildContext context) {
    final holder = BankUtils.holderName(account);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0F1D18) : const Color(0xFF14171E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _green.withValues(alpha: 0.6)
                : AppColors.glassBorder,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.18),
                    blurRadius: 14,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1A2234),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.account_balance_rounded,
                color: AppColors.infoBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          BankUtils.bankName(account) ??
                              BankUtils.typeLabel(account),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: _green,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Selected',
                          style: GoogleFonts.quicksand(
                            color: _green,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (holder != null)
                    Text.rich(
                      TextSpan(
                        text: 'Account Holder Name: ',
                        style: GoogleFonts.quicksand(
                          color: Colors.white38,
                          fontSize: 13,
                        ),
                        children: [
                          TextSpan(
                            text: holder,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text.rich(
                    TextSpan(
                      text: 'A/c ',
                      style: GoogleFonts.quicksand(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: BankUtils.maskedNumber(account),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
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
