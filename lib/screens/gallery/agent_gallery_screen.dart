// lib/screens/gallery/agent_gallery_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/band_manager.dart';
import '../../providers/band_manager_provider.dart';

// ─── AGENT GALLERY SCREEN ────────────────────────────────────────────────────
// The Rogue's Gallery. Shows all active agents.
// Consuming bandManagerProvider — no more raw JSON loading in initState.

class AgentGalleryScreen extends ConsumerWidget {
  const AgentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managersAsync = ref.watch(bandManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENTS'),
      ),
      body: managersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Gnarly error loading agents:\n$e',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFFCF4E4E)),
          ),
        ),
        data: (managers) => managers.isEmpty
            ? const _EmptyGallery()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: managers.length,
          itemBuilder: (context, index) =>
              _AgentCard(manager: managers[index]),
        ),
      ),
    );
  }
}

// ─── AGENT CARD ──────────────────────────────────────────────────────────────

class _AgentCard extends StatelessWidget {
  final BandManager manager;
  const _AgentCard({required this.manager});

  @override
  Widget build(BuildContext context) {
    final skills = manager.skills;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + morale ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  manager.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8B84B),
                  ),
                ),
                _MoraleChip(morale: manager.morale),
              ],
            ),
            const SizedBox(height: 4),

            // ── Personality + role ──
            Text(
              manager.personality.name,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            // ── Skills grid ──
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _SkillCell('ACU', skills.acumen),
                _SkillCell('INS', skills.insight),
                _SkillCell('RES', skills.resolve),
                _SkillCell('PRE', skills.presence),
                _SkillCell('EXE', skills.execution),
                _SkillCell('NET', skills.network),
              ],
            ),

            // ── Warning badges ──
            if (manager.isUnderPerforming || manager.isBurningOut) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  if (manager.isUnderPerforming)
                    _Badge('UNDERPERFORMING', const Color(0xFFCF4E4E)),
                  if (manager.isBurningOut)
                    _Badge('BURNING OUT', const Color(0xFFE8884B)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── SHARED SMALL WIDGETS ────────────────────────────────────────────────────

class _MoraleChip extends StatelessWidget {
  final double morale;
  const _MoraleChip({required this.morale});

  Color get _color {
    if (morale >= 70) return const Color(0xFF4BB8A0);
    if (morale >= 40) return const Color(0xFFE8B84B);
    return const Color(0xFFCF4E4E);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Morale ${morale.toStringAsFixed(0)}',
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SkillCell extends StatelessWidget {
  final String label;
  final double value;
  const _SkillCell(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF555555),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0)),
        Text(value.toStringAsFixed(1),
            style: const TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────

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
        const Text('No agents yet.',
            style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text('Hire someone on JF.fart to get started.',
            style: TextStyle(
                color: const Color(0xFF555555).withValues(alpha: 0.7),
                fontSize: 13)),
      ],
    );
  }
}