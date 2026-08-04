import 'package:flutter/material.dart';

class HealthCenterScreen extends StatelessWidget {
  const HealthCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Center Services')),
      body: const Center(child: Text('Health center services will appear here.')),
    );
  }
}
