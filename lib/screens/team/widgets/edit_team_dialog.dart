import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/globalefunction/global_functions.dart';
import '../../home/providers/home_provider.dart';
import '../../onboarding/widgets/profile_text_field.dart';

class EditTeamDialog extends StatefulWidget {
  final Map<String, dynamic> team;

  const EditTeamDialog({super.key, required this.team});

  @override
  State<EditTeamDialog> createState() => _EditTeamDialogState();
}

class _EditTeamDialogState extends State<EditTeamDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.team['team_name'] ?? '');
    _cityController = TextEditingController(text: widget.team['city'] ?? '');
    _nameController.addListener(_onChange);
    _cityController.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  bool get _isValid => _nameController.text.trim().isNotEmpty && _cityController.text.trim().isNotEmpty;

  Future<void> _handleSave() async {
    if (!_isValid) return;

    final provider = Provider.of<HomeProvider>(context, listen: false);
    final params = {
      "team_name": _nameController.text.trim(),
      "city": _cityController.text.trim(),
    };

    final success = await provider.updateTeam(widget.team['id'], params);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        MCP.showMessage(
          context,
          "Team updated successfully.",
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle_rounded,
        );
      } else {
        MCP.showMessage(context, provider.errorMessage ?? "Failed to update team.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.authBackgroundBottom,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      title: Text(
        'Edit Team',
        style: GoogleFonts.quicksand(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileTextField(
              label: 'Team Name',
              hint: 'Enter your team name',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              label: 'City',
              hint: 'Enter your city',
              controller: _cityController,
            ),
          ],
        ),
      ),
      actions: [
        Consumer<HomeProvider>(
          builder: (context, provider, child) {
            final isLoading = provider.isUpdatingTeam;
            return Wrap(
              spacing: 8,
              children: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel', style: GoogleFonts.quicksand(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: (_isValid && !isLoading) ? _handleSave : null,
                  child: isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Save', style: GoogleFonts.quicksand(fontWeight: FontWeight.w700)),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
