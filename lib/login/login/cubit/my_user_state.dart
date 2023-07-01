part of 'my_user_cubit.dart';

abstract class MyUserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyUserLoadingState extends MyUserState {}

class MyUserReadyState extends MyUserState {
  final MyUser user;
  final bool isSaving;
  MyUserReadyState(this.user, {this.isSaving = false});
  @override
  List<Object?> get props => [user, isSaving];
}

class NewUserState extends MyUserState {}
