import 'package:flutter/material.dart';
import '../generators/band_generator.dart';
import '../data/patterns.dart';

class BandNameTestScreen extends StatefulWidget {
  final BandGenerator generator;
  const BandNameTestScreen({super.key, required this.generator});

  @override
  State<BandNameTestScreen> createState() => _BandNameTestScreenState();
}

class _BandNameTestScreenState extends State<BandNameTestScreen> {
  String? _selectedPattern; // null = random
  List<String> _names = [];

  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    setState(() {
      _names = List.generate(20, (_) {
        final pattern = _selectedPattern
            ?? bandPatterns[widget.generator.randomIndex(bandPatterns.length)];
        return widget.generator.generateBandNameFromPattern(pattern);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🎸 Band Name Test'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Pattern picker
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            color: const Color(0xFF1F1F1F),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PATTERN', style: _labelStyle),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _selectedPattern,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    isDense: true,
                  ),
                  dropdownColor: const Color(0xFF2C2C2C),
                  hint: const Text('Random', style: TextStyle(color: Colors.white38)),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Random')),
                    ...bandPatterns.map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    )),
                  ],
                  onChanged: (v) => setState(() => _selectedPattern = v),
                ),
              ],
            ),
          ),

          // Name list
          Expanded(
            child: _names.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _names.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${index + 1}.',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _names[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Roll button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text(
                'GEN 20 BAND NAMES',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _labelStyle = TextStyle(
    fontSize: 11,
    color: Colors.white38,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}