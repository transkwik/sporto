import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class RankingDarkCard extends StatelessWidget {
  const RankingDarkCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class RankingStatRow extends StatelessWidget {
  const RankingStatRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.labelColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.quicksand(color: labelColor ?? Colors.white70, fontSize: 13.5, fontWeight: labelColor != null ? FontWeight.w700 : FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.quicksand(
              color: valueColor ?? Colors.white,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class RankingDeltaText extends StatelessWidget {
  const RankingDeltaText({super.key, required this.delta});

  final int? delta;

  @override
  Widget build(BuildContext context) {
    if (delta == null) {
      return Text('—', style: GoogleFonts.quicksand(color: Colors.white38, fontSize: 12.5));
    }
    final up = delta! > 0;
    final color = up ? AppColors.mintGreen : const Color(0xFFFF5A5A);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(up ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded, size: 18, color: color),
        Text(
          '${delta!.abs()}',
          style: GoogleFonts.quicksand(color: color, fontSize: 12.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class RankingProfileButton extends StatelessWidget {
  const RankingProfileButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E28),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            color: const Color(0xFF5AC8FA),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

String rankingInitials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length >= 2) return '${words[0][0]}${words[1][0]}'.toUpperCase();
  final t = name.trim();
  return t.isEmpty ? '?' : t.substring(0, t.length >= 2 ? 2 : 1).toUpperCase();
}
