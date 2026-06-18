import 'package:flutter/material.dart';

// ─── AD BANNER ───────────────────────────────────────────────────────────────
// Reserved slot for AdMob banner ads (320×50).
// In debug/dev mode, renders a subtle placeholder so layout is preserved.
// Swap the placeholder Container for a real BannerAd widget when AdMob
// is initialized for production.
//
// Usage: place AdBanner() at the top of any high-traffic screen
// (Home, Agent Dashboard). It sits above the rest of the screen content.

const double kBannerHeight = 50.0;

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace this placeholder with real AdMob BannerAd widget.
    // When AdMob is live:
    //   1. Add google_mobile_ads to pubspec.yaml
    //   2. Initialize MobileAds.instance.initialize() in main()
    //   3. Replace the Container below with your BannerAdWidget
    return Container(
      width: double.infinity,
      height: kBannerHeight,
      color: const Color(0xFF1A1A1A),
      child: const Center(
        child: Text(
          'AD',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
