import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class bundles {
  final String btext;
  final String bimg;
  final String bprice;
  final String bdocumentId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  const bundles({
    this.btext,
    this.bimg,
    this.bprice,
    this.bdocumentId,
  });

  @override
  String toString() {
    return 'bundles{btext: $btext, bimg: $bimg, bprice: $bprice, bdocumentId: $bdocumentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is bundles &&
              runtimeType == other.runtimeType &&
              btext == other.btext &&
              bimg == other.bimg &&
              bprice == other.bprice &&
              bdocumentId == other.bdocumentId);

  @override
  int get hashCode =>
      btext.hashCode ^ bimg.hashCode ^ bprice.hashCode ^ bdocumentId.hashCode;

  factory bundles.fromMaps(Map<String, dynamic> map) {
    return new bundles(
      btext: map['btext'] as String,
      bimg: map['bimg'] as String,
      bprice: map['bprice'] as String,
    );
  }

  factory bundles.fromDocuments(DocumentSnapshot document) {
    return new bundles(
      btext: document['btext'] as String,
      bimg: document['bimg'] as String,
      bprice: document['bprice'] as String,
      bdocumentId: document.documentID,
    );
  }

  Map<String, dynamic> toMaps() {
    // ignore: unnecessary_cast
    return {
      'btext': this.btext,
      'bimg': this.bimg,
      'bprice': this.bprice,
      'bdocumentId': this.bdocumentId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}






























