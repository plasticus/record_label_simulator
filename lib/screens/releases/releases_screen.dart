import 'package:flutter/material.dart';

// ─── RELEASES SCREEN ─────────────────────────────────────────────────────────
// Tracks active album releases: in production, releasing soon, post-release.
// STATUS: Stub

class ReleasesScreen extends StatelessWidget {
  const ReleasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RELEASES'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.album_outlined, size: 48, color: Color(0xFF333333)),
            SizedBox(height: 16),
            Text(
              'No active releases.',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Get a band in the studio to start one.',
              style: TextStyle(color: Color(0xFF444444), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
