import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/payment_info.dart';
import '../../models/team_info.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/globalefunction/global_functions.dart';
import 'payment_success_screen.dart';
import 'widgets/cost_breakdown_card.dart';
import 'widgets/payment_match_card.dart';
import 'widgets/payment_method_tabs.dart';
import 'widgets/payment_option_tile.dart';

/// Payment method screen shown after confirming a team on the tournament
/// registration flow: match recap, cost breakdown, and payment options.
class PaymentMethodScreen extends StatefulWidget {
  final Map<String, dynamic> tournament;
  final Map<String, dynamic> team;

  const PaymentMethodScreen({
    super.key,
    required this.tournament,
    required this.team,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int _tabIndex = 1;
  int _selectedOption = 0;
  bool _isLoading = false;

  Future<void> _handlePay() async {
    if (_isLoading) return;

    final tournamentId = widget.tournament['id'] as int?;
    final teamId = widget.team['id'] as int?;

    if (tournamentId == null || teamId == null) {
      MCP.showMessage(context, "Missing tournament or team details.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Register Tournament
      final regResponse = await UserApis().registerTournament(tournamentId, {
        "team_id": teamId,
      });

      if (regResponse == null || regResponse['success'] != true) {
        throw Exception(regResponse?['message'] ?? 'Failed to register tournament.');
      }

      final registrationId = regResponse['data']['id'] as int?;
      final regStatus = regResponse['data']['registration_status'] as int?;
      final payStatus = regResponse['data']['payment_status'] as int?;

      if (registrationId == null) {
        throw Exception("Invalid registration ID received.");
      }

      if (regStatus == AppColors.REGISTRATION_COMPLETED || payStatus == AppColors.PAYMENT_PAID) {
        // Already paid and completed! Just navigate to success.
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => PaymentSuccessScreen(
                team: widget.team,
                tournament: widget.tournament,
              ),
            ),
            (route) => route.isFirst,
          );
        }
        return;
      }

      // 2. Initiate Payment (Mock)
      final initResponse = await UserApis().initiatePayment(registrationId, {
        "payment_method": "mock",
      });

      if (initResponse == null || initResponse['success'] != true) {
        throw Exception(initResponse?['message'] ?? 'Failed to initiate payment.');
      }

      final paymentId = initResponse['data']['payment_id'];
      final transactionId = initResponse['data']['transaction_id'];

      if (paymentId == null || transactionId == null) {
        throw Exception("Invalid payment details received.");
      }

      // 3. Verify Payment
      final verifyResponse = await UserApis().verifyPayment(registrationId, {
        "payment_id": paymentId,
        "transaction_id": transactionId,
      });

      if (verifyResponse == null || verifyResponse['success'] != true) {
        throw Exception(verifyResponse?['message'] ?? 'Failed to verify payment.');
      }

      // Success! Navigate to Success Screen and prevent going back to payment
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(
              team: widget.team,
              tournament: widget.tournament,
            ),
          ),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (mounted) {
        MCP.showMessage(context, e.toString().replaceAll("Exception: ", ""));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryFee = widget.tournament['registration_fee']?.toString() ?? '0';
    final double feeVal = double.tryParse(entryFee) ?? 0.0;
    final platformFeeStr = widget.tournament['platform_fee']?.toString() ?? '0';
    final double platformFee = double.tryParse(platformFeeStr) ?? 0.0;
    final double total = feeVal + platformFee;

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    GlassBackButton(onTap: () => Navigator.of(context).pop()),
                    const SizedBox(width: 14),
                      Text(
                      'Payment Method',
                        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  children: [
                    PaymentMatchCard(tournament: widget.tournament, team: widget.team),
                    const SizedBox(height: 16),
                    CostBreakdownCard(tournament: widget.tournament),
                    const SizedBox(height: 22),
                      Text(
                      'Select Your Payment Method',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 14),
                    PaymentMethodTabs(selectedIndex: _tabIndex, onSelect: (i) => setState(() => _tabIndex = i)),
                    const SizedBox(height: 18),
                    PaymentOptionTile(
                      label: 'G Pay',
                      selected: _selectedOption == 0,
                      onTap: () => setState(() => _selectedOption = 0),
                    ),
                    const SizedBox(height: 12),
                    PaymentOptionTile(label: 'Add UPI', trailing: PaymentOptionTrailing.add, onTap: () {}),
                    const SizedBox(height: 12),
                    PaymentOptionTile(label: 'Add New Wallet', trailing: PaymentOptionTrailing.add, onTap: () {}),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: GestureDetector(
                  onTap: _handlePay,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: AppColors.bannerGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF7A1E).withValues(alpha: 0.4),
                          blurRadius: 22,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Pay ₹${total.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
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
