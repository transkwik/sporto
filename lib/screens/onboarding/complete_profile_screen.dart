import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/apiServices/user_api.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../auth/widgets/auth_pill_buttons.dart';
import 'package:get/get.dart';
import 'permission_screen.dart';
import 'providers/profile_provider.dart';
import 'widgets/gender_selector.dart';
import 'widgets/profile_photo_picker.dart';
import 'widgets/profile_text_field.dart';

/// Profile completion form shown right after OTP verification: photo
/// upload, personal details, gender selection and location fields, on the
/// same dark glassmorphism background as the rest of the auth flow.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  Gender? _gender;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  Future<void> _handleContinue() async {
    FocusScope.of(context).unfocus();

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_dobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your date of birth'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your city'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_stateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your state'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    String dob = _dobController.text.trim();
    String formattedDob = dob;
    List<String> parts = dob.split('/');
    if (parts.length == 3) {
      formattedDob = '${parts[2]}-${parts[1]}-${parts[0]}';
    }

    final profileProvider = context.read<ProfileProvider>();

    final success = await profileProvider.completeProfile(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      dateOfBirth: formattedDob,
      gender: _gender == Gender.male ? "male" : "female",
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      final String submittedName = _nameController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileProvider.successMessage ?? 'Profile completed successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      // Clear all fields so they are empty if the user ever returns
      _nameController.clear();
      _emailController.clear();
      _dobController.clear();
      _cityController.clear();
      _stateController.clear();
      setState(() => _gender = null);
      profileProvider.clearPhoto();

      Get.offAll(() => PermissionScreen(userName: submittedName));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            profileProvider.errorMessage ?? 'Failed to complete profile',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GlassBackButton(
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Complete Profile',
                      style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'Personal Information',
                  style: GoogleFonts.quicksand(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Profile Photo',
                  style: GoogleFonts.quicksand(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ProfilePhotoPicker(
                  hasPhoto: profileProvider.hasPhoto,
                  photoUrl: profileProvider.uploadedPhotoUrl,
                  isUploading: profileProvider.isUploadingPhoto,
                  onUpload: () => profileProvider.pickAndUploadImage(),
                  onClear: () => profileProvider.clearPhoto(),
                ),
                const SizedBox(height: 22),
                ProfileTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                ),
                const SizedBox(height: 18),
                ProfileTextField(
                  label: 'Email Address',
                  hint: 'Enter your email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 18),
                ProfileTextField(
                  label: 'Date of Birth',
                  hint: 'DD/MM/YYYY',
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white38,
                    size: 17,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Gender',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GenderSelector(
                  selected: _gender,
                  onChanged: (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: 18),
                ProfileTextField(
                  label: 'City',
                  hint: 'Enter city name',
                  controller: _cityController,
                ),
                const SizedBox(height: 18),
                ProfileTextField(
                  label: 'State',
                  hint: 'Enter state name',
                  controller: _stateController,
                ),
                const SizedBox(height: 34),
                GradientPillButton(
                  label: 'Continue',
                  onPressed: _handleContinue,
                  loading: profileProvider.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
