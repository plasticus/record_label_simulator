import 'package:flutter/material.dart';
import '../generators/band_generator.dart';

class BandGenDevScreen extends StatefulWidget {
  final BandGenerator generator;
  const BandGenDevScreen({super.key, required this.generator});

  @override
  State<BandGenDevScreen> createState() => _BandGenDevScreenState();
}

class _BandGenDevScreenState extends State<BandGenDevScreen> {
  late final BandGenerator _generator = widget.generator;

  // null = Random for both controls
  String? _selectedGenre;
  int? _selectedTier;

  Band? _band;

  static const List<int> _tiers = [10, 20, 30, 40, 50, 60, 70, 80, 90];

  @override
  void initState() {
    super.initState();
    _roll();
  }

  void _roll() {
    setState(() {
      _band = _generator.generate(
        forcedGenre: _selectedGenre,
        qualityTier: _selectedTier,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🎼 Complex Band Gen'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildControls(),
          Expanded(
            child: _band == null
                ? const Center(child: CircularProgressIndicator())
                : _buildBandSheet(_band!),
          ),
          _buildRollButton(),
        ],
      ),
    );
  }

  // ─── CONTROLS ──────────────────────────────────────────────────────────────

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      color: const Color(0xFF1F1F1F),
      child: Row(
        children: [
          // Genre picker
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Genre', style: _labelStyle),
                const SizedBox(height: 4),
                _buildDropdown<String>(
                  value: _selectedGenre,
                  hint: 'Random',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Random')),
                    ...BandGenerator.genres.map((g) =>
                        DropdownMenuItem(value: g, child: Text(g))),
                  ],
                  onChanged: (v) => setState(() => _selectedGenre = v),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Quality tier picker
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quality Tier', style: _labelStyle),
                const SizedBox(height: 4),
                _buildDropdown<int>(
                  value: _selectedTier,
                  hint: 'Random',
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Random')),
                    ..._tiers.map((t) =>
                        DropdownMenuItem(value: t, child: Text('$t  (${t - 5}–${t + 5})'))),
                  ],
                  onChanged: (v) => setState(() => _selectedTier = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        isDense: true,
      ),
      dropdownColor: const Color(0xFF2C2C2C),
      hint: Text(hint, style: const TextStyle(color: Colors.white38)),
      items: items,
      onChanged: onChanged,
    );
  }

  // ─── BAND SHEET ────────────────────────────────────────────────────────────

  Widget _buildBandSheet(Band band) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        // Band header
        _buildBandHeader(band),
        // Band skills
        _buildSection('Band Stats', _buildSkillsBlock(band.stats)),
        // Band traits
        _buildSection('Band Traits', _buildTraitsBlock(band.traits)),
        // Members
        _buildSection('Members', _buildMembersList(band.members)),
      ],
    );
  }

  Widget _buildBandHeader(Band band) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            band.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _chip(band.traits.genre),
              if (band.traits.gimmick != null) ...[
                const SizedBox(width: 8),
                _chip('🎭 ${band.traits.gimmick!.label}', color: Colors.deepOrange.shade700),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Overall  ${band.stats.overall.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsBlock(BandStats s) {
    return Column(
      children: [
        _statRow('Technical Skill', s.technicalSkill),
        _statRow('Sonic Identity',  s.sonicIdentity),
        _statRow('Star Power',      s.starPower),
        _statRow('Temperament',     s.temperament),
        _statRow('Chemistry',       s.chemistry),
      ],
    );
  }

  Widget _buildTraitsBlock(BandTraits t) {
    return Column(
      children: [
        _traitRow('Happiness',  t.happiness.toStringAsFixed(2)),
        _traitRow('Fan Club',   '${t.fanClub} fans'),
        _traitRow('Genre',      t.genre),
        _traitRow('Gimmick',    t.gimmick?.label ?? 'None'),
      ],
    );
  }

  Widget _buildMembersList(List<BandMember> members) {
    return Column(
      children: members.asMap().entries.map((e) {
        return _buildMemberCard(e.key + 1, e.value);
      }).toList(),
    );
  }

  Widget _buildMemberCard(int index, BandMember m) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name row
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.black,
                  child: Text('$index', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        '${m.genderLabel} · Age ${m.age} · ${m.displayInstrument}',
                        style: const TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Core stats grid
            Row(
              children: [
                _miniStat('Skill',      m.skill),
                _miniStat('Creativity', m.songwriting),
                _miniStat('Charisma',   m.starPower),
                _miniStat('Resilience', m.temperament),
              ],
            ),
            const SizedBox(height: 6),
            // Growth stats
            Row(
              children: [
                _miniStat('Growth Rate', m.cooperation, color: Colors.lightBlueAccent),
                _miniStat('Motivation',  m.cooperation, color: Colors.lightBlueAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── SHARED WIDGETS ────────────────────────────────────────────────────────

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
        ),
        content,
      ],
    );
  }

  Widget _statRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
                color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _traitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white70))),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _miniStat(String label, double value, {Color color = Colors.amber}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white38, fontSize: 10)),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color ?? Colors.amber.shade800,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildRollButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _roll,
        icon: const Icon(Icons.refresh, color: Colors.black),
        label: const Text(
          'ROLL NEW BAND',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontSize: 11,
    color: Colors.white38,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}