import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/playground_team_info.dart';
import '../payment/widgets/payable_amount_card.dart';
import '../payment/widgets/payment_method_tabs.dart';
import '../payment/widgets/payment_option_tile.dart';
import 'join_request_sent_screen.dart';

/// Lightweight payment screen shown after tapping "Join Team": the
/// requester's individual entry fee share, a payment method picker, and a
/// "Pay" call to action that sends the join request.
class JoinTeamPaymentScreen extends StatefulWidget {
  const JoinTeamPaymentScreen({super.key, required this.team});

  final Map<String, dynamic> team;

  @override
  State<JoinTeamPaymentScreen> createState() => _JoinTeamPaymentScreenState();
}

class _JoinTeamPaymentScreenState extends State<JoinTeamPaymentScreen> {
  int _tabIndex = 1;
  int _selectedOption = 0;

  void _handlePay() {
    FocusScope.of(context).unfocus();
    final teamName =
        widget.team['team_name'] ?? widget.team['name'] ?? 'Unnamed Team';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => JoinRequestSentScreen(teamName: teamName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 14),
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    PayableAmountCard(
                      amount: '₹0',
                    ), // API doesn't provide fee yet
                    const SizedBox(height: 22),
                    const Text(
                      'Select Your Payment Method',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    PaymentMethodTabs(
                      selectedIndex: _tabIndex,
                      onSelect: (i) => setState(() => _tabIndex = i),
                    ),
                    const SizedBox(height: 18),
                    PaymentOptionTile(
                      label: 'G Pay',
                      selected: _selectedOption == 0,
                      onTap: () => setState(() => _selectedOption = 0),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      label: 'Add UPI',
                      trailing: PaymentOptionTrailing.add,
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(
                      label: 'Add New Wallet',
                      trailing: PaymentOptionTrailing.add,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: _handlePay,
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Pay ₹0', // API doesn't provide fee yet
                      style: TextStyle(
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
