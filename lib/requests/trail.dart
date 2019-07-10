import 'package:json_annotation/json_annotation.dart';

part 'trail.g.dart';

@JsonSerializable()
class Trail {
  Trail(this.codeName, this.username, this.feedback, this.comment,
      this.timeToComplete, this.tokenID);

  String codeName;
  String username;
  int feedback;
  String comment;
  int timeToComplete;
  String tokenID;

  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);

  Map<String, dynamic> toJson() => _$TrailToJson(this);
}
