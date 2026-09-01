import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Two-way segmented toggle for choosing between "Credit Card" and
/// "Wallet" as the broad payment category.
class PaymentMethodTabs extends StatelessWidget {
  const PaymentMethodTabs({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            icon: Icons.credit_card_rounded,
            label: 'Credit Card',
            selected: selectedIndex == 0,
            onTap: () => onSelect(0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _TabButton(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Wallet',
            selected: selectedIndex == 1,
            onTap: () => onSelect(1),
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.icon, required this.label, required this.selected, required this.onTap});

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
          color: selected ? AppColors.glassFillLight : AppColors.glassFillLighter,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.glassBorderStrong : AppColors.glassBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.white54, size: 17),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
