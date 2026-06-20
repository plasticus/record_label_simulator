import 'package:flutter/material.dart';

// ─── DASHBOARD SCREEN ────────────────────────────────────────────────────────
// Financial overview, cash flow, news headlines, upcoming events.
// End Turn button lives here.
//
// STATUS: Hardcoded placeholder data. No real game state wired up yet —
// once a financials/turn provider exists, swap the _placeholder* values
// below for ref.watch() calls.

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ── Placeholder data — replace with real state once it exists ──
  static const double _placeholderCash = 18450.00;
  static const double _placeholderWeeklyRevenue = 2150.00;
  static const double _placeholderWeeklyExpenses = 1680.00;
  static const int _placeholderTurnNumber = 7;

  static const List<_WeekEvent> _placeholderEvents = [
    _WeekEvent(
      icon: Icons.album_rounded,
      title: 'Neon Pulse album drops Friday',
      subtitle: 'Recording wrapped — Marketing push begins',
      color: Color(0xFFE8B84B),
    ),
    _WeekEvent(
      icon: Icons.warning_amber_rounded,
      title: 'Talia Vance wants a raise',
      subtitle: 'Respond before her morale drops further',
      color: Color(0xFFCF4E4E),
    ),
    _WeekEvent(
      icon: Icons.flight_takeoff_rounded,
      title: 'Aero-Silk tour kicks off',
      subtitle: 'North America leg — 6 dates booked',
      color: Color(0xFF4BB8A0),
    ),
  ];

  static const List<_NewsHeadline> _placeholderNews = [
    _NewsHeadline(
      headline: '"A War Crime Against Ears" — Sub-Zero Friction\'s new single panned',
      tag: 'REVIEW',
    ),
    _NewsHeadline(
      headline: 'Lunar Colonies streaming numbers up 14% label-wide',
      tag: 'MARKET',
    ),
    _NewsHeadline(
      headline: 'JobFinder.fart sees record signups amid label hiring spree',
      tag: 'INDUSTRY',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final netWeekly = _placeholderWeeklyRevenue - _placeholderWeeklyExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SONIC EMPIRE'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            child: ElevatedButton(
              onPressed: null, // TODO: wire up turn logic
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8B84B),
                disabledBackgroundColor:
                    const Color(0xFFE8B84B).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text(
                'END TURN',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TurnBanner(turnNumber: _placeholderTurnNumber),
          const SizedBox(height: 16),
          _FinancialsCard(
            cash: _placeholderCash,
            weeklyRevenue: _placeholderWeeklyRevenue,
            weeklyExpenses: _placeholderWeeklyExpenses,
            netWeekly: netWeekly,
          ),
          const SizedBox(height: 16),
          _SectionHeader(label: 'THIS WEEK', icon: Icons.calendar_today_rounded),
          const SizedBox(height: 8),
          ..._placeholderEvents.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _EventTile(event: e),
              )),
          const SizedBox(height: 16),
          _SectionHeader(label: 'NEWS', icon: Icons.newspaper_rounded),
          const SizedBox(height: 8),
          ..._placeholderNews.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _NewsTile(news: n),
              )),
        ],
      ),
    );
  }
}

// ─── TURN BANNER ─────────────────────────────────────────────────────────────

class _TurnBanner extends StatelessWidget {
  final int turnNumber;
  const _TurnBanner({required this.turnNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'WEEK $turnNumber',
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const Text(
          'Indie Records Co.',
          style: TextStyle(
            color: Color(0xFF888888),
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// ─── FINANCIALS CARD ─────────────────────────────────────────────────────────

class _FinancialsCard extends StatelessWidget {
  final double cash;
  final double weeklyRevenue;
  final double weeklyExpenses;
  final double netWeekly;

  const _FinancialsCard({
    required this.cash,
    required this.weeklyRevenue,
    required this.weeklyExpenses,
    required this.netWeekly,
  });

  String _money(double v) {
    final sign = v < 0 ? '-' : '';
    final abs = v.abs();
    return '$sign\$${abs.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = netWeekly >= 0;
    final netColor = isPositive ? const Color(0xFF4BB8A0) : const Color(0xFFCF4E4E);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cash on hand, big number ──
          const Text(
            'CASH ON HAND',
            style: TextStyle(
              color: Color(0xFF555555),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _money(cash),
            style: const TextStyle(
              color: Color(0xFFE8B84B),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFF252525)),
          const SizedBox(height: 14),

          // ── Revenue / Expenses / Net row ──
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'REVENUE',
                  value: _money(weeklyRevenue),
                  color: const Color(0xFF4BB8A0),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'EXPENSES',
                  value: _money(weeklyExpenses),
                  color: const Color(0xFFCF4E4E),
                ),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'NET / WK',
                  value: '${isPositive ? '+' : ''}${_money(netWeekly)}',
                  color: netColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF555555), size: 14),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF555555),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─── THIS WEEK EVENTS ────────────────────────────────────────────────────────

class _WeekEvent {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  const _WeekEvent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _EventTile extends StatelessWidget {
  final _WeekEvent event;
  const _EventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: event.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(event.icon, color: event.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── NEWS ─────────────────────────────────────────────────────────────────────

class _NewsHeadline {
  final String headline;
  final String tag;
  const _NewsHeadline({required this.headline, required this.tag});
}

class _NewsTile extends StatelessWidget {
  final _NewsHeadline news;
  const _NewsTile({required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE8B84B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              news.tag,
              style: const TextStyle(
                color: Color(0xFFE8B84B),
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              news.headline,
              style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
