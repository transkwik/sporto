import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Summarizes the line items for registration cost (registration fee,
/// platform fee, and total).
class CostBreakdownCard extends StatelessWidget {
  const CostBreakdownCard({super.key, required this.tournament});

  final Map<String, dynamic> tournament;

  @override
  Widget build(BuildContext context) {
    final entryFee = tournament['registration_fee']?.toString() ?? '0';
    final double feeVal = double.tryParse(entryFee) ?? 0.0;
    final parsedPlatform = double.tryParse(tournament['platform_fee']?.toString() ?? '') ?? 0.0;
    final double platformFee = parsedPlatform > 0 ? parsedPlatform : 15.0;
    final double total = feeVal + platformFee;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24), // matching design background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildRow('Registration Fee', '₹${feeVal.toStringAsFixed(0)}'),
          const SizedBox(height: 12),
          _buildRow('Platform Fee', '₹${platformFee.toStringAsFixed(0)}'),
          const SizedBox(height: 16),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(0)}',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.quicksand(
            color: Colors.white54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
