import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Dark glass search pill with a leading search icon and trailing mic icon,
/// matching the home dashboard styling.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.controller, this.onMicTap, this.hintText = 'Search cricket, football..'});

  final TextEditingController? controller;
  final VoidCallback? onMicTap;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.white38, size: 21),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
              ),
            ),
          ),
          GestureDetector(
            onTap: onMicTap,
            child: const Icon(Icons.mic_none_rounded, color: Colors.white38, size: 21),
          ),
        ],
      ),
    );
  }
}
