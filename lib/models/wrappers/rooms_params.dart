import 'package:freezed_annotation/freezed_annotation.dart';

part 'rooms_params.freezed.dart';
part 'rooms_params.g.dart';

@freezed
class RoomsParams with _$RoomsParams {
  factory RoomsParams({
    required List<String> unavailableRoomUids,
    required num guests,
  }) = _RoomsParams;

  factory RoomsParams.fromJson(Map<String, dynamic> json) =>
      _$RoomsParamsFromJson(json);
}
