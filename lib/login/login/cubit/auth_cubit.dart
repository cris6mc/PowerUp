import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/provider/auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryBase _authRepository;
  late StreamSubscription _authSubscription;

  AuthCubit(this._authRepository) : super(AuthInitialState());

  Future<void> init() async {
    _authSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
  }

  Future<void> reset() async => emit(AuthInitialState());

  void _authStateChanged(AuthUser? user) =>
      user == null ? emit(AuthSignedOut()) : emit(AuthSignedIn(user));

  // Future<void> signInWithGoogle() => signIn(_authRepository.signInWithGoogle());

  Future<void> signInAnonymously() =>
      signIn(_authRepository.signInAnonymously());

  Future<void> createUserWithEmailAndPassword(String email, String password) =>
      signIn(_authRepository.createUserWithEmailAndPassword(email, password));

  Future<void> signInWithEmailAndPassword(String email, String password) =>
      signIn(_authRepository.signInWithEmailAndPassword(email, password));

  Future<void> signIn(Future<AuthUser?> auxUser) async {
    try {
      emit(AuthSigningIn());
      final user = await auxUser;
      if (user == null) {
        emit(AuthError('Unknown error, try again later'));
      } else {
        emit(AuthSignedIn(user));
      }
    } catch (e) {
      emit(AuthError('Error: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(AuthSignedOut());
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
