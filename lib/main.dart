// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'game/doodle_dash.dart';
import 'game/util/util.dart';
import 'game/widgets/widgets.dart';
import 'login/login/cubit/auth_cubit.dart';
import 'login/login/cubit/my_user_cubit.dart';
import 'login/login/provider/auth.dart';
import 'login/login/provider/my_user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authCubit = AuthCubit(AuthRepository());

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => authCubit..init()),
    BlocProvider(create: (context) => MyUserCubit(MyUserRepository())),
  ], child: MyApp.create()));
}

class MyApp extends StatelessWidget {
  static Widget create() {
    return const MyApp();
  }

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PowerUp',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PowerUp'),
    );
  }
}

final Game game = DoodleDash();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
              minWidth: 550,
            ),
            child: GameWidget(
              game: game,
              overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
                'gameOverlay': (context, game) => GameOverlay(game),
                'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
                'gameOverOverlay': (context, game) => GameOverOverlay(game),
              },
            ),
          );
        }),
      ),
    );
  }
}
