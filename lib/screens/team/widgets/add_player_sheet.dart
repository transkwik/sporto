import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../onboarding/widgets/profile_text_field.dart';

/// Bottom sheet form for adding or editing a single player on a team:
/// name, mobile number, and a "Send Request" call to action. Pass
/// [initialName]/[initialPhone] to pre-fill the form for editing an
/// existing player, and set [isEdit] to switch the heading accordingly.
class AddPlayerSheet extends StatefulWidget {
  const AddPlayerSheet({
    super.key,
    required this.playerNumber,
    required this.onSend,
    this.initialName,
    this.initialPhone,
    this.isEdit = false,
  });

  final int playerNumber;
  final void Function(String name, String phone) onSend;
  final String? initialName;
  final String? initialPhone;
  final bool isEdit;

  @override
  State<AddPlayerSheet> createState() => _AddPlayerSheetState();
}

class _AddPlayerSheetState extends State<AddPlayerSheet> {
  late final _nameController = TextEditingController(text: widget.initialName ?? '');
  late final _phoneController = TextEditingController(text: widget.initialPhone ?? '');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter the player's name and mobile number")),
      );
      return;
    }
    widget.onSend(name, phone);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
        decoration: const BoxDecoration(
          color: Color(0xFF161A24),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${widget.isEdit ? 'Edit' : 'Add'} Player ${widget.playerNumber}',
                    style: GoogleFonts.quicksand(color: AppColors.infoBlue, fontSize: 20, fontWeight: FontWeight.w800),
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
            const SizedBox(height: 24),
            ProfileTextField(label: 'Player Name', hint: 'Enter player name', controller: _nameController),
            const SizedBox(height: 18),
            ProfileTextField(
              label: 'Enter Mobile Number To add',
              hint: 'Enter mobile number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6FD0FF), Color(0xFF2E9EE0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E9EE0).withValues(alpha: 0.4),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Text(
                  'Send Request',
                  style: TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 