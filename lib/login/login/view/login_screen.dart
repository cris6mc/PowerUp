import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jueguito2/login/kid/view/list_kids.dart';
import '../../login/cubit/auth_cubit.dart';
import '../cubit/my_user_cubit.dart';
import 'form_sign_up.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, authState) {
      return BlocBuilder<MyUserCubit, MyUserState>(
          builder: (context, myUserState) {
        if (authState is AuthSignedIn) {
          // if (myUserState is MyUserReadyState) {
          //   return const MainScreen();
          // }
          return const MainScreen();
        }
        return const LoginScreen();
      });
    });
  }
}

class LoginScreen extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const LoginScreen();
  }

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Log In'),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(builder: (_, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese una contraseña';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await context
                                  .read<AuthCubit>()
                                  .signInWithEmailAndPassword(
                                    email!,
                                    password!,
                                  );
                            }
                          },
                          child: const Text('Ingresar'),
                        ),
                        const SizedBox(height: 20),
                        if (state is AuthSigningIn) ...[
                          const CircularProgressIndicator(),
                        ],
                        if (state is AuthError) ...[
                          const Text(
                            // state.message,
                            'Hubo un error de autentificacion',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FormSignUp()));
                    },
                    child: const Text('Crear nueva cuenta'),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
