// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../profile/cubit/my_user_cubit.dart';
// import '../login/login/cubit/auth_cubit.dart';

// class Screen404 extends StatefulWidget {
//   static Widget create(BuildContext context) {
//     return const Screen404();
//   }

//   const Screen404({super.key});

//   @override
//   State<Screen404> createState() => _Screen404State();
// }

// class _Screen404State extends State<Screen404> {
//   TextEditingController mensaje = TextEditingController(text: '');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('No se encontro la pagina')),
//       body: Center(
//           child: ElevatedButton(
//         onPressed: () {
//           context.read<AuthCubit>().signOut();
//           context.read<MyUserCubit>().logOut();
//         },
//         child: const Text('Log out'),
//       )),
//     );
//   }
// }
