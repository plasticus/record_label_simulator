import 'package:flutter/material.dart';

// ─── BAND MANAGER DETAIL SCREEN ──────────────────────────────────────────────
// Shows the full profile for a single Band Manager agent: stats, traits,
// personality summary, and the list of bands they manage.
// Also the entry point for the Conversation Mini-Game with this agent.
//
// STATUS: Stub — no data model wired up yet. Build after BandManager model
// exists in lib/models/band_manager.dart.

class BandManagerDetailScreen extends StatelessWidget {
  const BandManagerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text('Band Manager'),
        // TODO: Replace with actual manager name once model is wired up
      ),
      body: const Center(
        child: Text(
          'Band Manager detail — coming soon.',
          style: TextStyle(color: Colors.white38),
        ),
      ),
    );
  }
}
