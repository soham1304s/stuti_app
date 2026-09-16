class UserIdentity {
  final String id;
  final String displayName;
  final String phone;
  final String publicKey;
  final String privateKey;
  final String fingerprint;
  final String bio;
  final DateTime createdAt;

  UserIdentity({
    required this.id,
    required this.displayName,
    required this.phone,
    required this.publicKey,
    required this.privateKey,
    required this.fingerprint,
    this.bio = 'MeshTalk off-grid node',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'phone': phone,
        'publicKey': publicKey,
        'privateKey': privateKey,
        'fingerprint': fingerprint,
        'bio': bio,
        'createdAt': createdAt.toIso8601String(),
      };

  factory UserIdentity.fromJson(Map<String, dynamic> json) {
    return UserIdentity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      phone: json['phone'] as String,
      publicKey: json['publicKey'] as String,
      privateKey: json['privateKey'] as String,
      fingerprint: json['fingerprint'] as String,
      bio: json['bio'] as String? ?? 'MeshTalk off-grid node',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
