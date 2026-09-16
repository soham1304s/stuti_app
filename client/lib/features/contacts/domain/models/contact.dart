class Contact {
  final String id;
  final String name;
  final String phone;
  final String publicKey;
  final String fingerprint;
  final String? avatarUrl;
  final bool isNearby;
  final bool isOnline;
  final bool isVerified;
  final String? approximateDistance;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    required this.publicKey,
    required this.fingerprint,
    this.avatarUrl,
    this.isNearby = false,
    this.isOnline = true,
    this.isVerified = true,
    this.approximateDistance,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'publicKey': publicKey,
        'fingerprint': fingerprint,
        'avatarUrl': avatarUrl,
        'isNearby': isNearby,
        'isOnline': isOnline,
        'isVerified': isVerified,
        'approximateDistance': approximateDistance,
      };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      publicKey: json['publicKey'] as String,
      fingerprint: json['fingerprint'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isNearby: json['isNearby'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? true,
      approximateDistance: json['approximateDistance'] as String?,
    );
  }
}
