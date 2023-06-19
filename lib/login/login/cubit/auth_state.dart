part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthSignedOut extends AuthState {}

class AuthSigningIn extends AuthState {}

class SignedUp extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSignedIn extends AuthState {
  final AuthUser user;

  AuthSignedIn(this.user);

  @override
  List<Object?> get props => [user];
}
