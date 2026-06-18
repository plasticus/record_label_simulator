// lib/providers/band_manager_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/band_manager.dart';

// ---------------------------------------------------------------------------
// Band Manager Provider
// ---------------------------------------------------------------------------

/// Loads the full list of BandManagers from assets/data/band_managers.json.
/// This is an [AsyncNotifierProvider] so the UI can handle loading/error
/// states cleanly without managing them manually in initState.
///
/// Usage in a widget:
///   final managers = ref.watch(bandManagerProvider);
///   managers.when(
///     data: (list) => ...,
///     loading: () => CircularProgressIndicator(),
///     error: (e, _) => Text('Error: $e'),
///   );
final bandManagerProvider =
    AsyncNotifierProvider<BandManagerNotifier, List<BandManager>>(
  BandManagerNotifier.new,
);

class BandManagerNotifier extends AsyncNotifier<List<BandManager>> {
  @override
  Future<List<BandManager>> build() async {
    return loadBandManagers();
  }

  /// Replaces the full list — useful for future save/load game state.
  void setManagers(List<BandManager> managers) {
    state = AsyncData(managers);
  }

  /// Updates a single manager in the list by name match.
  /// Used when a gameplay event modifies a manager's morale, traits, etc.
  void updateManager(BandManager updated) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final m in current)
        if (m.name == updated.name) updated else m,
    ]);
  }
}