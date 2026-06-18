import 'package:flutter/material.dart';
import '../../dev_tools/screen_band_gen_complex.dart';
import '../../dev_tools/screen_band_name_test.dart';
import '../../dev_tools/screen_surname_test.dart';

// ─── DEV TOOLS SCREEN ────────────────────────────────────────────────────────
// Scratch tools for testing generators. Remove this tab before shipping.

// Access the global generator instance from main.dart
import '../../../main.dart' show bandGenerator;

class DevToolsScreen extends StatelessWidget {
  const DevToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEV TOOLS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _DevWarning(),
          const SizedBox(height: 16),
          _DevButton(
            label: 'Band Generator',
            subtitle: 'Full complex band gen with stats',
            icon: Icons.tune,
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BandGenDevScreen(generator: bandGenerator),
            )),
          ),
          const SizedBox(height: 10),
          _DevButton(
            label: 'Band Name Gen',
            subtitle: 'Pattern-based name test, 20 at a time',
            icon: Icons.album,
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => BandNameTestScreen(generator: bandGenerator),
            )),
          ),
          const SizedBox(height: 10),
          _DevButton(
            label: 'Surname Test',
            subtitle: '5 names per generation method',
            icon: Icons.science,
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const SurnameTestScreen(),
            )),
          ),
        ],
      ),
    );
  }
}

class _DevWarning extends StatelessWidget {
  const _DevWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF5A2A2A)),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFCF4E4E), size: 16),
          SizedBox(width: 8),
          Text(
            'Scratch screens — remove before shipping.',
            style: TextStyle(color: Color(0xFFCF4E4E), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DevButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  const _DevButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF555555), size: 20),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF555555), fontSize: 12)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF444444), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
