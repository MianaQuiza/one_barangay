import 'package:flutter/material.dart';

class CommunityCalendarScreen extends StatelessWidget {
  const CommunityCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Calendar')),
      body: const Center(child: Text('Community calendar events will appear here.')),
    );
  }
}
