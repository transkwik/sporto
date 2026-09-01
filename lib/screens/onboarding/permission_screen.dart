import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sporto/routes/app_routes.dart';
import 'package:sporto/screens/auth/providers/location_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/glass_back_button.dart';
import '../auth/widgets/auth_pill_buttons.dart';
import 'providers/permission_provider.dart';
import 'widgets/permission_tile.dart';

/// Onboarding step asking the user to grant location access (for finding
/// nearby tournaments) and enable notifications (for registration
/// reminders) before seeing the welcome summary.
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key, this.userName = ''});

  final String userName;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _locationGranted = true;
  bool _notificationsGranted = true;
  bool _isAutoFetching = true;

  @override
  void initState() {
    super.initState();
    _autoFetchLocation();
  }

  Future<void> _autoFetchLocation() async {
    final provider = context.read<PermissionProvider>();
    final locationProvider = context.read<LocationProvider>();

    // First, quietly check if we already have permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        // Try fetching automatically without showing the manual button
        final success = await provider.requestPermissionsAndLocation(
          locationProvider: locationProvider,
        );
        if (success && mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
          return; // Stop here, we successfully navigated
        }
      }
    }

    // If we reach here, we need the user's manual input
    if (mounted) {
      setState(() {
        _isAutoFetching = false;
      });
    }
  }

  Future<void> _handleContinue() async {
    if (!_locationGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to find tournaments.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final provider = context.read<PermissionProvider>();
    final locationProvider = context.read<LocationProvider>();
    final success = await provider.requestPermissionsAndLocation(
      locationProvider: locationProvider,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permissions and location saved successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to get location'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PermissionProvider>();

    return Scaffold(
      backgroundColor: AppColors.authBackgroundBottom,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.authBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: _isAutoFetching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Fetching Location...',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassBackButton(
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          'Permission',
                          style: GoogleFonts.quicksand(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      PermissionTile(
                        title: 'Find tournaments near you.',
                        caption: 'Allow Location',
                        granted: _locationGranted,
                        onToggle: () => setState(
                          () => _locationGranted = !_locationGranted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PermissionTile(
                        title: 'Get registration reminders.',
                        caption: 'Enable Notifications',
                        granted: _notificationsGranted,
                        onToggle: () => setState(
                          () => _notificationsGranted = !_notificationsGranted,
                        ),
                      ),
                      const SizedBox(height: 40),
                      GradientPillButton(
                        label: 'Continue',
                        onPressed: _handleContinue,
                        loading: provider.isLoading,
                        enabled: _locationGranted,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
