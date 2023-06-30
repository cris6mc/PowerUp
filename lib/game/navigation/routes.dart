import 'dart:core';

import 'package:flutter/material.dart';
import 'package:jueguito2/game/widgets/widgets.dart';
import 'package:jueguito2/login/login/view/login_screen.dart';
import 'package:jueguito2/main.dart';
import 'package:jueguito2/game/ui/leaderboards_screen.dart';

enum Routes {
  main('/'),
  login('/login'),
  game('/game'),
  leaderboard('/leaderboard');

  final String route;

  const Routes(this.route);

  static Route routes(RouteSettings settings) {
    MaterialPageRoute buildRoute(Widget widget) {
      return MaterialPageRoute(builder: (_) => widget, settings: settings);
    }

    final routeName = Routes.values.firstWhere((e) => e.route == settings.name);

    switch (routeName) {
      case Routes.main:
        return buildRoute(const MainMenuOverlay());
      case Routes.game:
        return buildRoute(const MyGameWidget());
      case Routes.leaderboard:
        return buildRoute(const LeaderboardScreen());
      case Routes.login:
        return buildRoute(const MyScreen());
      default:
        throw Exception('Route does not exists');
    }
  }
}

extension BuildContextExtension on BuildContext {
  void pushAndRemoveUntil(Routes route) {
    Navigator.pushNamedAndRemoveUntil(this, route.route, (route) => false);
  }

  void push(Routes route) {
    Navigator.pushNamed(this, route.route);
  }
}
