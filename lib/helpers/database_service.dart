import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saludsingapore/models/export_models.dart';


Stream<List<Cart>> userCartCollection(
    CollectionReference productCollection) {
  return productCollection.snapshots().map((snapshot) {
    return snapshot.documents
        .map((doc) => Cart.fromDocument(doc))
        .toList();
  });
}

CollectionReference cartCollection(String userID) {
  return Firestore.instance.collection('user/$userID/cart');
}


Stream<User> userData(String uid) {
  return Firestore.instance.document('user/$uid').snapshots().map((doc) {
    return User.fromDocument(doc);
  });
}



class ProductCollection  {
  CollectionReference collection  =   Firestore.instance.collection('products');
}