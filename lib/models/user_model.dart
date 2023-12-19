import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  factory UserModel({
    required String uid,
    required String name,
    required String profilePic,
    required bool isAuthenticated,
    bool? isCoopView,
    List<CooperativesJoined>? cooperativesJoined,
    String? currentCoop,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Check if user is a manager
  bool get isManager {
    return cooperativesJoined?.any((coop) => coop.role == 'Manager') ?? false;
  }

  // Get user's role
  String get role {
    return cooperativesJoined
            ?.firstWhere(
              (coop) => coop.cooperativeId == currentCoop,
              orElse: () => CooperativesJoined(
                cooperativeId: '',
                cooperativeName: '',
                role: 'Guest',
              ),
            )
            .role ??
        'Guest';
  }
}

@freezed
class CooperativesJoined with _$CooperativesJoined {
  factory CooperativesJoined({
    required String cooperativeId,
    required String cooperativeName,
    required String role,
  }) = _CooperativesJoined;

  factory CooperativesJoined.fromJson(Map<String, dynamic> json) =>
      _$CooperativesJoinedFromJson(json);
}
