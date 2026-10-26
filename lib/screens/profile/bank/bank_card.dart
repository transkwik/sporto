import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bank_utils.dart';
import 'bank_actions.dart';
import 'providers/bank_provider.dart';

/// One saved bank account. The radio and the highlight colour follow the
/// `is_default` key from the list API; tapping the card (or radio) calls the
/// set-default API. Edit and delete are small icons at the bottom.
class BankCard extends StatelessWidget {
  const BankCard({super.key, required this.account});

  final Map<String, dynamic> account;

  static const _cyan = Color(0xFF3ADFA0);
  static const _red = Color(0xFFE85A6B);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BankProvider>();
    final id = BankUtils.id(account);
    final busy = provider.isBusy(id);
    final isDefault = BankUtils.isDefault(account);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: busy || id == null || isDefault
          ? null
          : () => BankActions.setDefault(context, account),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: isDefault ? const Color(0xFF122420) : const Color(0xFF161A22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDefault
                ? _cyan.withValues(alpha: 0.75)
                : AppColors.glassBorder,
            width: isDefault ? 1.4 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    BankUtils.maskedNumber(account),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: busy
                      ? const Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: AppColors.mintGreen,
                          ),
                        )
                      : Icon(
                          isDefault
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: isDefault ? _cyan : Colors.white38,
                          size: 24,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _kv('Bank Name', BankUtils.bankName(account) ?? '—'),
            const SizedBox(height: 10),
            _kv('Type', BankUtils.typeLabel(account)),
            const SizedBox(height: 10),
            _kv('Account', BankUtils.summary(account)),
            const SizedBox(height: 10),
            _kv(
              'Status',
              isDefault ? 'Default' : 'Not default',
              valueColor: isDefault ? _cyan : null,
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BankActions.iconAction(
                  icon: Icons.edit_outlined,
                  tooltip: 'Edit',
                  color: AppColors.infoBlue,
                  onTap: busy
                      ? null
                      : () => BankActions.openEdit(context, account),
                ),
                const SizedBox(width: 10),
                BankActions.iconAction(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete',
                  color: _red,
                  onTap: busy
                      ? null
                      : () => BankActions.delete(context, account),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.quicksand(
              color: valueColor ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
