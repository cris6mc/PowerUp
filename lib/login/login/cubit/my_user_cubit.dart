import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user.dart';
import '../provider/my_user_repository.dart';

part 'my_user_state.dart';

class MyUserCubit extends Cubit<MyUserState> {
  final MyUserRepository _userRepository;
  MyUser _user = MyUser('', '', const ['']);

  MyUserCubit(this._userRepository) : super(MyUserLoadingState());

  void logOut() {
    emit(MyUserLoadingState());
  }

  void loading() {
    emit(MyUserLoadingState());
  }

  Future<void> validarNuevo() async {
    MyUser? user = await _userRepository.getMyUser();
    if (user == null) {
      emit(NewUserState());
    } else {
      emit(MyUserReadyState(user));
    }
  }

  Future<void> getMyUser() async {
    emit(MyUserLoadingState());
    _user = await _userRepository.getMyUser() ?? MyUser('', '', const ['']);
    emit(MyUserReadyState(_user));
  }

  // Future<void> saveMyuser(String uid, String name, String description, DateTime birthdate) async{
  //   _user = MyUser(uid, name, description, birthdate, image: _user.image);
  //   emit(MyUserReadyState(_user, _pickedImage, isSaving: true));
  //   await _userRepository.saveMyUser(_user, _pickedImage);
  //   emit(MyUserReadyState(_user, _pickedImage));
  // }

  Future<void> saveMyuser(String uid, String name, List? kids) async {
    _user = MyUser(uid, name, kids);
    await _userRepository.saveMyUser(_user);
    emit(MyUserReadyState(_user));
  }

  Future<void> updateMyUser(List kids) async {
    await _userRepository.updateMyUser(kids);
  }
}
