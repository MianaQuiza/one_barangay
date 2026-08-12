import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';

class CommunityMapScreen extends StatefulWidget {
  const CommunityMapScreen({super.key});

  @override
  State<CommunityMapScreen> createState() => _CommunityMapScreenState();
}

class _CommunityMapScreenState extends State<CommunityMapScreen> {
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedMarker;

  // Real GPS Coordinates (Centered around San Jose del Monte)
  final LatLng _mapCenter = const LatLng(14.8143, 121.0453);

  // Map Pins with real Latitude/Longitude
  final List<Map<String, dynamic>> _mockMarkers = [
    {
      'id': 1,
      'title': 'Main Health Center',
      'category': 'Health',
      'status': 'Open',
      'distance': '1.2 km',
      'icon': Icons.local_hospital,
      'color': Colors.red.shade500,
      'location': const LatLng(14.8155, 121.0460),
    },
    {
      'id': 2,
      'title': 'Zone 4 Waste Bin',
      'category': 'Waste',
      'status': 'Available',
      'distance': '0.3 km',
      'icon': Icons.delete,
      'color': Colors.teal.shade500,
      'location': const LatLng(14.8130, 121.0440),
    },
    {
      'id': 3,
      'title': 'Barangay Hall / Outpost',
      'category': 'Security',
      'status': 'Active',
      'distance': '0.8 km',
      'icon': Icons.security,
      'color': Colors.blue.shade600,
      'location': const LatLng(14.8148, 121.0425),
    },
    {
      'id': 4,
      'title': 'Evacuation Center',
      'category': 'Emergency',
      'status': 'Standby',
      'distance': '2.1 km',
      'icon': Icons.warning,
      'color': Colors.orange.shade500,
      'location': const LatLng(14.8125, 121.0475),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter markers based on selected chip
    final filteredMarkers = _selectedFilter == 'All' 
        ? _mockMarkers 
        : _mockMarkers.where((m) => m['category'] == _selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      body: Stack(
        children: [
          // 1. The Real Interactive Map!
          FlutterMap(
            options: MapOptions(
              initialCenter: _mapCenter,
              initialZoom: 15.5,
              onTap: (tapPosition, point) {
                // Tap anywhere on the map to dismiss the details card
                setState(() => _selectedMarker = null);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.onebarangay.app', // Good practice for OSM
              ),
              MarkerLayer(
                markers: filteredMarkers.map((marker) {
                  final isSelected = _selectedMarker != null && _selectedMarker!['id'] == marker['id'];
                  return Marker(
                    point: marker['location'],
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMarker = marker;
                        });
                      },
                      child: AnimatedScale(
                        scale: isSelected ? 1.2 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: marker['color'],
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: marker['color'].withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4)),
                                ],
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(marker['icon'], color: Colors.white, size: 18),
                            ),
                            Container(
                              width: 4,
                              height: 8,
                              color: marker['color'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 2. Top UI (Search & Filters)
          SafeArea(
            child: Column(
              children: [
                // Floating Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: AppColors.navy.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search locations, facilities...',
                        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: AppColors.primary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
                
                // Floating Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('All', Icons.map),
                      _buildFilterChip('Health', Icons.local_hospital),
                      _buildFilterChip('Waste', Icons.delete),
                      _buildFilterChip('Security', Icons.security),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Bottom Details Card
          if (_selectedMarker != null)
            Positioned(
              bottom: 100, // Kept high enough so it doesn't block the bottom nav bar
              left: 16,
              right: 16,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppColors.navy.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, -5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _selectedMarker!['color'].withOpacity(0.1),
                        child: Icon(_selectedMarker!['icon'], color: _selectedMarker!['color'], size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedMarker!['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.navy),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_selectedMarker!['category']} • ${_selectedMarker!['distance']}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _selectedMarker!['status'] == 'Open' || _selectedMarker!['status'] == 'Available' 
                              ? Colors.green.shade50 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _selectedMarker!['status'],
                          style: TextStyle(
                            color: _selectedMarker!['status'] == 'Open' || _selectedMarker!['status'] == 'Available' 
                                ? Colors.green.shade700 : Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.navy),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.navy)),
          ],
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = label;
            _selectedMarker = null; // Hide details card when switching filters
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.transparent)),
      ),
    );
  }
}