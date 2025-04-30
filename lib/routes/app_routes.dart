import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/presentation/screens/AnimationScreen.dart';
import 'package:new_app/presentation/screens/DetailScreen.dart';
import 'package:new_app/presentation/screens/FavoritesScreen.dart';
import 'package:new_app/presentation/screens/HomeScreen.dart';
import 'package:new_app/presentation/screens/LoginScreen.dart';
import 'package:new_app/presentation/screens/RadioScreen.dart';
import 'package:new_app/presentation/screens/SearchScreen.dart';
import 'package:new_app/presentation/screens/SliderScreen.dart';
import 'package:new_app/presentation/widgets/ParentWidget.dart';
import 'package:new_app/providers/pokemon.providers.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final userAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = userAsync.asData?.value != null;
      final isGoingToLogin = state.uri.path == '/login';
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      } else if (isLoggedIn && isGoingToLogin) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return NoTransitionPage(child: const ParentWidget());
        },
        routes: [
          GoRoute(
            path: 'details/:name',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final name = state.pathParameters['name'] ?? "Unknown";
              final allData = state.extra as Map<String, dynamic>;
              return CustomTransitionPage(
                key: state.pageKey,
                child: Detailscreen(name: name, allData: allData),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/favs',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/sliders',
            builder: (context, state) => const Sliderscreen(),
          ),
          GoRoute(
            path: '/bluetooth',
            builder: (context, state) => const Sliderscreen(),
          ),
          GoRoute(
            path: '/radios',
            builder: (context, state) => const Radioscreen(),
          ),
          GoRoute(
            path: '/animations',
            builder: (context, state) => const AnimationScreen(),
          ),
          GoRoute(
            path: "/search/:nameId",
            pageBuilder: (context, state) {
              final nameOrId = state.pathParameters['nameId'] ?? 'unknown';

              return CustomTransitionPage(
                key: state.pageKey,
                child: Searchscreen(
                  nameOrId: nameOrId,
                ), // replace with your actual screen
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = Offset(0.0, -1.0);
                  const end = Offset.zero;
                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: Curves.easeInOut));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
});
