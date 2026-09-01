import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/my_sport_info.dart';
import 'widgets/add_sport_tile.dart';
import 'widgets/selected_sport_card.dart';

/// Profile → My Sports: pick sports (and optional roles) the user follows.
class MySportsScreen extends StatefulWidget {
  const MySportsScreen({super.key});

  @override
  State<MySportsScreen> createState() => _MySportsScreenState();
}

class _MySportsScreenState extends State<MySportsScreen> {
  late List<MySportInfo> _sports;

  @override
  void initState() {
    super.initState();
    _sports = List<MySportInfo>.from(dummyMySports);
  }

  List<MySportInfo> get _selected => _sports.where((s) => s.selected).toList();
  List<MySportInfo> get _available => _sports.where((s) => !s.selected).toList();

  void _toggle(MySportInfo sport) {
    setState(() {
      _sports = _sports.map((item) {
        if (item.id != sport.id) return item;
        final nextSelected = !item.selected;
        return item.copyWith(
          selected: nextSelected,
          roleLabel: nextSelected ? (item.roleLabel ?? 'Role: Player') : item.roleLabel,
        );
      }).toList();
    });
  }

  void _save() {
    final count = _selected.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count == 0 ? 'Select at least one sport to save.' : 'Saved $count sport${count == 1 ? '' : 's'}.',
        ),
        backgroundColor: count == 0 ? AppColors.error : AppColors.success,
      ),
    );
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
                    Expanded(
                      child: Text(
                        'My Sports',
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _save,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Save Preferences',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                  children: [
                    Text(
                      "Pick the sports you're interested in and, optionally, the role you usually play. This helps Spoto match you to the right tournaments, teams and recruitment requests.",
                      style: GoogleFonts.quicksand(
                        color: Colors.white54,
                        fontSize: 13.5,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final sport in _selected) ...[
                      SelectedSportCard(sport: sport, onTap: () => _toggle(sport)),
                      const SizedBox(height: 12),
                    ],
                    if (_available.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Add More Sports',
                        style: GoogleFonts.quicksand(
                          color: Colors.white54,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final sport in _available) ...[
                        AddSportTile(sport: sport, onTap: () => _toggle(sport)),
                        const SizedBox(height: 10),
                      ],
                    ],
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
