import 'package:json_annotation/json_annotation.dart';
part 'success_payload.g.dart';

@JsonSerializable()
class SuccessPayload {
  final String success;

  SuccessPayload({required this.success});

  Map<String, dynamic> toJson() => _$SuccessPayloadToJson(this);

  factory SuccessPayload.fromJson(Map<String, dynamic> json) =>
      _$SuccessPayloadFromJson(json);
}
