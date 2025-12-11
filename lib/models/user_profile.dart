// user_profile.dart
// Clean, production-grade data model with full documentation.
// Designed for use in state-management, network parsing, and UI rendering.

/// Core immutable data model representing a user's profile
/// inside the matching/swipe feature.
///
/// This model is intentionally lightweight and strictly typed,
/// making it safe for:
/// - Bloc/Provider state containers
/// - JSON serialization
/// - UI rendering without mutation side-effects
class UserProfile {
  /// Unique user identifier (UUID or backend ID).
  final String id;

  /// Display name for the user.
  final String name;

  /// Age of the user.
  final int age;

  /// Short description or headline about the user.
  final String headline;

  /// School or educational background.
  final String school;

  /// User's current city or region.
  final String location;

  /// Primary profile image URL (used as main card photo).
  final String imageUrl;

  /// A list of small tag-like attributes (e.g., MBTI, zodiac, hobbies).
  final List<String> chips;

  /// Additional photos displayed in the user's profile gallery.
  final List<String> photos;

  /// Immutable constructor for a full profile object.
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.headline,
    required this.school,
    required this.location,
    required this.imageUrl,
    required this.chips,
    required this.photos,
  });

  /// Factory generator for demo/mock profiles.
  ///
  /// Useful for local development, prototyping UI layouts,
  /// or generating placeholder data for testing.
  factory UserProfile.sample(int i) => UserProfile(
        id: '$i',
        name: ['Rania', 'Sarah', 'Citra', 'Budi'][(i - 1) % 4],
        age: 22 + i,
        headline: i.isEven ? 'Mahasiswa' : 'Pekerjaan',
        school: i.isEven ? 'Universitas Pamulang' : 'Universitas XYZ',
        location: 'Depok, West Java',
        imageUrl: 'https://picsum.photos/900/1400?random=${i + 10}',
        chips: ['24', 'ISFJ', 'Aries'],
        photos: [
          "https://picsum.photos/200",
          "https://picsum.photos/201",
        ],
      );
}