import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/match_cubit.dart';
import 'models/user_profile.dart';
import 'pages/match_page.dart';

/// Application entry point.
/// Initializes mock user profiles and boots the Flutter app.
void main() {
  final initialProfiles = [
    UserProfile.sample(1),
    UserProfile.sample(2),
    UserProfile.sample(3),
    UserProfile.sample(4),
  ];

  runApp(MyApp(initialProfiles: initialProfiles));
}

/// Root widget configuring global theme and dependency injection.
class MyApp extends StatelessWidget {
  /// Initial list of profiles injected into the MatchCubit.
  final List<UserProfile> initialProfiles;

  const MyApp({super.key, required this.initialProfiles});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boo Match UI (BLoC)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040405),
      ),

      // Injects MatchCubit so MatchPage can access it.
      home: BlocProvider(
        create: (_) => MatchCubit(initialProfiles),
        child: const MatchPage(),
      ),
    );
  }
}