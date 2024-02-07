import 'package:allaboutclubs/pages/club_detail_page.dart';
import 'package:allaboutclubs/pages/error_page.dart';
import 'package:allaboutclubs/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouteProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'root',
          builder: (context, state) =>
              MyHomePage(key: state.pageKey, title: 'all about clubs'),
        ),
        GoRoute(
            path: '/detail/:id',
            name: 'detail',
            builder: (context, state) => ProviderScope(
                  overrides: [
                    selectedClubId
                        .overrideWithValue(state.pathParameters['id'] ?? ''),
                  ],
                  child: const ClubDetailPage(),
                )),
      ],
      errorPageBuilder: (context, state) {
        return MaterialPage(child: ErrorPage(ex: state.error));
      });
});
