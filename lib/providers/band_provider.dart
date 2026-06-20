// lib/providers/band_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/band.dart';
import '../generators/band_generator.dart';

// ---------------------------------------------------------------------------
// Band Provider
// ---------------------------------------------------------------------------

/// Holds the label's current roster of generated bands in app state.
/// On first build, generates a starting set so there's something to work
/// with — exact starting-roster logic (tied to the chosen Agent Package)
/// comes later and will likely replace this default generation.
final bandProvider = AsyncNotifierProvider<BandNotifier, List<Band>>(
  BandNotifier.new,
);

class BandNotifier extends AsyncNotifier<List<Band>> {
  @override
  Future<List<Band>> build() async {
    final generator = BandGenerator();
    await generator.init();
    return List.generate(5, (_) => generator.generate());
  }

  /// Adds a newly generated or scouted band to the roster.
  void addBand(Band band) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([...current, band]);
  }

  /// Replaces a band in the roster by name match.
  /// Used when a gameplay event modifies a band's stats, traits, etc.
  void updateBand(Band updated) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final b in current)
        if (b.name == updated.name) updated else b,
    ]);
  }

  /// Removes a band from the roster — e.g. dropped from the label.
  void removeBand(Band band) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.where((b) => b.name != band.name).toList());
  }
}
