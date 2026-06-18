import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'generators/band_generator.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/gallery/agent_gallery_screen.dart';
import 'screens/releases/releases_screen.dart';
import 'screens/jobfinder/jobfinder_screen.dart';
import 'widgets/ad_banner.dart';

import 'screens/devtools/dev_tools_screen.dart';

final bandGenerator = BandGenerator();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  await bandGenerator.init();
  runApp(const ProviderScope(child: SonicEmpireApp()));
}

class SonicEmpireApp extends StatelessWidget {
  const SonicEmpireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonic Empire',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const MainShell(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0E0E0E),
      primaryColor: const Color(0xFFE8B84B),
      colorScheme: const ColorScheme.dark(
        primary:   Color(0xFFE8B84B),
        secondary: Color(0xFF4BB8A0),
        surface:   Color(0xFF1A1A1A),
        error:     Color(0xFFCF4E4E),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1A1A1A),
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141414),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'monospace',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: Color(0xFFE8B84B),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF141414),
        selectedItemColor: Color(0xFFE8B84B),
        unselectedItemColor: Color(0xFF555555),
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          letterSpacing: 0.5,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF252525),
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color(0xFFCCCCCC)),
        bodySmall:  TextStyle(color: Color(0xFF888888)),
      ),
    );
  }
}

// ─── MAIN SHELL ──────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    AgentGalleryScreen(),
    ReleasesScreen(),
    JobFinderScreen(),
    DevToolsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── AdMob banner pinned just above the nav bar ──
          const AdBanner(),
          const Divider(height: 1, thickness: 1, color: Color(0xFF252525)),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded),
                label: 'Agents',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.album_rounded),
                label: 'Releases',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_rounded),
                label: 'JF.fart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bug_report_rounded),
                label: 'Dev',
              ),
            ],
          ),
        ],
      ),
    );
  }
}