import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? phoneNumber;
  final String? displayName;
  final String? photoURL;
  final DateTime? createdAt;

  UserModel({
    this.uid,
    this.phoneNumber,
    this.displayName = "",
    this.photoURL = "",
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!) // ← DateTime → Timestamp convert
          : Timestamp.now(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
