import 'package:flutter/material.dart';
import '../../widgets/ad_banner.dart';

// ─── AGENT DASHBOARD SCREEN ──────────────────────────────────────────────────
// The primary game screen. Shows the player's full agent roster (Rogue's
// Gallery), financial summary, and current turn status.
//
// AdMob banner reserved at the top of this screen — it's the highest-traffic
// screen in the game after Home.
//
// STATUS: Stub — layout scaffold only, no real data yet.

class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          // ── AdMob banner (always at the very top, above safe area content) ──
          const SafeArea(
            bottom: false,
            child: AdBanner(),
          ),

          // ── Screen content ──
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color(0xFF1F1F1F),
                  floating: true,
                  snap: true,
                  title: const Text(
                    'Agent Dashboard',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    // TODO: End Turn button
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ElevatedButton(
                        onPressed: null, // TODO: wire up turn logic
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          disabledBackgroundColor: Colors.amber.withValues(alpha: 0.3),
                        ),
                        child: const Text(
                          'END TURN',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // TODO: Financial summary strip (cash, weekly revenue, turn number)
                const SliverToBoxAdapter(
                  child: _PlaceholderSection(label: 'FINANCIAL SUMMARY'),
                ),

                // TODO: Agent cards — one per agent in the Rogue's Gallery
                const SliverToBoxAdapter(
                  child: _PlaceholderSection(label: "ROGUE'S GALLERY"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PLACEHOLDER ─────────────────────────────────────────────────────────────

class _PlaceholderSection extends StatelessWidget {
  final String label;
  const _PlaceholderSection({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white24,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
