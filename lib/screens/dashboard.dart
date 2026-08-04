import 'package:flutter/material.dart';
import '../models/model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

// Module Imports
import 'announcement.dart';
import '../waste_collection/waste_collection_screen.dart';
import '../community_assistance/incident_list_screen.dart';
// removed unused import: report_incident_screen.dart
import '../lost_found/lost_found_screen.dart';
import '../volunteer/volunteer_screen.dart';
import '../calendar/community_calendar_screen.dart';
import '../senior_citizen/senior_citizen_screen.dart';
import '../pwd/pwd_screen.dart';
import '../health/health_center_screen.dart';
import '../emergency/emergency_screen.dart';
import '../map/community_map_screen.dart';
import '../notifications/notifications_screen.dart';


class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _firestore = FirestoreService();
  final _auth = AuthService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Theme will be used in sub-widgets; avoid unused local variable here.
    
    // Safely initializing the screens inside the build method
    // so that Theme.of(context) does not crash the app.
    final List<Widget> screens = [
      _buildHomeContent(),
      const CommunityMapScreen(),
      const IncidentListScreen(),
      const Center(child: Text('Profile Settings Coming Soon')), // Placeholder for Profile
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.navy),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 28),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _AppDrawer(auth: _auth),
      
      // Fixed background matching login/register
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ph_map_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.08, // Very low opacity to keep main content highly readable
          ),
        ),
        child: SafeArea(
          child: screens[_currentIndex],
        ),
      ),
      
      // Modern Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
              BottomNavigationBarItem(icon: Icon(Icons.report_gmailerrorred_rounded), label: 'Reports'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  // ---- MAIN HOME TAB CONTENT ----
  Widget _buildHomeContent() {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: () async {},
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          
          // 1. Dynamic Welcome Header
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: const Icon(Icons.person, color: AppColors.primary, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Resident!', // TODO: Connect to Firebase Auth User Name
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: AppColors.navy),
                  ),
                  Text(
                    'Zone 4', // TODO: Connect to Firebase Auth User Zone
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 2. High-Priority Emergency Alerts
          StreamBuilder<List<EmergencyAlert>>(
            stream: _firestore.emergencyAlertsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
              final alert = snapshot.data!.first;
              return Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EmergencyScreen())),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: AppColors.danger.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(alert.title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(alert.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. Essential Modules Grid
          Text('Core Services', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
            children: [
              _buildGridCard(Icons.campaign_outlined, 'News', AppColors.info, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen()))),
              _buildGridCard(Icons.delete_outline, 'Waste', AppColors.success, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WasteCollectionScreen()))),
              _buildGridCard(Icons.local_hospital_outlined, 'Health', AppColors.primary, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HealthCenterScreen()))),
              _buildGridCard(Icons.calendar_month_outlined, 'Events', AppColors.accent, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CommunityCalendarScreen()))),
              _buildGridCard(Icons.elderly_outlined, 'Seniors', AppColors.primaryDark, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SeniorCitizenScreen()))),
              _buildGridCard(Icons.accessible_outlined, 'PWD', AppColors.info, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PwdScreen()))),
            ],
          ),
          const SizedBox(height: 32),

          // 4. Latest Announcements List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Latest Updates', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.navy)),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnnouncementsScreen())),
                child: const Text('See All', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          StreamBuilder<List<Announcement>>(
            stream: _firestore.announcementsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Center(child: Text('Error loading updates'));
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final items = snapshot.data!.take(3).toList();
              if (items.isEmpty) return const Center(child: Text('No announcements yet.', style: TextStyle(color: AppColors.textSecondary)));
              
              return Column(
                children: items.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.campaign_outlined, color: AppColors.info),
                      ),
                      title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.navy)),
                      subtitle: Text('${a.category} • ${timeAgo(a.createdAt)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ),
                  ),
                )).toList(),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Reusable Component for Grid Items
  Widget _buildGridCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.navy.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- SIDEBAR DRAWER ----
class _AppDrawer extends StatelessWidget {
  final AuthService auth;
  const _AppDrawer({required this.auth});

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label, Widget screen) {
      return ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.navy)),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
        },
      );
    }

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text('ONE BARANGAY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20, letterSpacing: 1.0)),
                  Text('Community Hub', style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500, fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  item(Icons.volunteer_activism_outlined, 'Volunteer Program', const VolunteerScreen()),
                  item(Icons.report_gmailerrorred_outlined, 'Community Assistance', const IncidentListScreen()),
                  item(Icons.search_outlined, 'Lost and Found', const LostFoundScreen()),
                  item(Icons.emergency_outlined, 'Emergency Resources', const EmergencyScreen()),
                  
                 
                  const Divider(height: 32),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.danger),
                    title: const Text('Sign Out', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
                    onTap: () => auth.signOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
