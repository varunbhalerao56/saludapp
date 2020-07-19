import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class products {

  final String text;
  final String img;
  final String price;
  final String documentId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const products({
    this.text,
    this.img,
    this.price,
    this.documentId,
  });


  @override
  String toString() {
    return 'products{text: $text, img: $img, price: $price, documentId: $documentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is products &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          img == other.img &&
          price == other.price &&
          documentId == other.documentId);

  @override
  int get hashCode =>
      text.hashCode ^ img.hashCode ^ price.hashCode ^ documentId.hashCode;

  factory products.fromMap(Map<String, dynamic> map) {
    return new products(
      text: map['text'] as String,
      img: map['img'] as String,
      price: map['price'] as String,
    );
  }

  factory products.fromDocument(DocumentSnapshot document) {
    return new products(
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
