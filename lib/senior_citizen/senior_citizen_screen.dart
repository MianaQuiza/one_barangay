import 'package:flutter/material.dart';

class SeniorCitizenScreen extends StatelessWidget {
  const SeniorCitizenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Senior Citizen Services')),
      body: const Center(child: Text('Senior citizen services information will appear here.')),
    );
  }
}
