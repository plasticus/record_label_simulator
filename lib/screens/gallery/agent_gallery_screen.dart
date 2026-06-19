import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// lib/screens/gallery/agent_gallery_screen.dart

class AgentGalleryScreen extends ConsumerStatefulWidget {
  const AgentGalleryScreen({super.key});

  @override
  ConsumerState<AgentGalleryScreen> createState() => _AgentGalleryScreenState();
}

class _AgentGalleryScreenState extends ConsumerState<AgentGalleryScreen> {
  List<dynamic> _randomAgents = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRandomAgents();
  }

  Future<void> _loadRandomAgents() async {
    try {
      final String response = await rootBundle.loadString('assets/data/band_managers.json');
      final List<dynamic> data = json.decode(response);

      if (data.isNotEmpty) {
        final List<dynamic> shuffled = List.from(data)..shuffle();
        _randomAgents = shuffled.take(5).toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Gnarly error loading data: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AGENTS'),
      ),
      body: _randomAgents.isEmpty
          ? const Center(child: Text('No managers found in the file.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _randomAgents.length,
        itemBuilder: (context, index) {
          final agent = _randomAgents[index];
          final Map<String, dynamic> skills = agent['skills'] ?? {};

          // Dynamic asset parsing that handles casing, spaces, and character encoding bugs like 'ã'
          final String rawName = agent['name'] ?? 'unknown';
          final String sanitizedName = rawName.replaceAll(' ', '').toLowerCase().replaceAll('ã', 'a');
          final String assetPath = 'assets/images/agents/$sanitizedName.png';

          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Agent Profile Image Avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          assetPath,
                          width: 55.0,
                          height: 55.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 55.0,
                              height: 55.0,
                              color: Colors.grey[800],
                              child: const Icon(Icons.person, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Identity details text block
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  agent['name'] ?? 'Unknown Agent',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4.0),
                                    border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    'Morale ${agent['morale']?.toString() ?? '100'}',
                                    style: const TextStyle(
                                      color: Colors.tealAccent,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              agent['personality'] ?? 'normal',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24.0),
                  // Stat readout row block
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: skills.entries.map((entry) {
                      // Grab short prefix name representation matching UI mockups
                      String label = entry.key.toUpperCase();
                      if (label.length > 3) {
                        label = label.substring(0, 3);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}