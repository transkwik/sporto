import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import 'india_flag_icon.dart';

/// Frosted, pill-shaped phone number input with a fixed "+91" country code
/// prefix, matching the dark glassmorphism auth screens.
class GlassPhoneField extends StatelessWidget {
  const GlassPhoneField({super.key, required this.controller, this.focusNode});

  final TextEditingController controller;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.infoBlue.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(color: AppColors.infoBlue.withValues(alpha: 0.12), blurRadius: 14, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          const IndiaFlagIcon(),
          const SizedBox(width: 8),
          const Text(
            '+91',
            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white54, size: 20),
          const SizedBox(width: 14),
          Container(width: 1, height: 26, color: AppColors.glassBorderStrong),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w500),
              cursorColor: AppColors.primary,
              decoration: const InputDecoration(
                counterText: '',
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Mobile number',
                hintStyle: TextStyle(color: Colors.white38, fontSize: 15.5, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
