import 'package:flutter/material.dart';
import 'asset_loader.dart';
import 'gen_human_names.dart';

class SurnameTestScreen extends StatefulWidget {
  const SurnameTestScreen({super.key});

  @override
  State<SurnameTestScreen> createState() => _SurnameTestScreenState();
}

class _SurnameTestScreenState extends State<SurnameTestScreen> {
  SurnameGenerator? _generator;
  Map<SurnameMethod, List<String>> _results = {};
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final data = await AssetLoader.load();
    _generator = SurnameGenerator(data);
    setState(() => _ready = true);
    _generate();
  }

  void _generate() {
    if (_generator == null) return;
    setState(() {
      _results = {
        for (final method in SurnameMethod.values)
          method: _generator!.generateByMethod(method, 5),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('🔬 Surname Test'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: !_ready
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: SurnameMethod.values.map((method) {
                final names = _results[method] ?? [];
                return _buildMethodBlock(method, names);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _ready ? _generate : null,
              icon: const Icon(Icons.refresh, color: Colors.black),
              label: const Text(
                'ROLL 5 OF EACH',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
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

  Widget _buildMethodBlock(SurnameMethod method, List<String> names) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            method.label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white38,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          ...names.map((name) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          )),
          const Divider(color: Colors.white12, height: 24),
        ],
      ),
    );
  }
}