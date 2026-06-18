import 'package:flutter/material.dart';

// ─── DASHBOARD SCREEN ────────────────────────────────────────────────────────
// Financial overview, cash flow, news headlines, upcoming events.
// End Turn button lives here.
// STATUS: Stub

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SONIC EMPIRE'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: null, // TODO: wire up turn logic
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8B84B),
                disabledBackgroundColor: const Color(0xFFE8B84B).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'END TURN',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StubSection(label: 'FINANCIALS', icon: Icons.attach_money),
          SizedBox(height: 12),
          _StubSection(label: 'THIS WEEK', icon: Icons.calendar_today_rounded),
          SizedBox(height: 12),
          _StubSection(label: 'NEWS', icon: Icons.newspaper_rounded),
        ],
      ),
    );
  }
}

class _StubSection extends StatelessWidget {
  final String label;
  final IconData icon;
  const _StubSection({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF444444), size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
