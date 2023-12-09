// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final bool isAuthenticated;
  bool? isManager;
  bool? isCoopView;
  List<String>? coopsManaged = [];
  List<String>? coopsJoined = [];
  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isAuthenticated,
    this.isManager,
    this.isCoopView,
    this.coopsManaged,
    this.coopsJoined,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? profilePic,
    bool? isAuthenticated,
    bool? isManager,
    bool? isCoopView,
    List<String>? coopsManaged,
    List<String>? coopsJoined,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isManager: isManager ?? this.isManager,
      isCoopView: isCoopView ?? this.isCoopView,
      coopsManaged: coopsManaged ?? this.coopsManaged,
      coopsJoined: coopsJoined ?? this.coopsJoined,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'isAuthenticated': isAuthenticated,
      'isManager': isManager,
      'isCoopView': isCoopView,
      'coopsManaged': coopsManaged,
      'coopsJoined': coopsJoined,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      isManager: map['isManager'] != null ? map['isManager'] as bool : null,
      isCoopView: map['isCoopView'] != null ? map['isCoopView'] as bool : null,
      coopsManaged: map['coopsManaged'] != null
          ? List<String>.from((map['coopsManaged'] as List<dynamic>))
          : null,
      coopsJoined: map['coopsJoined'] != null
          ? List<String>.from((map['coopsJoined'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, profilePic: $profilePic, isAuthenticated: $isAuthenticated, isManager: $isManager, isCoopView: $isCoopView, coopsManaged: $coopsManaged, coopsJoined: $coopsJoined)';
  }
}
