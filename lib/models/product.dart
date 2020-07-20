import 'package:cloud_firestore/cloud_firestore.dart';

class Products {

  final String text;
  final String img;
  final String price;
  final String documentId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const Products({
    this.text,
    this.img,
    this.price,
    this.documentId,
  });


  @override
  String toString() {
    return 'Products{text: $text, img: $img, price: $price, documentId: $documentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is Products &&
              runtimeType == other.runtimeType &&
              text == other.text &&
              img == other.img &&
              price == other.price &&
              documentId == other.documentId);

  @override
  int get hashCode =>
      text.hashCode ^ img.hashCode ^ price.hashCode ^ documentId.hashCode;

  factory Products.fromMap(Map<String, dynamic> map) {
    return new Products(
      text: map['text'] as String,
      img: map['img'] as String,
      price: map['price'] as String,
    );
  }

  factory Products.fromDocument(DocumentSnapshot document) {
    return new Products(
      text: document['text'] as String,
      img: document['img'] as String,
      price: document['price'] as String,
      documentId: document.documentID,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'text': this.text,
      'img': this.img,
      'price': this.price,
      'documentId': this.documentId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
