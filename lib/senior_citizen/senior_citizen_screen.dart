import 'package:flutter/material.dart';
import '../models/model.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class SeniorCitizenScreen extends StatefulWidget {
  const SeniorCitizenScreen({super.key});

  @override
  State<SeniorCitizenScreen> createState() => _SeniorCitizenScreenState();
}

class _SeniorCitizenScreenState extends State<SeniorCitizenScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a slightly warmer, softer background hex to reduce visual stress
      backgroundColor: const Color(0xFFFBF9F6), 
      appBar: AppBar(
        title: const Text(
          'Senior Citizen Hub',
          style: TextStyle(
            fontWeight: FontWeight.w800, 
            letterSpacing: 0.5,
            fontSize: 22, // Slightly larger for better readability
          ),
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
              'Benefits & Announcements',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            
            // Database Stream for InfoPosts
            Expanded(
              child: StreamBuilder<List<InfoPost>>(
                stream: _firestore.seniorCitizenPostsStream(), 
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Failed to load updates. Please try again.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.elderly, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No updates posted yet.',
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
                      return _buildInfoCard(post);
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

  // Large, easy-to-tap quick action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.card_membership,
            label: 'ID Application',
            color: Colors.orange.shade600,
            onTap: () {
              // TODO: Navigate to ID form
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.local_hospital,
            label: 'Medical Assistance',
            color: Colors.red.shade400,
            onTap: () {
              // TODO: Navigate to medical request form
            },
          ),
        ),
      ],
    );
  }

  // Individual Update Cards focusing on high-contrast text
  Widget _buildInfoCard(InfoPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title Placeholder', // Safe placeholder until we verify InfoPost structure
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800, // Extra weight for clarity
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Content description goes here. This text is styled to be highly legible with proper line height.',
              style: TextStyle(
                fontSize: 16, // Base size increased for seniors
                height: 1.6,  // Increased line height reduces reading strain
                color: Color(0xFF4A5568), // High contrast dark gray
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}