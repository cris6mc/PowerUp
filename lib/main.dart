import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jueguito2/firebase_options.dart';
import 'package:jueguito2/game/assets.dart';
import 'package:jueguito2/game/high_scores.dart';
import 'package:jueguito2/game/my_game.dart';
import 'package:jueguito2/game/navigation/routes.dart';
import 'package:jueguito2/game/ui/game_over_menu.dart';
import 'package:jueguito2/game/ui/pause_menu.dart';
import 'dart:io' show Platform;

import 'package:jueguito2/game/widgets/game_overlay.dart';
import 'package:jueguito2/login/login/cubit/auth_cubit.dart';
import 'package:jueguito2/login/login/cubit/my_user_cubit.dart';
import 'package:jueguito2/login/login/provider/auth.dart';
import 'package:jueguito2/login/login/provider/my_user_repository.dart';

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
  ], child: const MaterialApp(
    debugShowCheckedModeBanner: false,
    onGenerateRoute: Routes.routes,
  ),));
}

class MyGameWidget extends StatelessWidget {
  const MyGameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

    return GameWidget(
      game: MyGame(),
      overlayBuilderMap: {
        'GameOverMenu': (context, MyGame game) {
          return GameOverMenu(game: game);
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