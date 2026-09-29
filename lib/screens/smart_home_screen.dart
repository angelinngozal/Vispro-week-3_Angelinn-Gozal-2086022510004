import 'package:flutter/material.dart';
import '../models/smart_device.dart';
import '../widgets/header_greeting.dart';
import '../widgets/stat_metric_card.dart';
import '../widgets/quick_mode_selector.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/device_control_tile.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  // Hoisted state
  String _activeMode = 'Home';
  String _selectedRoomCategory = 'All Rooms';
  String _searchQuery = '';

  List<SmartDevice> _devices = const [
    SmartDevice(
      id: 'd1',
      name: 'Main Living AC',
      room: 'Living Room',
      icon: Icons.ac_unit_rounded,
      isOn: true,
      powerConsumptionWatts: 1200.0,
    ),
    SmartDevice(
      id: 'd2',
      name: 'Ambient Ceiling Light',
      room: 'Living Room',
      icon: Icons.wb_incandescent_rounded,
      isOn: true,
      powerConsumptionWatts: 45.0,
    ),
    SmartDevice(
      id: 'd3',
      name: 'Smart Oven',
      room: 'Kitchen',
      icon: Icons.microwave_rounded,
      isOn: false,
      powerConsumptionWatts: 1500.0,
    ),
    SmartDevice(
      id: 'd4',
      name: 'Kitchen Exhaust Fan',
      room: 'Kitchen',
      icon: Icons.wind_power_rounded,
      isOn: false,
      powerConsumptionWatts: 80.0,
    ),
    SmartDevice(
      id: 'd5',
      name: 'Master Bed Lamp',
      room: 'Bedroom',
      icon: Icons.bedtime_rounded,
      isOn: false,
      powerConsumptionWatts: 15.0,
    ),
    SmartDevice(
      id: 'd6',
      name: 'Office Monitor Array',
      room: 'Office',
      icon: Icons.desktop_windows_rounded,
      isOn: true,
      powerConsumptionWatts: 150.0,
    ),
  ];

  final List<String> _modes = const ['Home', 'Away', 'Night', 'Eco'];
  final List<String> _roomCategories = const [
    'All Rooms',
    'Living Room',
    'Kitchen',
    'Bedroom',
    'Office',
  ];

  // Callback handlers for state modification
  void _handleDeviceToggle(String deviceId, bool isOn) {
    setState(() {
      _devices = _devices.map((device) {
        if (device.id == deviceId) {
          return device.copyWith(isOn: isOn);
        }
        return device;
      }).toList();
    });
  }

  void _handleModeChange(String mode) {
    setState(() {
      _activeMode = mode;
      if (mode == 'Away') {
        _devices =
            _devices.map((device) => device.copyWith(isOn: false)).toList();
      } else if (mode == 'Eco') {
        _devices = _devices.map((device) {
          if (device.powerConsumptionWatts > 500) {
            return device.copyWith(isOn: false);
          }
          return device;
        }).toList();
      }
    });
  }

  void _handleCategoryChange(String category) {
    setState(() {
      _selectedRoomCategory = category;
    });
  }

  void _handleSearchChange(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: Color(0xFF818CF8)),
            const SizedBox(width: 12),
            Text(
              'Active devices running: ${_devices.where((d) => d.isOn).length}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  // Derived state calculations
  List<SmartDevice> get _filteredDevices {
    return _devices.where((device) {
      final matchesCategory = _selectedRoomCategory == 'All Rooms' ||
          device.room == _selectedRoomCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          device.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          device.room.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _activeCount => _devices.where((d) => d.isOn).length;

  double get _totalPowerConsumptionKw {
    final totalWatts = _devices
        .where((d) => d.isOn)
        .fold(0.0, (sum, item) => sum + item.powerConsumptionWatts);
    return totalWatts / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredDevices;

    // New dark palette
    const bgTop = Color(0xFF0B1020); // deepest navy
    const bgBottom = Color(0xFF111834); // slightly lighter
    const surface = Color(0xFF1A2140); // card surface
    const surfaceBorder = Color(0xFF2A3358);
    const accentIndigo = Color(0xFF818CF8); // soft indigo
    const accentViolet = Color(0xFFA78BFA); // soft violet
    const accentAmber = Color(0xFFFBBF24); // warm gold
    const textPrimary = Color(0xFFF1F5F9);
    const textMuted = Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgTop,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header / Greeting =====
              SafeArea(
                bottom: false,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: SizedBox.shrink(),
                ),
              ),

              const SizedBox(height: 8),

              // ===== Hero Stats Panel (glassy) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF312E81),
                        Color(0xFF1E1B4B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: accentIndigo.withValues(alpha: 0.25),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentIndigo.withValues(alpha: 0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatMetricCard(
                          title: 'Active Devices',
                          value: '$_activeCount',
                          unit: 'devices',
                          icon: Icons.power_rounded,
                          color: accentIndigo,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 70,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatMetricCard(
                          title: 'Current Power',
                          value: _totalPowerConsumptionKw.toStringAsFixed(2),
                          unit: 'kW',
                          icon: Icons.bolt_rounded,
                          color: accentAmber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ===== Quick Mode Selector =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quick Modes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentIndigo.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: accentIndigo.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _activeMode,
                        style: const TextStyle(
                          fontSize: 12,
                          color: accentIndigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              QuickModeSelector(
                modes: _modes,
                activeMode: _activeMode,
                onModeSelected: _handleModeChange,
              ),

              const SizedBox(height: 28),

              // ===== Room Category Tabs =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Text(
                  'Rooms',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CategoryFilterTabs(
                categories: _roomCategories,
                selectedCategory: _selectedRoomCategory,
                onCategorySelected: _handleCategoryChange,
              ),

              const SizedBox(height: 28),

              // ===== Devices Header =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Devices',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textPrimary,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${filteredList.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: accentViolet,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Tap to toggle',
                      style: TextStyle(
                        fontSize: 12,
                        color: textMuted.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ===== Device Grid / Empty State =====
              if (filteredList.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: surfaceBorder,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.search_off_rounded,
                            size: 40,
                            color: textMuted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No devices found',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try a different filter or search term.',
                          style: TextStyle(color: textMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredList.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final device = filteredList[index];
                    return DeviceControlTile(
                      key: ValueKey(device.id),
                      device: device,
                      onToggle: (isOn) => _handleDeviceToggle(device.id, isOn),
                    );
                  },
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}