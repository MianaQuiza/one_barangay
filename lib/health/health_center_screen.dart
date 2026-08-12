import 'package:flutter/material.dart';
import '../models/model.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';
import 'health_history_screen.dart';

class HealthCenterScreen extends StatefulWidget {
  const HealthCenterScreen({super.key});

  @override
  State<HealthCenterScreen> createState() => _HealthCenterScreenState();
}

class _HealthCenterScreenState extends State<HealthCenterScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Health Center Services',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildActionButtons(),
            const SizedBox(height: 24),
            const Text(
              'Health Advisories & Schedules',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            
            // Database Stream for Health Updates
            Expanded(
              child: StreamBuilder<List<InfoPost>>(
                stream: _firestore.healthCenterPostsStream(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load advisories. Please try again.'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No health updates posted yet.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return _buildHealthCard(post);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.vaccines,
            label: 'Vaccines',
            color: Colors.blue.shade600,
            onTap: () {
              // TODO: Navigate to vaccination schedules
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.history,
            label: 'Health History',
            color: Colors.teal.shade500,
            onTap: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const HealthHistoryScreen()),
               );
            },
          ),
        ),
         const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.medication,
            label: 'Medicines',
            color: Colors.indigo.shade400,
            onTap: () {
               // TODO: Navigate to available medicine list
            },
          ),
        ),
      ],
    );
  }

  // Individual Health Update Cards
  Widget _buildHealthCard(InfoPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.health_and_safety, color: Colors.blue.shade600),
        ),
        title: const Text(
          'Health Alert / Schedule', // Safe placeholder until admin panel is built
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 16),
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Details regarding health center availability, medical missions, or advisories go here.', // Safe placeholder
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}