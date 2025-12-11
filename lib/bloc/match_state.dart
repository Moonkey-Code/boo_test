// match_state.dart
// Detailed and production-ready version with senior-level documentation.
// Part of the Match Cubit state-management system.

part of 'match_cubit.dart';

/// Immutable state container for the Match feature.
///
/// This state tracks:
/// - [profiles]: The remaining list of user profiles in the swipe deck.
/// - [currentIndex]: The index of the currently visible profile.
/// - [lastAction]: The last swipe action performed by the user (e.g. "like", "pass").
///
/// All fields are immutable to ensure predictable state transitions
/// and to maintain compatibility with Bloc's change detection.
class MatchState extends Equatable {
  /// Remaining profiles in the deck. When one is liked or passed,
  /// the Cubit removes it and emits a new state.
  final List<UserProfile> profiles;

  /// Index of the currently selected profile in [profiles].
  final int currentIndex;

  /// Last swipe action performed by the user.
  /// Useful for triggering animations or UI reactions.
  final String? lastAction;

  /// Creates a new immutable [MatchState] instance.
  const MatchState({
    required this.profiles,
    required this.currentIndex,
    this.lastAction,
  });

  /// Returns a new state with selective updates.
  ///
  /// - [profiles] overrides the list only if provided.
  /// - [currentIndex] overrides the index only if provided.
  /// - [lastAction] is always replaced (explicit null allowed).
  ///
  /// Ensures immutability and safe partial updates.
  MatchState copyWith({
    List<UserProfile>? profiles,
    int? currentIndex,
    String? lastAction,
  }) {
    return MatchState(
      profiles: profiles ?? this.profiles,
      currentIndex: currentIndex ?? this.currentIndex,
      lastAction: lastAction,
    );
  }

  /// Equatable props ensure efficient comparison and
  /// prevent unnecessary UI rebuilds.
  @override
  List<Object?> get props => [profiles, currentIndex, lastAction];
}
