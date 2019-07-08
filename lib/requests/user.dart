import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User(
      this.username, this.email, this.password, this.tokenID, this.sessionTime);

  String username;
  String email;
  String password;
  String tokenID;
  int sessionTime;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
