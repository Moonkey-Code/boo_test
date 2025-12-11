import 'package:flutter/material.dart';
import '../models/user_profile.dart';

/// A stylized profile display card used in the matching flow.
/// Shows profile image, metadata, interests, and location info.
class ProfileCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    const radius = 22.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.62,
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F10),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.7),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ------------------------------------------------------------
            // FULL BACKGROUND IMAGE
            // ------------------------------------------------------------
            Positioned.fill(
              child: Image.network(
                profile.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: Colors.grey[900]),
              ),
            ),

            // ------------------------------------------------------------
            // BOTTOM GRADIENT OVERLAY FOR READABILITY
            // ------------------------------------------------------------
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                  ),
                ),
              ),
            ),

            // ------------------------------------------------------------
            // INTEREST COUNT BADGE (TOP RIGHT)
            // ------------------------------------------------------------
            Positioned(
              right: 14,
              top: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.star, size: 14, color: Colors.white70),
                    SizedBox(width: 6),
                    Text(
                      '3 INTERESTS',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------------------
            // PROFILE DETAILS (BOTTOM SECTION)
            // ------------------------------------------------------------
            Positioned(
              left: 18,
              right: 18,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAME + VERIFIED BADGE
                  Row(
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // HEADLINE
                  Text(
                    profile.headline,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // SCHOOL
                  Text(
                    profile.school,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // LOCATION ROW
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.white70),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          profile.location,
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // CHIPS / TAGS
                  Wrap(
                    spacing: 8,
                    children: profile.chips
                        .map(
                          (chip) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              chip,
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),

            // ------------------------------------------------------------
            // TIMESTAMP (BOTTOM RIGHT)
            // ------------------------------------------------------------
            const Positioned(
              right: 16,
              bottom: 12,
              child: Text(
                '2023/1/26 16:20',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}