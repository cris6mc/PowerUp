import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/my_user_cubit.dart';

class FormSignUp extends StatefulWidget {
  static Widget create(BuildContext context) {
    return const FormSignUp();
  }

  const FormSignUp({super.key});
  @override
  State<FormSignUp> createState() => _FormSignUpState();
}

class _FormSignUpState extends State<FormSignUp> {
  String? name;
  String? email;
  String? password;
  String? passwordConfirm;
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crear nueva cuenta'),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(builder: (_, state) {
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 20,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      // controller: _emailController,
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
                        } else if (value.length < 6) {
                          return 'Debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una contraseña';
                        }
                        if (value != password) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        passwordConfirm = value;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context
                              .read<AuthCubit>()
                              .createUserWithEmailAndPassword(
                                email!,
                                password!,
                              );
                          // ignore: use_build_context_synchronously
                          context.read<MyUserCubit>().saveMyuser(
                            // ignore: use_build_context_synchronously
                            (context.read<AuthCubit>().state as AuthSignedIn)
                                .user
                                .uid,
                            name ?? 'null',
                            [],
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Crear cuenta'),
                    ),
                    const SizedBox(height: 20),
                    if (state is AuthSigningIn) ...[
                      const CircularProgressIndicator(),
                    ],
                    if (state is AuthError) ...[
                      const Text(
                        // state.message,
                        'Hubo un error de registro, vuelve a intentarlo',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
