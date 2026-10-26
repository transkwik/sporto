import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bank_utils.dart';
import 'add_bank_account_screen.dart';
import 'providers/bank_provider.dart';

/// Actions shared by the bank screens (messages, confirmations, calls).
class BankActions {
  BankActions._();

  static void toast(
    BuildContext context,
    String message, {
    bool error = false,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: error ? const Color(0xFF5A1F28) : null,
        content: Text(
          message,
          style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static void openAdd(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddBankAccountScreen()));
  }

  static void openEdit(BuildContext context, Map<String, dynamic> account) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddBankAccountScreen(account: account)),
    );
  }

  static Future<void> setDefault(
    BuildContext context,
    Map<String, dynamic> account,
  ) async {
    final id = BankUtils.id(account);
    if (id == null) return;
    final provider = context.read<BankProvider>();
    final error = await provider.setDefault(id);
    if (!context.mounted) return;
    toast(
      context,
      error ?? 'Default bank account updated',
      error: error != null,
    );
  }

  static Future<void> delete(
    BuildContext context,
    Map<String, dynamic> account,
  ) async {
    final id = BankUtils.id(account);
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161A22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Delete bank account?',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          '${BankUtils.summary(account)} will be removed from your payout accounts.',
          style: GoogleFonts.quicksand(color: Colors.white70, height: 1.35),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.quicksand(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.quicksand(
                color: const Color(0xFFE85A6B),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final provider = context.read<BankProvider>();
    final error = await provider.deleteBank(id);
    if (!context.mounted) return;
    toast(context, error ?? 'Bank account deleted', error: error != null);
  }

  /// Small round icon button (edit / delete) shown under a bank card.
  /// Shows a spinner instead of the icon while [loading].
  static Widget iconAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onTap,
    Color color = Colors.white70,
    bool loading = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Opacity(
          opacity: onTap == null && !loading ? 0.4 : 1,
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: loading
                ? SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 17),
          ),
        ),
      ),
    );
  }

  /// Retry card shown when the list could not be loaded.
  static Widget errorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white38,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.quicksand(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
