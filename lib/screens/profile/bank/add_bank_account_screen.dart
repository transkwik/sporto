import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bank_utils.dart';
import '../../../core/widgets/glass_back_button.dart';
import 'bank_actions.dart';
import 'providers/bank_provider.dart';

/// Adds a bank account, or edits one when [account] (raw API map) is given.
class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key, this.account});

  final Map<String, dynamic>? account;

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}

class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
  static final _ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  final _bankName = TextEditingController();
  final _ifsc = TextEditingController();
  final _holder = TextEditingController();
  final _number = TextEditingController();

  String? _bankNameError;
  String? _ifscError;
  String? _holderError;
  String? _numberError;

  bool get _isEdit =>
      widget.account != null && BankUtils.id(widget.account!) != null;

  @override
  void initState() {
    super.initState();
    // Prefill what the API already returns (bank name / holder, when present).
    final a = widget.account;
    if (a != null) {
      _bankName.text = BankUtils.bankName(a) ?? '';
      _holder.text = BankUtils.holderName(a) ?? '';
    }
  }

  @override
  void dispose() {
    _bankName.dispose();
    _ifsc.dispose();
    _holder.dispose();
    _number.dispose();
    super.dispose();
  }

  bool _validate() {
    final bankName = _bankName.text.trim();
    final ifsc = _ifsc.text.trim().toUpperCase();
    final holder = _holder.text.trim();
    final number = _number.text.trim();

    String? bankNameError;
    String? ifscError;
    String? holderError;
    String? numberError;

    if (bankName.isEmpty) {
      bankNameError = 'Enter the bank name';
    } else if (bankName.length < 2) {
      bankNameError = 'Bank name is too short';
    }

    if (ifsc.isEmpty) {
      ifscError = 'Enter the IFSC code';
    } else if (!_ifscRegex.hasMatch(ifsc)) {
      ifscError = 'Enter a valid IFSC (e.g. HDFC0001234)';
    }

    if (holder.isEmpty) {
      holderError = 'Enter the account holder name';
    } else if (holder.length < 2) {
      holderError = 'Name is too short';
    }

    if (number.isEmpty) {
      numberError = 'Enter the account number';
    } else if (number.length < 9 || number.length > 18) {
      numberError = 'Account number must be 9 to 18 digits';
    }

    setState(() {
      _bankNameError = bankNameError;
      _ifscError = ifscError;
      _holderError = holderError;
      _numberError = numberError;
    });
    return bankNameError == null &&
        ifscError == null &&
        holderError == null &&
        numberError == null;
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final provider = context.read<BankProvider>();
    if (provider.isSaving) return;
    if (!_validate()) return;

    final bankName = _bankName.text.trim();
    final ifsc = _ifsc.text.trim().toUpperCase();
    final holder = _holder.text.trim();
    final number = _number.text.trim();

    final String? error;
    if (_isEdit) {
      error = await provider.updateBank(
        BankUtils.id(widget.account!)!,
        bankName: bankName,
        accountNumber: number,
        accountHolder: holder,
        ifsc: ifsc,
      );
    } else {
      error = await provider.addBank(
        bankName: bankName,
        accountNumber: number,
        accountHolder: holder,
        ifsc: ifsc,
      );
    }
    if (!mounted) return;

    if (error != null) {
      BankActions.toast(context, error, error: true);
      return;
    }
    BankActions.toast(
      context,
      _isEdit ? 'Bank account updated' : 'Bank account added',
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.select<BankProvider, bool>((p) => p.isSaving);

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
                      _isEdit ? 'Edit Bank Account' : 'Add Bank Account',
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
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    _Banner(
                      icon: Icons.lock_rounded,
                      color: AppColors.mintGreen,
                      background: const Color(0xFF12241C),
                      text:
                          'Your information is encrypted, only used for payout verification.',
                    ),
                    if (_isEdit) ...[
                      const SizedBox(height: 10),
                      _Banner(
                        icon: Icons.info_outline_rounded,
                        color: AppColors.amberAccent,
                        background: const Color(0xFF2A2412),
                        text:
                            'For your security the saved details are hidden. Re-enter the full details for ${BankUtils.summary(widget.account!)}.',
                      ),
                    ],
                    const SizedBox(height: 18),
                    _LabeledField(
                      label: 'Bank Name',
                      hint: 'Enter bank name',
                      controller: _bankName,
                      errorText: _bankNameError,
                      enabled: !saving,
                      maxLength: 60,
                      onChanged: (_) {
                        if (_bankNameError != null) {
                          setState(() => _bankNameError = null);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: 'IFSC Code',
                      hint: 'Enter IFSC code',
                      controller: _ifsc,
                      errorText: _ifscError,
                      enabled: !saving,
                      caps: true,
                      maxLength: 11,
                      formatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9]'),
                        ),
                      ],
                      onChanged: (_) {
                        if (_ifscError != null)
                          setState(() => _ifscError = null);
                      },
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: 'Account Holder Name',
                      hint: 'Enter account holder name',
                      controller: _holder,
                      errorText: _holderError,
                      enabled: !saving,
                      maxLength: 60,
                      onChanged: (_) {
                        if (_holderError != null)
                          setState(() => _holderError = null);
                      },
                    ),
                    const SizedBox(height: 14),
                    _LabeledField(
                      label: 'Account Number',
                      hint: 'Enter account number',
                      controller: _number,
                      errorText: _numberError,
                      enabled: !saving,
                      keyboardType: TextInputType.number,
                      maxLength: 18,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) {
                        if (_numberError != null)
                          setState(() => _numberError = null);
                      },
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: saving ? null : _save,
                      child: Opacity(
                        opacity: saving ? 0.7 : 1,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.infoBlue,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.infoBlue.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isEdit ? 'Update Bank' : 'Save Bank',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
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

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.background,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.quicksand(
                color: color,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
    this.errorText,
    this.enabled = true,
    this.maxLength,
    this.formatters,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool caps;
  final String? errorText;
  final bool enabled;
  final int? maxLength;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChanged;

  static const _red = Color(0xFFE85A6B);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: c),
    );

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
          enabled: enabled,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: formatters,
          onChanged: onChanged,
          textCapitalization: caps
              ? TextCapitalization.characters
              : TextCapitalization.words,
          style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14.5),
          cursorColor: AppColors.infoBlue,
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            errorText: errorText,
            errorStyle: GoogleFonts.quicksand(
              color: _red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            hintStyle: GoogleFonts.quicksand(
              color: Colors.white30,
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xFF161A22),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: border(AppColors.glassBorder),
            disabledBorder: border(AppColors.glassBorder),
            focusedBorder: border(AppColors.infoBlue.withValues(alpha: 0.7)),
            errorBorder: border(_red.withValues(alpha: 0.8)),
            focusedErrorBorder: border(_red),
          ),
        ),
      ],
    );
  }
}
