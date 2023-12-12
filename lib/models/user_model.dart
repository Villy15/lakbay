import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String uid,
    required String name,
    required String profilePic,
    required bool isAuthenticated,
    bool? isManager,
    bool? isCoopView,
    List<String>? coopsManaged,
    List<String>? coopsJoined,
    String? currentCoop,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
