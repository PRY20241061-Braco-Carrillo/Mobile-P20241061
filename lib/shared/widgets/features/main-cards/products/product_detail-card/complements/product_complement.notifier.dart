import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComplementNotifier extends StateNotifier<Map<String, int>> {
  ComplementNotifier() : super({});

  void addComplement(String complementId, int freeAmount) {
    state = {
      ...state,
      complementId: (state[complementId] ?? 0) + 1,
    };

    if (state[complementId]! > freeAmount) {
      // Manejar la lógica de cobro extra aquí si es necesario
    }
  }

  void removeComplement(String complementId) {
    if (state[complementId] != null && state[complementId]! > 0) {
      state = {
        ...state,
        complementId: state[complementId]! - 1,
      };
    }
  }

  int getComplementCount(String complementId) {
    return state[complementId] ?? 0;
  }
}

final complementProvider =
    StateNotifierProvider<ComplementNotifier, Map<String, int>>((ref) {
  return ComplementNotifier();
});
