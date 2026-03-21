import 'package:flutter/material.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';
import 'home/farmer_home_controller.dart';
import '../soil_acoustic/soil_record_screen.dart';

/// Farmer Dashboard Home Screen
/// Displays welcome message and action cards
/// This screen is used as tab content within FarmerDashboardScreen
class FarmerHomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;

  const FarmerHomeScreen({super.key, this.onNavigateToTab});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  final FarmerHomeController _controller = FarmerHomeController();

  @override
  void initState() {
    super.initState();
    // Load farmer data when screen initializes
    _controller.loadFarmerData();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Top welcome section with gradient background
            _buildTopSection(),

            // Action cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildActionCard(
                      icon: Icons.mic_rounded,
                      title: AppLocalizations.of(context).smartSoilAnalyzer,
                      subtitle: AppLocalizations.of(
                        context,
                      ).smartSoilAnalyzerSubtitle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SoilRecordScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.eco,
                      title: AppLocalizations.of(context).fertilizerAdvisory,
                      subtitle: AppLocalizations.of(
                        context,
                      ).fertilizerAdvisorySubtitle,
                      onTap: () {
                        widget.onNavigateToTab?.call(2);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.search,
                      title: AppLocalizations.of(context).fertilizerSearch,
                      subtitle: AppLocalizations.of(
                        context,
                      ).fertilizerSearchSubtitle,
                      onTap: () {
                        widget.onNavigateToTab?.call(1);
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.person,
                      title: AppLocalizations.of(context).profile,
                      subtitle: AppLocalizations.of(context).profileSubtitle,
                      onTap: () {
                        widget.onNavigateToTab?.call(3);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top section with logo, welcome message, and title
  Widget _buildTopSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFB8E6D5),
            const Color(0xFFB8E6D5).withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Logo placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A7C59),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'KM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Welcome message with dynamic farmer name
          _buildWelcomeText(),

          const SizedBox(height: 8),

          // Title
          Text(
            AppLocalizations.of(context).appSmartFertilizer,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  /// Welcome text with dynamic farmer name or loading indicator
  Widget _buildWelcomeText() {
    if (_controller.isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).loading,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4A7C59)),
          ),
        ],
      );
    }

    if (_controller.error != null) {
      return Text(
        AppLocalizations.of(context).welcomeFarmer,
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      );
    }

    return Text(
      AppLocalizations.of(context).welcomeName(_controller.farmerName ?? ''),
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    );
  }

  /// Action card widget
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF2E7D32), size: 28),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}
