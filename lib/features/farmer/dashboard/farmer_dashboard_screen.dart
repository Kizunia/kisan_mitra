import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';
import '../farmer_home_screen.dart';
import '../fertilizer_search/fertilizer_search_screen.dart';
import '../advisory/presentation/screens/advisory_screen.dart';
import '../profile/farmer_profile_screen.dart';
import '../profile/profile_controller.dart';
import '../../../../core/controllers/ai_assistant_controller.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/services/intent_service.dart';
import '../../../../core/widgets/ai_floating_button.dart';
import '../../soil_acoustic/soil_record_screen.dart';

/// Farmer Dashboard Screen
/// Main container for farmer module with persistent bottom navigation
/// Uses IndexedStack to preserve state across tab switches
class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  int _selectedIndex = 0;

  // Handle tab changes from bottom navigation bar
  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Handle navigation requests from home screen action cards
  void _onNavigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Do not auto-open AI assistant; keep it manual via floating button.
        _setupAiAssistantNavigation();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Provider setup is now done in initState with addPostFrameCallback
  }

  void _playStartupGreeting() {
    if (!mounted) return;
    try {
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      final aiController = Provider.of<AiAssistantController>(
        context,
        listen: false,
      );
      aiController.playStartupGreeting(
        startListeningAfter: true,
        languageCode: localeProvider.currentLanguageCode,
      );
    } catch (e) {
      print('Error playing startup greeting: $e');
      // Continue without AI assistant if provider is not available
    }
  }

  void _setupAiAssistantNavigation() {
    if (!mounted) return;
    try {
      final controller = Provider.of<AiAssistantController>(
        context,
        listen: false,
      );
      controller.onNavigate = (route, tabIndex) {
        if (!mounted) return;
        if (tabIndex != null) {
          _onNavigateToTab(tabIndex);
        }
        if (route != null && route.isNotEmpty) {
          if (route == IntentService.soilHealthRoute) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SoilRecordScreen()),
            );
          } else {
            Navigator.of(context).pushNamed(route);
          }
        }
      };
    } catch (e) {
      print('Error setting up AI assistant navigation: $e');
      // Continue without AI assistant if provider is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ProfileController()..initialize(),
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                FarmerHomeScreen(onNavigateToTab: _onNavigateToTab),
                FertilizerSearchScreen(onNavigateToTab: _onNavigateToTab),
                const AdvisoryScreen(),
                FarmerProfileScreen(onNavigateToTab: _onNavigateToTab),
              ],
            ),
            const AiFloatingButton(bottom: 80, right: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// Bottom navigation bar — premium design
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: AppLocalizations.of(context).home,
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: AppLocalizations.of(context).search,
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.article_outlined,
                activeIcon: Icons.article_rounded,
                label: AppLocalizations.of(context).advisory,
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outlined,
                activeIcon: Icons.person_rounded,
                label: AppLocalizations.of(context).profile,
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom navigation item with pill-style active indicator
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    const green = Color(0xFF2E7D32);
    const greenBg = Color(0xFFE8F5E9);

    return Expanded(
      child: GestureDetector(
        onTap: () => _onBottomNavTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pill background behind icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 20 : 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? greenBg : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  color: isSelected ? green : const Color(0xFF9E9E9E),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? green : const Color(0xFF9E9E9E),
                letterSpacing: 0.2,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
