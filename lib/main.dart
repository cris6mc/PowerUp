import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jueguito2/firebase_options.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/ui/game_over_menu.dart';
import 'package:jueguito2/game/ui/pause_menu.dart';
import 'package:jueguito2/game/util/color_schemes.dart';
import 'package:jueguito2/game/widgets/game_over_overlay.dart';
import 'dart:io' show Platform;

import 'package:jueguito2/game/widgets/game_overlay.dart';
import 'package:jueguito2/login/login/cubit/auth_cubit.dart';
import 'package:jueguito2/login/login/cubit/my_user_cubit.dart';
import 'package:jueguito2/login/login/provider/auth.dart';
import 'package:jueguito2/login/login/provider/my_user_repository.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HighScores.load();
  await Assets.load();

  final authCubit = AuthCubit(AuthRepository());

  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => authCubit..init()),
    BlocProvider(create: (context) => MyUserCubit(MyUserRepository())),
  ], child: MyApp.create()));
}

enum Character { dash, sparky, hero }

class MyProvider with ChangeNotifier {
  Character _myValue = Character.dash;
  Character get myValue => _myValue;
  void updateValue(Character newValue) {
    _myValue = newValue;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  static Widget create() {
    return const MyApp();
  }

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Character character = Character.dash;

    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
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
        onGenerateRoute: Routes.routes,
      ),
    );
  }
}

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myCharacter = Provider.of<MyProvider>(context, listen: false);
    return GameWidget(
      game: MyGame(character: myCharacter._myValue),
      overlayBuilderMap: {
        'GameOverMenu': (context, MyGame game) {
          return GameOverOverlay(game: game);
        },
        'PauseMenu': (context, MyGame game) {
          return PauseMenu(game: game);
        },
        'GameOverlay': (context, MyGame game) {
          return GameOverlay(game: game);
        }
      },
    );
  }
}
