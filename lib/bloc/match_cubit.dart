// lib/bloc/match_cubit.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_profile.dart';
part 'match_state.dart';

/// MatchCubit manages a swipe-like list of profiles.
/// It handles navigation, removal, and list resets.
/// State fields:
///   - profiles: Remaining profiles to display.
///   - currentIndex: Currently selected profile.
///   - lastAction: The last performed operation (e.g., "like", "pass").
class MatchCubit extends Cubit<MatchState> {
  /// Initializes Cubit with an initial list of profiles.
  /// Current index always starts at 0 for consistency.
  MatchCubit(List<UserProfile> initialProfiles)
      : super(
          MatchState(
            profiles: List.of(initialProfiles),
            currentIndex: 0,
          ),
        );

  /// Updates the current index when the UI's PageView changes.
  /// Index is automatically clamped to valid boundaries.
  void setCurrentIndex(int index) {
    if (index < 0) index = 0;

    final maxIndex = state.profiles.isEmpty ? 0 : state.profiles.length - 1;
    final safeIndex = index > maxIndex ? maxIndex : index;

    emit(
      state.copyWith(
        currentIndex: safeIndex,
        lastAction: null,
      ),
    );
  }

  /// Moves to the next available profile without removing anything.
  /// If already at the last profile, no action is performed.
  void next() {
    final current = state.currentIndex;
    final maxIndex = state.profiles.isEmpty ? 0 : state.profiles.length - 1;

    if (current < maxIndex) {
      emit(
        state.copyWith(
          currentIndex: current + 1,
          lastAction: null,
        ),
      );
    }
  }

  /// Removes the current profile and moves forward logically.
  /// Used when the user performs a "pass" action.
  void pass() {
    _removeCurrent("pass");
  }

  /// Removes the current profile and moves forward logically.
  /// Used when the user performs a "like" action.
  void like() {
    _removeCurrent("like");
  }

  /// Resets the entire profile list and sets index to the beginning.
  void reset(List<UserProfile> profiles) {
    emit(
      MatchState(
        profiles: List.of(profiles),
        currentIndex: 0,
        lastAction: null,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Internal Helpers
  // ---------------------------------------------------------------------------

  /// Shared logic for removing the currently selected profile.
  /// After removal, it computes the next safe index to display.
  void _removeCurrent(String action) {
    final current = state.currentIndex;
    final updatedList = List<UserProfile>.from(state.profiles);

    if (updatedList.isEmpty) {
      // Nothing to remove; just record the action
      emit(state.copyWith(lastAction: action));
      return;
    }

    if (current >= 0 && current < updatedList.length) {
      updatedList.removeAt(current);
    }

    final nextIndex = _computeSafeIndexAfterRemoval(current, updatedList.length);

    emit(
      state.copyWith(
        profiles: updatedList,
        currentIndex: nextIndex,
        lastAction: action,
      ),
    );
  }

  /// Computes the correct index to show after removing an item.
  /// Example:
  ///   - If removing from middle, stay on same index (now showing next item).
  ///   - If removing the last item, move index to new last item.
  int _computeSafeIndexAfterRemoval(int oldIndex, int newLength) {
    if (newLength <= 0) return 0; // No profiles left

    if (oldIndex >= 0 && oldIndex < newLength) {
      return oldIndex; // Safe to keep the same index
    }

    return newLength - 1; // Clamp to last valid index
  }
}
