import 'package:flutter/material.dart';

class QuickModeSelector extends StatelessWidget {
  final List<String> modes;
  final String activeMode;
  final ValueChanged<String> onModeSelected;

  const QuickModeSelector({
    super.key,
    required this.modes,
    required this.activeMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Quick Modes'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: modes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final mode = modes[index];
              final isSelected = mode == activeMode;
              return ChoiceChip(
                label: Text(mode),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onModeSelected(mode);
                  }
                },
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
