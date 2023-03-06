import 'package:json_annotation/json_annotation.dart';
part 'login_payload.g.dart';

@JsonSerializable()
class LoginPayload {
  final String username;
  final String password;

  LoginPayload({required this.username, required this.password});

  Map<String, dynamic> toJson() => _$LoginPayloadToJson(this);
}
