import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MyUser extends Equatable {
  String id;
  String name;
  List? kids;

  MyUser(this.id, this.name, this.kids);

  @override
  List<Object?> get props => [id];

  Map<String, Object?> toFirebaseMap(
      {String? newImage, String? newAdministrativeArea}) {
    return <String, Object?>{
      'id': id,
      'name': name,
      'kids': kids,
    };
  }

  MyUser.fromFirebaseMap(Map<String, Object?> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        kids = data['kids'] as List?;
}
