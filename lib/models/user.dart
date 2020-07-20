import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String address;
  final String id;
  final String seller;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const User({
    this.name,
    this.email,
    this.address,
    this.id,
    this.seller,
  });



  @override
  String toString() {
    return 'User{name: $name, email: $email, address: $address, id: $id, seller: $seller}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is User &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              email == other.email &&
              address == other.address &&
              id == other.id &&
              seller == other.seller);

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      address.hashCode ^
      id.hashCode ^
      seller.hashCode;

  factory User.fromDocument(DocumentSnapshot document) {
    return new User(
      name: document.data['name'] as String,
      email: document.data['email'] as String,
      address: document.data['address'] as String,
      id: document.documentID,
      seller: document['seller'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'name': this.name,
      'email': this.email,
      'address': this.address,
      'id': this.id,
      'seller': this.seller,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
