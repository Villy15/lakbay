import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lakbay/core/util/utils.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  factory UserModel(
      {required String uid,
      required String name,
      required String profilePic,
      String? phoneNo,
      String? email,
      String? address,
      String? emergencyContact,
      String? emergencyContactName,
      required bool isAuthenticated,
      String? imageUrl,
      String? firstName,
      String? lastName,
      bool? isCoopView,
      List<CooperativesJoined>? cooperativesJoined,
      String? currentCoop,
      String? validIdUrl,
      String? birthCertificateUrl,
      List<UserReviews>? reviews,
      String? middleName,
      @TimestampSerializer() DateTime? birthDate,
      num? age,
      String? gender,
      String? religion,
      String? nationality,
      String? civilStatus,
      @TimestampSerializer() DateTime? createdAt}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Check if user is a manager
  bool get isManager {
    return cooperativesJoined?.any((coop) => coop.role == 'Manager') ?? false;
  }

  bool get isAdmin {
    // Check if email is adminlakbay@gmail.com
    return email == 'adminlakbay@gmail.com';
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

@freezed
class UserReviews with _$UserReviews {
  factory UserReviews({
    required String userId,
    required String reviewerId,
    required String listingId,
    @TimestampSerializer() DateTime? createdAt,
    required String review,
  }) = _UserReviews;

  factory UserReviews.fromJson(Map<String, dynamic> json) =>
      _$UserReviewsFromJson(json);
}
