import 'package:json_annotation/json_annotation.dart';

part 'trail.g.dart';

@JsonSerializable()
class Trail {
  Trail(this.codeName, this.username, this.feedback, this.comment);

  String codeName;
  String username;
  int feedback;
  String comment;

  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);

  Map<String, dynamic> toJson() => _$TrailToJson(this);
}
