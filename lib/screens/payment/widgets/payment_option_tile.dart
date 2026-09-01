import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Trailing accessory style for a [PaymentOptionTile]: either a selectable
/// radio-style circle, or an "add new" square with a plus icon.
enum PaymentOptionTrailing { select, add }

/// Row for a single payment option (a saved wallet/UPI, or an "add new"
/// action) on the payment method screen.
class PaymentOptionTile extends StatelessWidget {
  const PaymentOptionTile({
    super.key,
    required this.label,
    this.selected = false,
    this.trailing = PaymentOptionTrailing.select,
    this.onTap,
  });

  final String label;
  final bool selected;
  final PaymentOptionTrailing trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing == PaymentOptionTrailing.select)
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: selected ? null : Border.all(color: Colors.white38, width: 1.5),
                ),
                child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
              )
            else
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white38),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white70, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}
