import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/presentation/screens/DetailScreen.dart';
import 'package:new_app/presentation/screens/HomeScreen.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return NoTransitionPage(key: state.pageKey, child: const HomeScreen());
      },
      routes: <RouteBase>[
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
                    begin: const Offset(1, 0), // Start off-screen (Right side)
                    end: Offset.zero, // End at the final position
                  ).animate(animation),
                  child: child, // ✅ Add child here
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);
