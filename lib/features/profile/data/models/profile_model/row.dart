class Row {
  int? id;
  String? fullName;
  String? nationalityId;
  String? email;
  String? phoneNumber;
  dynamic dayOfBirth;
  String? gender;
  dynamic location;
  dynamic zoneId;
  dynamic profileImageUrl;

  Row({
    this.id,
    this.fullName,
    this.nationalityId,
    this.email,
    this.phoneNumber,
    this.dayOfBirth,
    this.gender,
    this.location,
    this.zoneId,
    this.profileImageUrl,
  });

  factory Row.fromJson(Map<String, dynamic> json) => Row(
        id: json['id'] as int?,
        fullName: json['full_name'] as String?,
        nationalityId: json['nationality_id'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phone_number'] as String?,
        dayOfBirth: json['day_of_birth'] as dynamic,
        gender: json['gender'] as String?,
        location: json['location'] as dynamic,
        zoneId: json['zone_id'] as dynamic,
        profileImageUrl: json['profile_image_url'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'nationality_id': nationalityId,
        'email': email,
        'phone_number': phoneNumber,
        'day_of_birth': dayOfBirth,
        'gender': gender,
        'location': location,
        'zone_id': zoneId,
        'profile_image_url': profileImageUrl,
      };
}
