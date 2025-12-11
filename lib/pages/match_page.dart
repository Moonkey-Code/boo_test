import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/match_cubit.dart';
import '../models/user_profile.dart';
import '../widgets/profile_card.dart';
import '../widgets/action_row.dart';

/// NOTE: This extension is assumed to exist in the original context
/// to support the non-standard `.withValues(alpha: ...)` usage found in the code.
extension ColorAlphaExtension on Color {
  Color withValues({double alpha = 1.0}) {
    // Implementing the assumed functionality to control opacity/alpha
    return this.withOpacity(alpha);
  }
}

/// The main profile matching screen where users can view and swipe profiles.
///
/// This StatefulWidget manages the animation state for the profile card
/// when a 'Like' or 'Pass' action is performed.
class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin {
  /// Controller for the vertical scrolling of the profile details.
  late final PageController _pageController;

  /// Controller to manage the swipe animation duration and state.
  late AnimationController _swipeController;

  /// Animation defined by a Tween for the card's horizontal offset during a swipe.
  late Animation<Offset> _swipeAnimation;

  /// Flag to prevent multiple simultaneous swipe animations.
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Initial setup for the animation, starting and ending at Offset.zero.
    // The 'end' value will be updated dynamically in `_animateAndRemove`.
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // This will be updated later during like/pass action
    ).animate(
      CurvedAnimation(
        parent: _swipeController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  /// Initiates the horizontal swipe animation and dispatches the corresponding
  /// action (like or pass) to the [MatchCubit] upon completion.
  void _animateAndRemove({required bool isLike}) async {
    if (_isAnimating) return;

    _isAnimating = true;

    // Determine the distance for the swipe-out effect: 500.0 right for Like, -500.0 left for Pass.
    final double dx = isLike ? 500.0 : -500.0;

    // Update the Tween to define the animation path from current position to the swipe-out point.
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, 0),
    ).animate(
      CurvedAnimation(
        parent: _swipeController,
        curve: Curves.easeOut,
      ),
    );

    // Run the animation to the end.
    await _swipeController.forward();

    if (!mounted) return;

    // Dispatch the state change to remove the profile from the view list.
    if (isLike) {
      context.read<MatchCubit>().like();
    } else {
      context.read<MatchCubit>().pass();
    }

    // Reset the controller immediately for the next card, ready for the next swipe.
    _swipeController.reset();
    _isAnimating = false;
  }

  /// Helper function to build the pill-shaped navigation tabs in the AppBar's bottom section.
  Widget _pillTab(String text, bool active, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: active ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.black : Colors.white70,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }

  /// Helper function to build a generic content chip (used in LOOKING FOR and Personality).
  Widget _chip(String label, {bool filled = false, Color? accent}) {
    final Color? bg = filled ? accent : Colors.black;
    final Color txt = filled ? Colors.black : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
          width: 1.0,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: txt,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Helper function to build a hashtag-style interest chip.
  Widget _hash(String label, {bool active = false}) {
    final Color bg = active ? const Color(0xFF2CE7DC) : Colors.black;
    final Color txt = active ? Colors.black : Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
          width: 1.0,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: txt,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define the accent color once for consistency
    final Color accent = const Color(0xFF2CE7DC);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Custom leading width to accommodate multiple icons
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Menu Icon Button
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {}, // action placeholder
                tooltip: 'Menu',
              ),
              const SizedBox(width: 6),
              // Lightning 'Boost' Pill Icon
              Container(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  // Soft yellow color, using assumed extension method
                  color: const Color(0xFFFFE88A).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child:
                    const Center(child: Icon(Icons.bolt, size: 18, color: Colors.black)),
              ),
            ],
          ),
        ),

        // Central title
        title: const Text('BOO',
            style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w800)),

        // Right-side action icons (Privacy/Filter)
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            onPressed: () {}, // action placeholder
            tooltip: 'Privacy',
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {}, // action placeholder
            tooltip: 'Filter',
          ),
          const SizedBox(width: 6),
        ],

        // Bottom section for the discovery/mode tabs
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(66),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pillTab('NEW SOULS', true, accent),
                const SizedBox(width: 12),
                _pillTab('DISCOVERY', false, accent),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        // BlocBuilder rebuilds the UI when the list of profiles changes
        child: BlocBuilder<MatchCubit, MatchState>(
          builder: (context, state) {
            final profiles = state.profiles;

            // Display fallback message if the profile list is empty
            if (profiles.isEmpty) {
              return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('No more profiles', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  // Reset button for demo/testing purposes
                  ElevatedButton(
                    onPressed: () => context.read<MatchCubit>().reset(
                        [UserProfile.sample(1), UserProfile.sample(2), UserProfile.sample(3)]),
                    child: const Text('Reset'),
                  )
                ]),
              );
            }

            // Stack layers the swipeable profile content and the fixed action buttons
            return Stack(
              children: [
                // Animated Profile View
                AnimatedBuilder(
                  animation: _swipeAnimation,
                  builder: (context, child) {
                    // Applies the horizontal translation and fade-out opacity during swipe
                    return Transform.translate(
                      offset: _swipeAnimation.value,
                      child: Opacity(
                        opacity: _isAnimating ? (1 - _swipeController.value) : 1,
                        child: child,
                      ),
                    );
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical, // Vertical scrolling for profile details
                    itemCount: profiles.length,
                    // Update the Cubit state when the user scrolls to a new profile
                    onPageChanged: (i) => context.read<MatchCubit>().setCurrentIndex(i),
                    itemBuilder: (context, index) => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(children: [
                          // Main profile photo and details header
                          ProfileCard(profile: profiles[index]),
                          const SizedBox(height: 14),

                          // LOOKING FOR section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xFF0E0E0F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('LOOKING FOR',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70)),
                                  const SizedBox(height: 8),
                                  Wrap(spacing: 8, children: [
                                    _chip('Dating', filled: true, accent: accent),
                                    _chip('Almost never'),
                                    _chip('In college'),
                                  ])
                                ]),
                          ),

                          // INTERESTS and Languages section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: const Color(0xFF0E0E0F),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Interests',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70)),
                                  const SizedBox(height: 8),
                                  Wrap(spacing: 8, children: [
                                    _hash('#music', active: true),
                                    _hash('#movies', active: true),
                                    _hash('#food'),
                                  ]),
                                  const SizedBox(height: 12),
                                  const Text('Languages',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white70)),
                                  const SizedBox(height: 6),
                                  const Text('ENGLISH  INDONESIAN',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white70))
                                ]),
                          ),

                          // --- Photos (vertical list that scrolls with the page) ---
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vertical list of photos rendered as Column children
                              Column(
                                children: List.generate(profiles[index].photos.length, (i) {
                                  final url = profiles[index].photos[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height *
                                            0.62,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(22),
                                          child: Image.network(
                                            url,
                                            fit: BoxFit.cover,
                                            // Custom loading state
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                color: Colors.grey[900],
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 28,
                                                    height: 28,
                                                    child: CircularProgressIndicator(
                                                        strokeWidth: 2),
                                                  ),
                                                ),
                                              );
                                            },
                                            // Custom error state
                                            errorBuilder: (_, _, _) => Container(
                                              color: Colors.grey[800],
                                              child: const Center(
                                                child: Icon(Icons.broken_image,
                                                    color: Colors.white24,
                                                    size: 36),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                          // --- Personality Strengths & Weaknesses (from uploaded photo) ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E0E0F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Strengths Title
                                const Text(
                                  '👍 Strengths',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Strengths list (chips)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _chip('supportive'),
                                    _chip('reliable and patient'),
                                    _chip('imaginative and observant'),
                                    _chip('enthusiastic'),
                                    _chip('loyal and hard-working'),
                                    _chip('good practical skills'),
                                  ],
                                ),

                                const SizedBox(height: 26),

                                // Weaknesses Title
                                const Text(
                                  '👎 Weaknesses',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Weaknesses list (chips)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _chip('humble and shy'),
                                    _chip('take things too personally'),
                                  ],
                                ),
                                // --- Bottom Emoji Row (from uploaded photo) ---
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0E0E0F),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    // List of Emojis for quick reactions/tags
                                    child: Row(
                                      children: const [
                                        Text('👍', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('👎', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('😍', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('😡', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('🖕', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('🤫', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('⚽', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('🎁', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('🧠', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('🫣', style: TextStyle(fontSize: 15)),
                                        SizedBox(width: 14),
                                        Text('✌️', style: TextStyle(fontSize: 15)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Extra padding to ensure content above the bottom action bar is visible
                          const SizedBox(height: 150)
                        ]),
                      ),
                    ),
                  ),
                ),

                // Fixed Bottom Action Row
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ActionRow(
                    // Link actions to the swipe animation handler
                    onLike: () => _animateAndRemove(isLike: true),
                    onPass: () => _animateAndRemove(isLike: false),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}