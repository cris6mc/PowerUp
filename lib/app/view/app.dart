// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../game/doodle_dash.dart';
// import '../../game/util/color_schemes.dart';
// import '../../game/widgets/widgets.dart';
// import '../../login/login/cubit/auth_cubit.dart';
// import '../../login/login/view/login_screen.dart';
// import '../../login/sign_up/view/form_sign_up.dart';
// import '../../other%20screens/splash_screen.dart';
// import '../../profile/cubit/my_user_cubit.dart';

// final _navigatorKey = GlobalKey<NavigatorState>();

// class MyApp extends StatelessWidget {
//   static Widget create() {
//     return const MyApp();
//   }

//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Doodle Dash',
//       themeMode: ThemeMode.dark,
//       theme: ThemeData(
//         colorScheme: lightColorScheme,
//         useMaterial3: true,
//       ),
//       darkTheme: ThemeData(
//         colorScheme: darkColorScheme,
//         textTheme: GoogleFonts.audiowideTextTheme(ThemeData.dark().textTheme),
//         useMaterial3: true,
//       ),
//       debugShowCheckedModeBanner: false,
//       navigatorKey: _navigatorKey,
//       //onGenerateRoute: Routes.routes,
//       home: const MyScreen(),
//     );
//   }
// }

// class MyScreen extends StatelessWidget {
//   const MyScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
//       return BlocBuilder<MyUserCubit, MyUserState>(
//           builder: (context, myUserState) {
//         if (authState is AuthSignedIn) {
//           context.read<MyUserCubit>().validarNuevo();
//           if (myUserState is NewUserState) {
//             return const FormSignUp();
//           } else if (myUserState is MyUserReadyState) {
//             return const MyHomePage(title: 'PowerUp');
//           }
//           return const SplashScreen();
//         }
//         return const LoginScreen();
//       });
//     });
//   }
// }

// final Game game = DoodleDash();

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: Center(
//         child: LayoutBuilder(builder: (context, constraints) {
//           return Container(
//             constraints: const BoxConstraints(
//               maxWidth: 800,
//               minWidth: 550,
//             ),
//             child: GameWidget(
//               game: game,
//               overlayBuilderMap: <String, Widget Function(BuildContext, Game)>{
//                 'gameOverlay': (context, game) => GameOverlay(game),
//                 'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
//                 'gameOverOverlay': (context, game) => GameOverOverlay(game),
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
