// // ... existing imports ...
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// lib/screens/gallery/agent_gallery_screen.dart

class AgentGalleryScreen extends StatefulWidget {
  const AgentGalleryScreen({super.key});

  @override
  State<AgentGalleryScreen> createState() => _AgentGalleryScreenState();
}

class _AgentGalleryScreenState extends State<AgentGalleryScreen> {
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
      // Pulling directly from your existing json file asset seen in image_90fbec.jpg
      final String response = await rootBundle.loadString('assets/data/band_managers.json');
      final List<dynamic> data = json.decode(response);

      if (data.isNotEmpty) {
        // Shuffle the real roster deck and carve out exactly 5 items
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
        title: const Text('Agent Gallery'),
      ),
      body: _randomAgents.isEmpty
          ? const Center(child: Text('No managers found in the file.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _randomAgents.length,
        itemBuilder: (context, index) {
          final agent = _randomAgents[index];
          // Accessing the nested skills map directly from your JSON blueprint
          final Map<String, dynamic> skills = agent['skills'] ?? {};

          // Clean up the name to match your asset file naming convention (e.g., "Priya Osei" -> "priyaosei")
          final String rawName = agent['name'] ?? 'unknown';
          final String sanitizedName = rawName.replaceAll(' ', '').toLowerCase();
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
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                          // Fallback check in case an asset is missing or misspelled
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60.0,
                              height: 60.0,
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Name and Personality Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agent['name'] ?? 'Unknown Agent',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personality: ${agent['personality'] ?? 'Normal'}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Text(
                                  'Morale: ${agent['morale']?.toString() ?? '100'}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24.0),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: skills.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
// // end of screen class definition