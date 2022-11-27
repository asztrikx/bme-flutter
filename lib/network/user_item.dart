import 'package:equatable/equatable.dart';

class UserItem extends Equatable {
  final String name;
  final String avatarUrl;

  const UserItem(this.name, this.avatarUrl);

  UserItem.fromJson(Map<String, dynamic> json): this(json["name"], json["avatarUrl"]);

  @override
  List<Object?> get props => [name, avatarUrl];
}