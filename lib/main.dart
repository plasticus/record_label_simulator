// lib/main.dart
import 'package:flutter/material.dart';
import 'gen/band_generator.dart';

void main() {
  runApp(const RecordLabelSimulator());
}

class RecordLabelSimulator extends StatelessWidget {
  const RecordLabelSimulator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Record Label Simulator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.amber,
        colorScheme: const ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amberAccent,
        ),
      ),
      home: const GeneratorScreen(),
    );
  }
}

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  // Store the whole Band object instead of just a String
  Band? _currentBand;

  void _rollNewBand() {
    setState(() {
      _currentBand = BandGenerator.generateBand();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ SONIC EMPIRE LABELS ⚡'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'NEW SIGNING PROSPECT:',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2
                ),
              ),
              const SizedBox(height: 20),

              // The Marquee Window
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 2),
                ),
                child: Column(
                  children: [
                    // The Band Name
                    Text(
                      _currentBand?.name ?? 'Awaiting Generation...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Courier',
                      ),
                    ),

                    // Show Genre and Members if a band exists
                    if (_currentBand != null) ...[
                      const SizedBox(height: 16),

                      // Genre Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Text(
                          _currentBand!.genre.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 16),

                      const Text(
                        'BAND MEMBERS',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            letterSpacing: 2
                        ),
                      ),

                      const SizedBox(height: 12),

                      // List out the generated members - Now Strictly Typed and safe!
                      ..._currentBand!.members.map<Widget>((member) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${member.name}  [${member.gender}]',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            ),
                          ),
                        );
                      }),
                    ]
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // The Trigger Button
              ElevatedButton(
                onPressed: _rollNewBand,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                ),
                child: const Text('GENERATE BAND'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}