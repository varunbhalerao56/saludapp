import 'package:cloud_firestore/cloud_firestore.dart';

class Choice {
  int amount;
  List<String> choice;

  //<editor-fold desc="Data Methods" defaultstate="collapsed">

  Choice({
    this.amount,
    this.choice,
  });

  factory Choice.fromMap(Map<String, dynamic> map) {
    return new Choice(
      amount: map['amount'] as int,
      choice: map['choice'] as List<String>,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'amount': this.amount,
      'choice': this.choice,
    } as Map<String, dynamic>;
  }

//</editor-fold>
}

class Products {
  String productType;
  String isBundle;
  String productName;
  String productImg;
  String documentId;
  String productDescription;
  double productPrice;
  String category;
  int qty;
  List<String> bundleItems;
  Choice choice1;
  Choice choice2;
  Choice choice3;

  //<editor-fold desc="Data Methods" defaultstate="collapsed">

  Products({
    this.productType,
    this.isBundle,
    this.productName,
    this.productImg,
    this.documentId,
    this.productDescription,
    this.productPrice,
    this.category,
    this.qty,
    this.bundleItems,
    this.choice1,
    this.choice2,
    this.choice3,
  });

  Products copyWith({
    String productType,
    String isBundle,
    String productName,
    String productImg,
    String documentId,
    String productDescription,
    double productPrice,
    String category,
    int qty,
    List<String> bundleItems,
    Choice choice1,
    Choice choice2,
    Choice choice3,
  }) {
    return new Products(
      productType: productType ?? this.productType,
      isBundle: isBundle ?? this.isBundle,
      productName: productName ?? this.productName,
      productImg: productImg ?? this.productImg,
      documentId: documentId ?? this.documentId,
      productDescription: productDescription ?? this.productDescription,
      productPrice: productPrice ?? this.productPrice,
      category: category ?? this.category,
      qty: qty ?? this.qty,
      bundleItems: bundleItems ?? this.bundleItems,
      choice1: choice1 ?? this.choice1,
      choice2: choice2 ?? this.choice2,
      choice3: choice3 ?? this.choice3,
    );
  }

  @override
  String toString() {
    return 'Products{productType: $productType, isBundle: $isBundle, productName: $productName, productImg: $productImg, documentId: $documentId, productDescription: $productDescription, productPrice: $productPrice, category: $category, qty: $qty, bundleItems: $bundleItems, choice1: $choice1, choice2: $choice2, choice3: $choice3}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Products &&
          runtimeType == other.runtimeType &&
          productType == other.productType &&
          isBundle == other.isBundle &&
          productName == other.productName &&
          productImg == other.productImg &&
          documentId == other.documentId &&
          productDescription == other.productDescription &&
          productPrice == other.productPrice &&
          category == other.category &&
          qty == other.qty &&
          bundleItems == other.bundleItems &&
          choice1 == other.choice1 &&
          choice2 == other.choice2 &&
          choice3 == other.choice3);

  @override
  int get hashCode =>
      productType.hashCode ^
      isBundle.hashCode ^
      productName.hashCode ^
      productImg.hashCode ^
      documentId.hashCode ^
      productDescription.hashCode ^
      productPrice.hashCode ^
      category.hashCode ^
      qty.hashCode ^
      bundleItems.hashCode ^
      choice1.hashCode ^
      choice2.hashCode ^
      choice3.hashCode;

  factory Products.fromMap(Map<String, dynamic> map) {
    return new Products(
      productType: map['productType'] as String,
      isBundle: map['isBundle'] as String,
      productName: map['productName'] as String,
      productImg: map['productImg'] as String,
      documentId: map['documentId'] as String,
      productDescription: map['productDescription'] as String,
      productPrice: map['productPrice'] as double,
      category: map['category'] as String,
      qty: map['qty'] as int,
      bundleItems: map['bundleItems'] as List<String>,
      choice1: map['choice1'] as Choice,
      choice2: map['choice2'] as Choice,
      choice3: map['choice3'] as Choice,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'productType': this.productType,
      'isBundle': this.isBundle,
      'productName': this.productName,
      'productImg': this.productImg,
      'documentId': this.documentId,
      'productDescription': this.productDescription,
      'productPrice': this.productPrice,
      'category': this.category,
      'qty': this.qty,
      'bundleItems': this.bundleItems,
      'choice1': this.choice1,
      'choice2': this.choice2,
      'choice3': this.choice3,
    } as Map<String, dynamic>;
  }

  factory Products.fromDocument(DocumentSnapshot document) {
    return new Products(
      productName: document['productName'] as String,
      productImg: document['productImg'] as String,
      documentId: document.documentID,
      productDescription: document['productDescription'] as String,
      productPrice: document['productPrice'] as double,
      qty: document['qty'] as int,
      bundleItems: document['bundleItems'] as List<String>,
      category: document['category'] as String,
      productType: document['productType'] as String,
      isBundle: document['isBundle'] as String,
      choice1: document['choice1'] as Choice,
      choice2: document['choice2'] as Choice,
      choice3: document['choice3'] as Choice,
    );
  }


//</editor-fold>


}



