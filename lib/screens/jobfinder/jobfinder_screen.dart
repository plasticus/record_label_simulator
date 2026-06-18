import 'package:flutter/material.dart';

// ─── JOBFINDER.FART SCREEN ───────────────────────────────────────────────────
// The agent hiring marketplace. Shows available candidates this week,
// with the option to unlock extra listings via JF.fart Premium.
// STATUS: Stub

class JobFinderScreen extends StatelessWidget {
  const JobFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JOBFINDER.FART'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline_rounded, size: 48, color: Color(0xFF333333)),
            SizedBox(height: 16),
            Text(
              'No listings this week.',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Check back next turn.',
              style: TextStyle(color: Color(0xFF444444), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
