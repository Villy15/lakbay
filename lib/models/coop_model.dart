class CooperativeModel {
  String? uid;
  final String name;
  String? description;
  String? address;
  final String city;
  final String province;
  final String imageUrl;
  final List<String> members;
  final List<String> managers;
  CooperativeModel({
    this.uid,
    required this.name,
    this.description,
    this.address,
    required this.city,
    required this.province,
    required this.imageUrl,
    required this.members,
    required this.managers,
  });

  CooperativeModel copyWith({
    String? uid,
    String? name,
    String? description,
    String? address,
    String? city,
    String? province,
    String? imageUrl,
    List<String>? members,
    List<String>? managers,
  }) {
    return CooperativeModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      imageUrl: imageUrl ?? this.imageUrl,
      members: members ?? this.members,
      managers: managers ?? this.managers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'description': description,
      'address': address,
      'city': city,
      'province': province,
      'imageUrl': imageUrl,
      'members': members,
      'managers': managers,
    };
  }

  factory CooperativeModel.fromMap(Map<String, dynamic> map) {
    return CooperativeModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      city: map['city'] as String,
      province: map['province'] as String,
      imageUrl: map['imageUrl'] as String,
      members: List<String>.from((map['members'] as List<dynamic>)),
      managers: List<String>.from((map['managers'] as List<dynamic>)),
    );
  }

  @override
  String toString() {
    return 'CooperativeModel(uid: $uid, name: $name, description: $description, address: $address, city: $city, province: $province, imageUrl: $imageUrl, members: $members, managers: $managers)';
  }
}
