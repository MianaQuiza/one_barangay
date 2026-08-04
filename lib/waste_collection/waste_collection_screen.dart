import 'package:flutter/material.dart';

class WasteCollectionScreen extends StatelessWidget {
  const WasteCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waste Collection')),
      body: const Center(child: Text('Waste collection details will appear here.')),
    );
  }
}
