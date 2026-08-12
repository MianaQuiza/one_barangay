import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Checkup', 'Prescription', 'Lab Result'];

  // Temporary placeholder data to demonstrate the filtered timeline UI
  final List<Map<String, dynamic>> _mockRecords = [
    {
      'type': 'Checkup',
      'title': 'Routine General Checkup',
      'date': 'Oct 12, 2026',
      'doctor': 'Dr. Santos',
      'notes': 'Blood pressure normal. Advised to maintain low-sodium diet.',
      'icon': Icons.favorite,
      'color': Colors.red.shade400,
    },
    {
      'type': 'Prescription',
      'title': 'Amoxicillin 500mg',
      'date': 'Sep 05, 2026',
      'doctor': 'Dr. Reyes',
      'notes': 'Take 1 capsule every 8 hours for 7 days.',
      'icon': Icons.medication,
      'color': Colors.indigo.shade400,
    },
    {
      'type': 'Lab Result',
      'title': 'Complete Blood Count (CBC)',
      'date': 'Aug 20, 2026',
      'doctor': 'Barangay Health Lab',
      'notes': 'All parameters within normal range. Clear of infection.',
      'icon': Icons.science,
      'color': Colors.purple.shade400,
    },
    {
      'type': 'Checkup',
      'title': 'Dental Consultation',
      'date': 'Jun 15, 2026',
      'doctor': 'Dr. Lim',
      'notes': 'Routine cleaning performed. No cavities detected.',
      'icon': Icons.medical_services,
      'color': Colors.teal.shade500,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the records based on the selected chip
    final filteredRecords = _mockRecords.where((record) {
      if (_selectedFilter == 'All') return true;
      return record['type'] == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Health History',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.teal.shade500,
                      backgroundColor: AppColors.background,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = filter);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Timeline List
          Expanded(
            child: filteredRecords.isEmpty
                ? const Center(
                    child: Text(
                      'No records found for this category.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                      return _buildHistoryCard(record);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: record['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(record['icon'], size: 20, color: record['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['type'],
                        style: TextStyle(
                          color: record['color'],
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record['date'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            Text(
              record['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Attending: ${record['doctor']}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              record['notes'],
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
