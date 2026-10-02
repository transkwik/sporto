import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/globalefunction/global_functions.dart';
import '../../core/widgets/glass_back_button.dart';
import '../../models/team_up_info.dart';
import '../auth/providers/auth_provider.dart';
import 'team_up_confirm_screen.dart';

/// Team Up → Register Individually form.
class TeamUpRegisterScreen extends StatefulWidget {
  const TeamUpRegisterScreen({super.key, required this.tournament});

  final TeamUpTournament tournament;

  @override
  State<TeamUpRegisterScreen> createState() => _TeamUpRegisterScreenState();
}

class _TeamUpRegisterScreenState extends State<TeamUpRegisterScreen> {
  late final TextEditingController _nameController;
  DateTime? _dob;
  String _role = 'Batter';
  String _batting = 'Right-hand';
  String _bowling = 'Right-arm Pace';
  String? _wicketkeeper;
  String _experience = 'Intermediate';
  bool _namePrefillDone = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Zoto');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_namePrefillDone) return;
    _namePrefillDone = true;
    final profile = context.read<AuthProvider>().checkResponse?['user']?['profile'] ?? {};
    final name = (profile['full_name'] as String?)?.trim();
    if (name != null && name.isNotEmpty) _nameController.text = name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _dobLabel =>
      _dob == null ? 'DD/MM/YYYY' : DateFormat('dd/MM/yyyy').format(_dob!);

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.amberAccent,
              surface: Color(0xFF161A22),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dob = picked);
  }

  void _continue() {
    if (_nameController.text.trim().isEmpty) {
      MCP.showMessage(context, 'Enter your player name');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeamUpConfirmScreen(tournament: widget.tournament),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tournament;

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
                        'Register Individually',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
                    _SportNotice(sport: t.sport, icon: t.sportIcon),
                    const SizedBox(height: 20),
                    _FieldLabel('Player Name'),
                    const SizedBox(height: 8),
                    _DarkField(
                      child: TextField(
                        controller: _nameController,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: Colors.white70,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: false,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          hintText: 'Player name',
                          hintStyle: GoogleFonts.quicksand(
                            color: Colors.white38,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Date of Birth'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickDob,
                      child: _DarkField(
                        child: Text(
                          _dobLabel,
                          style: GoogleFonts.quicksand(
                            color: _dob == null ? Colors.white38 : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Playing Role'),
                    const SizedBox(height: 10),
                    _ChipWrap(
                      options: dummyTeamUpPlayingRoles,
                      selected: _role,
                      onSelect: (v) => setState(() => _role = v),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Batting Style'),
                    const SizedBox(height: 10),
                    _ChipWrap(
                      options: dummyTeamUpBattingStyles,
                      selected: _batting,
                      onSelect: (v) => setState(() => _batting = v),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Bowling Style'),
                    const SizedBox(height: 10),
                    _ChipWrap(
                      options: dummyTeamUpBowlingStyles,
                      selected: _bowling,
                      onSelect: (v) => setState(() => _bowling = v),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Wicketkeeper?'),
                    const SizedBox(height: 10),
                    _ChipWrap(
                      options: const ['Yes', 'No'],
                      selected: _wicketkeeper,
                      onSelect: (v) => setState(() => _wicketkeeper = v),
                    ),
                    const SizedBox(height: 18),
                    _FieldLabel('Experience Level'),
                    const SizedBox(height: 10),
                    _ChipWrap(
                      options: dummyTeamUpExperienceLevels,
                      selected: _experience,
                      onSelect: (v) => setState(() => _experience = v),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: GestureDetector(
                  onTap: _continue,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: AppColors.bannerGradient,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8A1E).withValues(alpha: 0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Continue',
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
      ),
    );
  }
}

class _SportNotice extends StatelessWidget {
  const _SportNotice({required this.sport, required this.icon});

  final String sport;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161A22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF12151C),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorderStrong),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  sport,
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'SPOTO assigns your squad after registration closes.',
              style: GoogleFonts.quicksand(
                color: Colors.white54,
                fontSize: 12.5,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        color: Colors.white60,
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  const _DarkField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2028),
        borderRadius: BorderRadius.circular(26),
      ),
      child: child,
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: [
        for (final option in options)
          GestureDetector(
            onTap: () => onSelect(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: selected == option ? const Color(0xFFF0C14B) : const Color(0xFF1A1E28),
                borderRadius: BorderRadius.circular(20),
                border: selected == option ? null : Border.all(color: AppColors.glassBorderStrong),
              ),
              child: Text(
                option,
                style: GoogleFonts.quicksand(
                  color: selected == option ? Colors.black87 : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
