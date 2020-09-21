import 'package:cloud_firestore/cloud_firestore.dart';

class Categories {
  String categoryName;
  String categoryDescription;
  bool isSelected;
  String categoryDocumentId;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  Categories({
    this.categoryName,
    this.categoryDescription,
    this.categoryDocumentId,
  });

  Categories copyWith({
    String categoryName,
    String categoryDescription,
    String categoryDocumentId,
  }) {
    return new Categories(
      categoryName: categoryName ?? this.categoryName,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      categoryDocumentId: categoryDocumentId ?? this.categoryDocumentId,
    );
  }

  @override
  String toString() {
    return 'Categories{categoryName: $categoryName, categoryDescription: $categoryDescription, categoryDocumentId: $categoryDocumentId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categories &&
          runtimeType == other.runtimeType &&
          categoryName == other.categoryName &&
          categoryDescription == other.categoryDescription &&
          categoryDocumentId == other.categoryDocumentId);

  @override
  int get hashCode =>
      categoryName.hashCode ^
      categoryDescription.hashCode ^
      categoryDocumentId.hashCode;

  factory Categories.fromMap(Map<String, dynamic> map) {
    return new Categories(
      categoryName: map['categoryName'] as String,
      categoryDescription: map['categoryDescription'] as String,
      categoryDocumentId: map['categoryDocumentId'] as String,
    );
  }

  factory Categories.fromDocument(DocumentSnapshot document) {
    return new Categories(
      categoryName: document['categoryName'] as String,
      categoryDescription: document['categoryDescription'] as String,
      categoryDocumentId: document.documentID,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'categoryName': this.categoryName,
      'categoryDescription': this.categoryDescription,
      'categoryDocumentId': this.categoryDocumentId,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}