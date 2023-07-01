// import 'package:flutter/material.dart';

// import '../../login/login/view/login_screen.dart';
// import '../../login/sign_up/view/form_sign_up.dart';
// import '../../other screens/screen404.dart';
// import '../../other screens/splash_screen.dart';

// class Routes {
//   static const splash = '/splash';
//   static const login = '/login';
//   static const home = '/home';
//   // static const add = '/add';
//   // static const settings = '/settings';
//   //static const message = '/message';
//   static const signUp = '/signUp';

//   static Route routes(RouteSettings routeSettings) {
//     switch (routeSettings.name) {
//       case splash:
//         return _buildRoute(SplashScreen.create);
//       case login:
//         return _buildRoute(LoginScreen.create);
//       // case add:
//       //   return _buildRoute(AddScreen.create);
//       // case home:
//       //   return _buildRoute(HomeScreen.create);
//       // case settings:
//       //   return _buildRoute(SettingsScreen.create);
//       case signUp:
//         return _buildRoute(FormSignUp.create);
//       default:
//         return _buildRoute(Screen404.create);
//     }
//   }

//   static MaterialPageRoute _buildRoute(Function build) =>
//       MaterialPageRoute(builder: (context) => build(context));
// }
