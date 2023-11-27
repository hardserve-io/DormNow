import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String title;
  final String description;
  final double? price;
  final bool isFree;
  final String contacts;
  final String? address;
  final String? dorm;
  final int? floor;
  final String? room;
  final String authorUsername;
  final String authorUid;
  final DateTime createdAt;
  final List<String> pictures;
  Post({
    required this.id,
    required this.title,
    required this.description,
    this.price,
    required this.isFree,
    required this.contacts,
    this.address,
    this.dorm,
    this.floor,
    this.room,
    required this.authorUsername,
    required this.authorUid,
    required this.createdAt,
    required this.pictures,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    bool? isFree,
    String? contacts,
    String? address,
    String? dorm,
    int? floor,
    String? room,
    String? authorUsername,
    String? authorUid,
    DateTime? createdAt,
    List<String>? pictures,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      contacts: contacts ?? this.contacts,
      address: address ?? this.address,
      dorm: dorm ?? this.dorm,
      floor: floor ?? this.floor,
      room: room ?? this.room,
      authorUsername: authorUsername ?? this.authorUsername,
      authorUid: authorUid ?? this.authorUid,
      createdAt: createdAt ?? this.createdAt,
      pictures: pictures ?? this.pictures,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'isFree': isFree,
      'contacts': contacts,
      'address': address,
      'dorm': dorm,
      'floor': floor,
      'room': room,
      'authorUsername': authorUsername,
      'authorUid': authorUid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'pictures': pictures,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      price: map['price'] != null ? map['price'] as double : null,
      isFree: map['isFree'] as bool,
      contacts: map['contacts'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      dorm: map['dorm'] != null ? map['dorm'] as String : null,
      floor: map['floor'] != null ? map['floor'] as int : null,
      room: map['room'] != null ? map['room'] as String : null,
      authorUsername: map['authorUsername'] as String,
      authorUid: map['authorUid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      pictures: List<String>.from(map['pictures']),
    );
  }

  @override
  String toString() {
    return 'Post(id: $id, title: $title, description: $description, price: $price, isFree: $isFree, contacts: $contacts, address: $address, dorm: $dorm, floor: $floor, room: $room, authorUsername: $authorUsername, authorUid: $authorUid, createdAt: $createdAt, pictures: $pictures)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.isFree == isFree &&
        other.contacts == contacts &&
        other.address == address &&
        other.dorm == dorm &&
        other.floor == floor &&
        other.room == room &&
        other.authorUsername == authorUsername &&
        other.authorUid == authorUid &&
        other.createdAt == createdAt &&
        listEquals(other.pictures, pictures);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        isFree.hashCode ^
        contacts.hashCode ^
        address.hashCode ^
        dorm.hashCode ^
        floor.hashCode ^
        room.hashCode ^
        authorUsername.hashCode ^
        authorUid.hashCode ^
        createdAt.hashCode ^
        pictures.hashCode;
  }
}
