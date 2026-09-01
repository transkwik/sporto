import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

/// Card representing a single team on the "Select Your Team" screen. Shows
/// a warm gradient highlight and a filled "Selected" pill when active, or
/// a plain glass card with an outlined "Select Team" pill otherwise.
class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.selected,
    required this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  final Map<String, dynamic> team;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
  }

  Color _getColor(String name) {
    final colors = [
      const Color(0xFFF95B3D),
      const Color(0xFF4A5568),
      const Color(0xFF38B2AC),
      const Color(0xFF4299E1),
      const Color(0xFF9F7AEA),
      const Color(0xFFED64A6),
    ];
    int hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamName = team['team_name'] ?? 'Unnamed Team';
    final captainId = team['captain_user_id']?.toString() ?? 'N/A';
    final playersCount = team['total_players']?.toString() ?? '0';
    final maxPlayers = team['sport']?['max_players']?.toString() ?? '11';
    final tournamentsPlayed = team['tournaments_played']?.toString() ?? '0';
    final updatedLabel = _formatDate(team['updated_at']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: selected ? AppColors.liveCardGradient : null,
        color: selected ? null : AppColors.glassFillLighter,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: selected ? Colors.transparent : AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: _getColor(teamName), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  _getInitials(teamName),
                  style: GoogleFonts.quicksand(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: GoogleFonts.quicksand(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'Captain ID: ',
                        style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12.5),
                        children: [
                          TextSpan(
                            text: captainId,
                            style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$playersCount/$maxPlayers Players • $tournamentsPlayed Tournaments Played',
                      style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white54, size: 20),
                color: const Color(0xFF1E232A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.glassBorder),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    onEdit?.call();
                  } else if (value == 'delete') {
                    onDelete?.call();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text('Edit', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 10),
                        Text('Delete', style: GoogleFonts.quicksand(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Updated $updatedLabel', style: GoogleFonts.quicksand(color: Colors.white54, fontSize: 11.5)),
              const Spacer(),
              _SelectionPill(selected: selected, onTap: onSelect),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionPill extends StatelessWidget {
  const _SelectionPill({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.glassFillLight,
          borderRadius: BorderRadius.circular(10),
          border: selected ? null : Border.all(color: AppColors.glassBorderStrong),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) const Icon(Icons.check_rounded, color: Colors.white, size: 15),
            if (selected) const SizedBox(width: 4),
            Text(
              selected ? 'Selected' : 'Select Team',
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
