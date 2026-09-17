import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/my_sport_info.dart';

class AddSportResult {
  const AddSportResult({required this.sport, required this.roleLabel});

  final MySportInfo sport;
  final String roleLabel;
}

const _sheetBg = Color(0xFF161A22);
const _fieldBg = Color(0xFF12151C);
const _cancelBg = Color(0xFF2A3140);
const _saveBlue = Color(0xFF5EC8F8);

/// Bottom sheet matching the Add Sport design: pick a sport and roles.
class AddSportSheet extends StatefulWidget {
  const AddSportSheet({super.key, required this.availableSports});

  final List<MySportInfo> availableSports;

  @override
  State<AddSportSheet> createState() => _AddSportSheetState();
}

class _AddSportSheetState extends State<AddSportSheet> {
  MySportInfo? _selectedSport;
  final Set<String> _roles = {};

  List<String> get _roleOptions {
    switch (_selectedSport?.id) {
      case 'football':
        return const [
          'Forward',
          'Midfielder',
          'Defender',
          'Goalkeeper',
          'Captain',
          'I play multiple roles',
        ];
      case 'basketball':
        return const [
          'Guard',
          'Forward',
          'Center',
          'Captain',
          'I play multiple roles',
        ];
      case 'volleyball':
        return const [
          'Spiker',
          'Setter',
          'Libero',
          'Captain',
          'I play multiple roles',
        ];
      case 'athletics':
        return const [
          'Sprinter',
          'Distance runner',
          'Jumper',
          'Thrower',
          'I play multiple roles',
        ];
      default:
        return const [
          'Batter',
          'Bowler',
          'All-rounder',
          'Wicketkeeper',
          'Captain',
          'I play multiple roles',
        ];
    }
  }

  void _toggleRole(String role) {
    setState(() {
      if (_roles.contains(role)) {
        _roles.remove(role);
      } else {
        _roles.add(role);
      }
    });
  }

  String _roleLabel() {
    final roles = _roles.where((r) => r != 'I play multiple roles').toList();
    if (roles.isEmpty && _roles.contains('I play multiple roles')) {
      return 'Role: Multiple';
    }
    if (roles.isEmpty) return 'Role: Player';
    return 'Role: ${roles.join(', ')}';
  }

  void _save() {
    if (_selectedSport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a sport'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      AddSportResult(sport: _selectedSport!, roleLabel: _roleLabel()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.quicksand();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
        decoration: const BoxDecoration(
          color: _sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Sport',
                          style: textStyle.copyWith(
                            color: AppColors.infoBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'What do you usually play?',
                          style: textStyle.copyWith(
                            color: Colors.white54,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.glassFillLighter,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const Icon(Icons.close_rounded, color: Colors.white70, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Select Sport',
                style: textStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              _SportDropdown(
                sports: widget.availableSports,
                selected: _selectedSport,
                onChanged: (sport) {
                  setState(() {
                    _selectedSport = sport;
                    _roles.clear();
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Choose your role',
                style: textStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              for (final role in _roleOptions)
                _RoleCheckRow(
                  label: role,
                  checked: _roles.contains(role),
                  onTap: () => _toggleRole(role),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _cancelBg,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Text(
                          'Cancel',
                          style: textStyle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: _save,
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _saveBlue,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: _saveBlue.withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Text(
                          'Save',
                          style: textStyle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SportDropdown extends StatelessWidget {
  const _SportDropdown({
    required this.sports,
    required this.selected,
    required this.onChanged,
  });

  final List<MySportInfo> sports;
  final MySportInfo? selected;
  final ValueChanged<MySportInfo> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MySportInfo>(
      color: const Color(0xFF1C212C),
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: onChanged,
      itemBuilder: (context) => [
        for (final sport in sports)
          PopupMenuItem<MySportInfo>(
            value: sport,
            child: Text(
              sport.name,
              style: GoogleFonts.quicksand(
                color: Colors.white,
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: _fieldBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A4150)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected?.name.toLowerCase() ?? 'e.g. cricket',
                style: GoogleFonts.quicksand(
                  color: selected == null ? Colors.white38 : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}

class _RoleCheckRow extends StatelessWidget {
  const _RoleCheckRow({
    required this.label,
    required this.checked,
    required this.onTap,
  });

  final String label;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: checked ? AppColors.infoBlue : Colors.white38,
                  width: 1.6,
                ),
                color: checked ? AppColors.infoBlue.withValues(alpha: 0.2) : Colors.transparent,
              ),
              child: checked
                  ? const Icon(Icons.check_rounded, size: 15, color: AppColors.infoBlue)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.quicksand(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
