import 'package:flutter/material.dart';
import 'generators/band_generator.dart';
import 'screens/dashboard/agent_dashboard_screen.dart';
import 'widgets/ad_banner.dart';

// ── Dev tool screens (scratch — retire once real screens exist) ──
import 'dev_tools/screen_band_gen_complex.dart';
import 'dev_tools/screen_surname_test.dart';
import 'dev_tools/screen_band_name_test.dart';

final bandGenerator = BandGenerator();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bandGenerator.init();
  runApp(const SonicEmpireApp());
}

class SonicEmpireApp extends StatelessWidget {
  const SonicEmpireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Empire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E1E1E),
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          // ── AdMob banner at the very top ──
          const SafeArea(
            bottom: false,
            child: AdBanner(),
          ),

          // ── Screen content ──
          Expanded(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    const Text(
                      'SONIC EMPIRE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Record Label Simulator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white38,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // ── GAME ENTRY ────────────────────────────────────────
                    _HomeButton(
                      label: 'AGENT DASHBOARD',
                      subtitle: 'Manage your label',
                      icon: Icons.people,
                      color: Colors.amberAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AgentDashboardScreen()),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── DEV TOOLS (scratch screens — remove before ship) ──
                    const _SectionLabel(label: 'DEV TOOLS'),
                    const SizedBox(height: 12),

                    _HomeButton(
                      label: 'BAND GENERATOR',
                      subtitle: 'Full complex band gen',
                      icon: Icons.tune,
                      color: Colors.deepOrangeAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                BandGenDevScreen(generator: bandGenerator)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _HomeButton(
                      label: 'BAND NAME GEN',
                      subtitle: 'Pattern-based name test',
                      icon: Icons.album,
                      color: Colors.purpleAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                BandNameTestScreen(generator: bandGenerator)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _HomeButton(
                      label: 'SURNAME TEST',
                      subtitle: '5 names per generation method',
                      icon: Icons.science,
                      color: Colors.tealAccent,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SurnameTestScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SHARED WIDGETS ──────────────────────────────────────────────────────────

class _HomeButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _HomeButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.55),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white12)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white24,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white12)),
      ],
    );
  }
}
