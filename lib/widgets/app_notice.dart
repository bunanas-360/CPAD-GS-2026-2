import 'package:flutter/material.dart';

class AppNotice extends StatelessWidget {
  const AppNotice({super.key, required this.message, this.warning = false});
  final String message;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning ? const Color(0xFFFFC46B) : const Color(0xFF69A9FF);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(warning ? Icons.info_outline : Icons.cloud_done_outlined, color: color, size: 19),
          const SizedBox(width: 9),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 12.5, height: 1.4))),
        ],
      ),
    );
  }
}
