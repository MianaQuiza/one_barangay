import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'report_incident_screen.dart';

class IncidentListScreen extends StatefulWidget {
  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  String _selectedFilter = 'All';

  // Mock data for resident reports
  final List<Map<String, dynamic>> _mockReports = [
    {
      'id': 'RPT-1042',
      'title': 'Broken Streetlight',
      'category': 'Infrastructure',
      'date': 'Aug 12, 2026',
      'status': 'Pending',
      'description': 'The streetlight at the corner of Block 4 is completely shattered and the street is dangerously dark at night.',
      'icon': Icons.lightbulb_outline,
      'statusColor': Colors.orange.shade600,
    },
    {
      'id': 'RPT-1038',
      'title': 'Uncollected Garbage',
      'category': 'Sanitation',
      'date': 'Aug 10, 2026',
      'status': 'In Progress',
      'description': 'Waste bins overflowing near the basketball court. The collection truck missed our street this morning.',
      'icon': Icons.delete_outline,
      'statusColor': Colors.blue.shade600,
    },
    {
      'id': 'RPT-0985',
      'title': 'Excessive Noise Complaint',
      'category': 'Disturbance',
      'date': 'Jul 28, 2026',
      'status': 'Resolved',
      'description': 'Loud karaoke past 11:00 PM on a weekday at house #42.',
      'icon': Icons.speaker_notes_off_outlined,
      'statusColor': Colors.green.shade600,
    },
    {
      'id': 'RPT-0950',
      'title': 'Deep Pothole',
      'category': 'Infrastructure',
      'date': 'Jul 15, 2026',
      'status': 'Resolved',
      'description': 'Massive pothole forming near the main gate. It damaged my tire yesterday.',
      'icon': Icons.add_road,
      'statusColor': Colors.green.shade600,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter the mock data
    final filteredReports = _selectedFilter == 'All'
        ? _mockReports
        : _mockReports.where((r) => r['status'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Reports',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Floating Action Button to submit a new report
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportIncidentScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text('New Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      
      body: Column(
        children: [
          // Filter Chips Section
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Pending'),
                  _buildFilterChip('In Progress'),
                  _buildFilterChip('Resolved'),
                ],
              ),
            ),
          ),
          
          // Reports List
          Expanded(
            child: filteredReports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No reports found in this category.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return _buildReportCard(report);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Widget for Filter Chips
  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.background,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedFilter = label);
          }
        },
      ),
    );
  }

  // Widget for Individual Report Cards
  Widget _buildReportCard(Map<String, dynamic> report) {
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
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: ID and Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report['id'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: report['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report['status'],
                    style: TextStyle(
                      color: report['statusColor'],
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, color: AppColors.divider),
            ),
            
            // Middle row: Icon, Title, Category, Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(report['icon'], color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${report['category']} • ${report['date']}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Bottom row: Description
            Text(
              report['description'],
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