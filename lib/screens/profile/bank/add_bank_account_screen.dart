import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/glass_back_button.dart';
import '../../../models/bank_account_info.dart';

class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  final _bank = TextEditingController();
  final _branch = TextEditingController();
  final _ifsc = TextEditingController();
  final _holder = TextEditingController();
  final _number = TextEditingController();

  @override
  void dispose() {
    _bank.dispose();
    _branch.dispose();
    _ifsc.dispose();
    _holder.dispose();
    _number.dispose();
    super.dispose();
  }

  void _save() {
    final bank = _bank.text.trim();
    final holder = _holder.text.trim();
    final number = _number.text.trim();
    final ifsc = _ifsc.text.trim();
    if (bank.isEmpty || holder.isEmpty || number.isEmpty || ifsc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill bank, IFSC, holder name and account number',
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    BankAccountStore.instance.add(
      BankAccount(
        id: 'bank-${DateTime.now().millisecondsSinceEpoch}',
        bankName: bank,
        shortLabel: bank.split(' ').first,
        ifsc: ifsc.toUpperCase(),
        holderName: holder,
        accountNumber: number,
        upiId: '${holder.split(' ').first.toLowerCase()}@okbank',
        accent: AppColors.infoBlue,
        mark: bank.substring(0, 1).toUpperCase(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.authBackgroundGradient),
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
                      'Add Bank Account',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12241C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.mintGreen.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lock_rounded, color: AppColors.mintGreen, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your information is encrypted, only used for payout verification.',
                              style: GoogleFonts.quicksand(
                                color: AppColors.mintGreen,
                                fontSize: 13,
                                height: 1.35,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _LabeledField(label: 'Bank Name', hint: 'Enter bank name', controller: _bank),
                    const SizedBox(height: 14),
                    _LabeledField(label: 'Branch Name', hint: 'Enter branch Name', controller: _branch),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: 'IFSC Code',
                      hint: 'Enter IFSC code',
                      controller: _ifsc,
                      caps: true,
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(label: 'Account Holder Name', hint: 'Enter account holder name', controller: _holder),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: 'Account Number',
                      hint: 'Enter account number',
                      controller: _number,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: _save,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.infoBlue,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.infoBlue.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Text(
                          'Save Bank',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.caps = false,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool caps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(color: Colors.white70, fontSize: 13.5),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: caps ? TextCapitalization.characters : TextCapitalization.words,
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5),
          cursorColor: AppColors.infoBlue,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.quicksand(color: Colors.white30, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFF161A22),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.infoBlue.withValues(alpha: 0.7)),
            ),
          ),
        ),
      ],
    );
  }
}
