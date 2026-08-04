import 'package:flutter/material.dart';

class IncidentListScreen extends StatelessWidget {
  const IncidentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Assistance')),
      body: const Center(child: Text('Incident list will appear here.')),
    );
  }
}
