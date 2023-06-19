import '../model/user.dart';
import 'firebase_provider.dart';

abstract class MyUserRepositoryBase {
  Future<MyUser?> getMyUser();

  Future<void> saveMyUser(MyUser user);

  Future<void> updateMyUser(List kids);
}

class MyUserRepository extends MyUserRepositoryBase {
  final provider = FirebaseProvider();

  @override
  Future<MyUser?> getMyUser() => provider.getMyUser();

  @override
  Future<void> saveMyUser(MyUser user) => provider.saveMyUser(user);

  @override
  Future<void> updateMyUser(List kids) => provider.updateMyUser(kids);
}
