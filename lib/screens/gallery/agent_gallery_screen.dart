import 'package:flutter/material.dart';

// ─── AGENT GALLERY SCREEN ────────────────────────────────────────────────────
// The Rogue's Gallery. Shows all active agents — Band Managers, A&R,
// Creative Director, and contracted directors.
// Tap an agent to open their detail screen.
// STATUS: Stub

class AgentGalleryScreen extends StatelessWidget {
  const AgentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENTS'),
      ),
      body: const Center(
        child: _EmptyGallery(),
      ),
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.people_outline_rounded,
            size: 48, color: Color(0xFF333333)),
        const SizedBox(height: 16),
        const Text(
          'No agents yet.',
          style: TextStyle(
            color: Color(0xFF555555),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Hire someone on JF.fart to get started.',
          style: TextStyle(
            color: const Color(0xFF555555).withValues(alpha: 0.7),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
