class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isEmailVerified;
  final bool isAnonymous;
  final String? photoURL;
  final String? phoneNumber;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;
  // The provider data (e.g. Google, password, etc.)
  final List<Map<String, dynamic>>? providerData;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.isEmailVerified,
    required this.isAnonymous,
    this.photoURL,
    this.phoneNumber,
    this.creationTime,
    this.lastSignInTime,
    this.providerData,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    // user is assumed to be a FirebaseAuth User
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
      isAnonymous: user.isAnonymous,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
      creationTime: user.metadata?.creationTime,
      lastSignInTime: user.metadata?.lastSignInTime,
      providerData: user.providerData
          ?.map<Map<String, dynamic>>(
            (info) => {
              'displayName': info.displayName,
              'email': info.email,
              'phoneNumber': info.phoneNumber,
              'photoURL': info.photoURL,
              'providerId': info.providerId,
              'uid': info.uid,
            },
          )
          ?.toList(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      photoURL: json['photoURL'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      creationTime: json['creationTime'] != null
          ? DateTime.tryParse(json['creationTime'])
          : null,
      lastSignInTime: json['lastSignInTime'] != null
          ? DateTime.tryParse(json['lastSignInTime'])
          : null,
      providerData: (json['providerData'] as List<dynamic>?)
          ?.map((pd) => Map<String, dynamic>.from(pd))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'isEmailVerified': isEmailVerified,
      'isAnonymous': isAnonymous,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'creationTime': creationTime?.toIso8601String(),
      'lastSignInTime': lastSignInTime?.toIso8601String(),
      'providerData': providerData,
    };
  }
}
