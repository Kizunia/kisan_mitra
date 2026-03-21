import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/app_localizations.dart';
import 'profile_controller.dart';
import 'edit_profile_screen.dart';
import 'language_screen.dart';
import 'notifications_screen.dart';
import 'help_support_screen.dart';
import 'about_app_screen.dart';
import 'change_password_screen.dart';

/// Farmer Profile Screen
/// Displays farmer profile with statistics and settings
class FarmerProfileScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const FarmerProfileScreen({super.key, this.onNavigateToTab});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize profile data on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9F6), // Very light mint/white
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          // Show loading indicator
          if (controller.isLoading && controller.userProfile == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2D6A4F)),
            );
          }

          // Show error if profile failed to load
          if (controller.errorMessage != null &&
              controller.userProfile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.initialize(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A4F),
                    ),
                    child: Text(
                      AppLocalizations.of(context).retry,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          final profile = controller.userProfile;
          final activity = controller.userActivity;
          
          final locale = Localizations.localeOf(context).languageCode;
          final currentLanguageDisplay = switch (locale) {
            'hi' => 'हिंदी',
            'mr' => 'मराठी',
            _ => 'English',
          };

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Section with Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1B5E20), // Dark Green
                          Color(0xFF43A047), // Medium Green
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Refresh Button (Left)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  controller.initialize();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).refreshingProfile,
                                      ),
                                      duration: const Duration(seconds: 1),
                                      backgroundColor: const Color(0xFF2D6A4F),
                                    ),
                                  );
                                },
                              ),
                            ),

                            Text(
                              AppLocalizations.of(context).myProfile,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),

                            // Edit Button (Right)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    _navigateToEditProfile(context),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Profile Image with ring
                        GestureDetector(
                          onTap: () => _uploadProfileImage(context, controller),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: profile?.profileImageUrl != null
                                      ? CachedNetworkImage(
                                          imageUrl: profile!.profileImageUrl!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 60,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.grey,
                                          ),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // User Name
                        Text(
                          profile?.name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Email
                        Text(
                          profile?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${profile?.village ?? ''}, ${profile?.city ?? ''}, ${profile?.state ?? ''}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Statistics Cards
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                '${activity?.searchCount ?? 0}',
                                AppLocalizations.of(context).searched,
                                icon: Icons.search,
                                color: const Color(
                                  0xFFEFFBF3,
                                ), // Very light mint
                                accentColor: const Color(0xFF2E7D32),
                                onTap: () => widget.onNavigateToTab?.call(1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                '${activity?.advisoryCount ?? 0}',
                                AppLocalizations.of(context).advisory,
                                icon: Icons.psychology_alt,
                                color: const Color(0xFFE8F5E9),
                                accentColor: const Color(0xFF1B5E20),
                                onTap: () => widget.onNavigateToTab?.call(2),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                '${activity?.visitedStoresCount ?? 0}',
                                AppLocalizations.of(context).visits,
                                icon: Icons.storefront,
                                color: const Color(0xFFF1F8E9),
                                accentColor: const Color(0xFF33691E),
                                onTap: () {
                                  widget.onNavigateToTab?.call(1);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).seeNearbyStores,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Settings Group
                        _buildSettingsGroup(
                          title: AppLocalizations.of(context).appSettings,
                          children: [
                            _buildSettingsItem(
                              icon: Icons.language,
                              title: AppLocalizations.of(context).language,
                              trailing: currentLanguageDisplay,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LanguageScreen(),
                                  ),
                                );
                              },
                              isFirst: true,
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildSettingsItem(
                              icon: Icons.notifications_none_rounded,
                              title: AppLocalizations.of(context).notifications,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationsScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildSettingsItem(
                              icon: Icons.help_outline_rounded,
                              title: AppLocalizations.of(context).helpSupport,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const HelpSupportScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildSettingsItem(
                              icon: Icons.info_outline_rounded,
                              title: AppLocalizations.of(context).aboutApp,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AboutAppScreen(),
                                  ),
                                );
                              },
                              isLast: true,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Personal Details Group
                        _buildSettingsGroup(
                          title: AppLocalizations.of(context).personalDetails,
                          children: [
                            _buildDetailRow(
                              Icons.person_outline,
                              AppLocalizations.of(context).fullName,
                              profile?.name ?? "",
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildDetailRow(
                              Icons.email_outlined,
                              AppLocalizations.of(context).email,
                              profile?.email ?? "",
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildDetailRow(
                              Icons.location_city,
                              AppLocalizations.of(context).state,
                              profile?.state ?? "",
                            ),
                            const Divider(height: 1, indent: 56),
                            _buildDetailRow(
                              Icons.map_outlined,
                              AppLocalizations.of(context).village,
                              profile?.village ?? "",
                              isLast: true,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Action Buttons
                        Column(
                          children: [
                            // Change Password Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _changePassword(context, controller),
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.lock_reset,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                label: Text(
                                  AppLocalizations.of(context).changePassword,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1976D2),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Logout Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _logout(context, controller),
                                icon: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFEBEE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    size: 18,
                                    color: Color(0xFFC62828),
                                  ),
                                ),
                                label: Text(
                                  AppLocalizations.of(context).logout,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFC62828),
                                  side: const BorderSide(
                                    color: Color(0xFFC62828),
                                    width: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Modern Stat Card
  Widget _buildStatCard(
    String count,
    String label, {
    VoidCallback? onTap,
    required IconData icon,
    required Color color,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: accentColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9), // Light green bg
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF33691E)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF263238),
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            if (trailing == null)
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD), // Light blue bg
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF1565C0)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF263238),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to edit profile
  void _navigateToEditProfile(BuildContext context) async {
    // Capture the controller BEFORE the MaterialPageRoute builder
    final controller = context.read<ProfileController>();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: controller,
          child: const EditProfileScreen(),
        ),
      ),
    );

    // Refresh profile if edited
    if (result == true) {
      if (mounted) {
        controller.initialize();
      }
    }
  }

  // Upload profile image
  void _uploadProfileImage(
    BuildContext context,
    ProfileController controller,
  ) async {
    final success = await controller.uploadProfileImage();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Profile image updated!' : 'Image upload cancelled',
          ),
          backgroundColor: success ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  // Change password
  void _changePassword(BuildContext context, ProfileController controller) {
    // Navigate to Change Password screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: controller,
          child: const ChangePasswordScreen(),
        ),
      ),
    );
  }

  // Logout
  void _logout(BuildContext context, ProfileController controller) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFC62828),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context).logout,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            AppLocalizations.of(context).logoutConfirm,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppLocalizations.of(context).logout,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context).pleaseWait),
                ],
              ),
            ),
          ),
        ),
      );

      await controller.signOut();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppConstants.farmerLoginRoute,
          (route) => false,
        );
      }
    }
  }
}
