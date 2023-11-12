import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String email;
  final String profilePicture;
  final String uid;
  final bool isAuthenticated;
  final List<String> marketAdverts;
  final List<String> serviceAdverts;
  final List<String> likedMarketAdverts;
  final List<String> likedServiceAdverts;
  final String dfAddress;
  final String dfContact;
  final String status;
  UserModel({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.uid,
    required this.isAuthenticated,
    required this.marketAdverts,
    required this.serviceAdverts,
    required this.likedMarketAdverts,
    required this.likedServiceAdverts,
    required this.dfAddress,
    required this.dfContact,
    required this.status,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePicture,
    String? uid,
    bool? isAuthenticated,
    List<String>? marketAdverts,
    List<String>? serviceAdverts,
    List<String>? likedMarketAdverts,
    List<String>? likedServiceAdverts,
    String? dfAddress,
    String? dfContact,
    String? status,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      marketAdverts: marketAdverts ?? this.marketAdverts,
      serviceAdverts: serviceAdverts ?? this.serviceAdverts,
      likedMarketAdverts: likedMarketAdverts ?? this.likedMarketAdverts,
      likedServiceAdverts: likedServiceAdverts ?? this.likedServiceAdverts,
      dfAddress: dfAddress ?? this.dfAddress,
      dfContact: dfContact ?? this.dfContact,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'marketAdverts': marketAdverts,
      'serviceAdverts': serviceAdverts,
      'likedMarketAdverts': likedMarketAdverts,
      'likedServiceAdverts': likedServiceAdverts,
      'dfAddress': dfAddress,
      'dfContact': dfContact,
      'status': status,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      profilePicture: map['profilePicture'] as String,
      uid: map['uid'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
      marketAdverts: List<String>.from(map['marketAdverts']),
      serviceAdverts: List<String>.from(map['serviceAdverts']),
      likedMarketAdverts: List<String>.from(map['likedMarketAdverts']),
      likedServiceAdverts: List<String>.from(map['likedServiceAdverts']),
      dfAddress: map['dfAddress'] as String,
      dfContact: map['dfContact'] as String,
      status: map['status'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, profilePicture: $profilePicture, uid: $uid, isAuthenticated: $isAuthenticated, marketAdverts: $marketAdverts, serviceAdverts: $serviceAdverts, likedMarketAdverts: $likedMarketAdverts, likedServiceAdverts: $likedServiceAdverts, dfAddress: $dfAddress, dfContact: $dfContact, status: $status)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.profilePicture == profilePicture &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        listEquals(other.marketAdverts, marketAdverts) &&
        listEquals(other.serviceAdverts, serviceAdverts) &&
        listEquals(other.likedMarketAdverts, likedMarketAdverts) &&
        listEquals(other.likedServiceAdverts, likedServiceAdverts) &&
        other.dfAddress == dfAddress &&
        other.dfContact == dfContact &&
        other.status == status;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        profilePicture.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        marketAdverts.hashCode ^
        serviceAdverts.hashCode ^
        likedMarketAdverts.hashCode ^
        likedServiceAdverts.hashCode ^
        dfAddress.hashCode ^
        dfContact.hashCode ^
        status.hashCode;
  }
}
