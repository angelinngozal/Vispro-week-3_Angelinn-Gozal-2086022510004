import 'package:flutter/material.dart';

import '../models/smart_device.dart';
import '../widgets/category_filter_tabs.dart';
import '../widgets/device_control_tile.dart';
import '../widgets/header_greeting.dart';
import '../widgets/quick_mode_selector.dart';
import '../widgets/stat_metric_card.dart';

class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
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
        _devices = _devices
            .map((device) => device.copyWith(isOn: false))
            .toList();
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

  void _handleNotificationTap() {
    final activeCount = _devices.where((device) => device.isOn).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Active devices running: $activeCount')),
    );
  }

  List<SmartDevice> get _filteredDevices {
    return _devices.where((device) {
      final matchesCategory =
          _selectedRoomCategory == 'All Rooms' ||
          device.room == _selectedRoomCategory;
      final query = _searchQuery.toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          device.name.toLowerCase().contains(query) ||
          device.room.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  int get _activeCount => _devices.where((device) => device.isOn).length;

  double get _totalPowerConsumptionKw {
    final totalWatts = _devices
        .where((device) => device.isOn)
        .fold(0.0, (sum, device) => sum + device.powerConsumptionWatts);
    return totalWatts / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filteredDevices = _filteredDevices;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: HeaderGreeting(
                  userName: 'Alex Morgan',
                  activeDeviceCount: _activeCount,
                  onSearchChanged: (query) {
                    setState(() => _searchQuery = query);
                  },
                  onNotificationTap: _handleNotificationTap,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: StatMetricCard(
                        title: 'Current power usage',
                        value: _totalPowerConsumptionKw.toStringAsFixed(2),
                        unit: 'kW',
                        icon: Icons.bolt_rounded,
                        color: colorScheme.primary,
                        prominent: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: StatMetricCard(
                        title: 'Active devices',
                        value: '$_activeCount',
                        unit: 'devices',
                        icon: Icons.power_rounded,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              QuickModeSelector(
                modes: _modes,
                activeMode: _activeMode,
                onModeSelected: _handleModeChange,
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Rooms',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              CategoryFilterTabs(
                categories: _roomCategories,
                selectedCategory: _selectedRoomCategory,
                onCategorySelected: (category) {
                  setState(() => _selectedRoomCategory = category);
                },
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Devices',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${filteredDevices.length}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Tap to toggle',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (filteredDevices.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 40,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No devices found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Try a different filter or search term.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDevices.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) {
                    final device = filteredDevices[index];
                    return DeviceControlTile(
                      key: ValueKey(device.id),
                      device: device,
                      onToggle: (isOn) => _handleDeviceToggle(device.id, isOn),
                    );
                  },
                ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
