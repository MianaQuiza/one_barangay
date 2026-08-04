import 'package:flutter/material.dart';
import '../models/model.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final _firestore = FirestoreService();
  String _filter = 'All';

  static const _categories = [
    'All',
    'General',
    'Ordinance',
    'Advisory',
    'Holiday',
    'Office Schedule',
    'Road Closure',
    'Water Interruption',
    'Power Interruption',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final selected = cat == _filter;
                return ChoiceChip(
                  label: Text(cat),
                  selected: selected,
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  onSelected: (_) => setState(() => _filter = cat),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Announcement>>(
              stream: _firestore.announcementsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const ErrorState();
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final items = snapshot.data!.where((a) => _filter == 'All' || a.category == _filter).toList();
                if (items.isEmpty) {
                  return const EmptyState(icon: Icons.campaign_outlined, message: 'No announcements in this category.');
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final a = items[i];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                StatusChip(label: a.category, color: AppColors.info),
                                const Spacer(),
                                Text(timeAgo(a.createdAt), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(a.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(a.body, style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            Text('Posted by ${a.postedBy}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}