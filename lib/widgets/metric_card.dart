import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.caption,
    required this.icon,
    required this.accent,
    this.onTap,
  });

  final String title;
  final String value;
  final String unit;
  final String caption;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$title: $value $unit. $caption',
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: accent, size: 20),
                    const Spacer(),
                    if (onTap != null)
                      const Icon(Icons.arrow_outward, size: 16, color: Colors.white54),
                  ],
                ),
                const SizedBox(height: 16),
                Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 5),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 4,
                  children: [
                    Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(unit, style: const TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(caption, style: const TextStyle(fontSize: 12, color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
