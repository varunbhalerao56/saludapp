import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'product.dart';

class Order {
  final String orderId;
  final String itemsOrdered;
  final String orderDate;

  Order(this.orderId, this.itemsOrdered, this.orderDate);

  Map<String, dynamic> toMap() => {
        "orderId": this.orderId,
        "orderDate": this.orderDate,
        "itemsOrdered": this.itemsOrdered
      };

  Order.fromMap(Map<dynamic, dynamic> map)
      : orderId = map["reps"],
        itemsOrdered = map["itemsOrdered"],
        orderDate = map["orderDate"];
}

class User extends Model {
  final String displayName;
  final String email;
  final String address;
  final String id;
  final String seller;
  final String stripeId;
  List<Products> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;
  List<dynamic> orders = [];

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  User({
    this.displayName,
    this.email,
    this.address,
    this.id,
    this.seller,
    this.stripeId,
    List<Products> cart,
    double totalCartValue,
    orders,
  });

  @override
  String toString() {
    return 'User{displayName: $displayName, email: $email, address: $address, id: $id, seller: $seller,stripeId:$stripeId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName &&
          email == other.email &&
          address == other.address &&
          id == other.id &&
          seller == other.seller &&
          stripeId == other.stripeId);

  @override
  int get hashCode =>
      displayName.hashCode ^
      email.hashCode ^
      address.hashCode ^
      id.hashCode ^
      seller.hashCode ^
      stripeId.hashCode;

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'displayName': this.displayName,
      'email': this.email,
      'address': this.address,
      'id': this.id,
      'seller': this.seller,
      'stripeId': this.stripeId,
      'orders': this.orders
    } as Map<String, dynamic>;
  }

  factory User.fromDocument(DocumentSnapshot document) {
    return new User(
      displayName: document.data['displayName'] as String,
      email: document.data['email'] as String,
      address: document.data['address'] as String,
      id: document.documentID,
      stripeId: document['stripeId'] as String,
      seller: document['seller'] as String,
    );
  }

  User.fromMap(Map<String, dynamic> map)
      : displayName = map['displayName'] as String,
        email = map['email'] as String,
        address = map['address'] as String,
        id = map['id'] as String,
        seller = map['seller'] as String,
        stripeId = map['stripeId'] as String,
        cart = map['cart'] as List<Products>,
        orders = map['orders'].map((order) {
          return Order.fromMap(order);
        }).toList(),
        totalCartValue = map['totalCartValue'] as double;

  void ReadNestedData1() {
    User user;
    Firestore.instance
        .collection("user")
        .document(id)
        .get()
        .then((docSnapshot) => {
              user = User.fromMap(docSnapshot.data),
              user.orders.forEach((order) {
                Order orderInst = order as Order;

                print("Order :" + orderInst.itemsOrdered.toString());
              })
            });
  }

  void ReadNestedData() {
    Firestore.instance.collection("user").document(id).get().then(
        (docSnapshot) => {
              print("Orders: " +
                  docSnapshot.data["orders"][0]["itemsOrdered"].toString())
            });
  }

  void AddObjectToArray(String name) {
    Order order = Order('1awdasascdwqsssss', name, 'sss');
    Firestore.instance.collection("user").document(id).updateData({
      "orders": FieldValue.arrayUnion([order.toMap()])
    });
  }

  void addProduct(product) {
    int index = cart.indexWhere((i) => i.productName == product.productName);
    print(index);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void removeProduct(product) {
    int index = cart.indexWhere((i) => i.productName == product.productName);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.productName == product.productName);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.productName == product.productName);
    cart[index].qty = qty;
    if (cart[index].qty == 0) removeProduct(product);

    calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart = [];
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue +=
          double.parse((f.productPrice * f.qty).toStringAsFixed(2));
    });
  }

  Future<void> currentUserChatroomOrderStatus(
      String orderId, String status, String id) async {
    DocumentReference docRef =
        Firestore.instance.collection("user").document(id);

    DocumentSnapshot docSnapshot = await docRef.get();
    Map<String, dynamic> docData = docSnapshot.data;

    List<Map<String, dynamic>> userOrder = (docData["orders"] as List<dynamic>)
        .map((order) => Map<String, dynamic>.from(order))
        .toList();

    for (int index = 0; index < userOrder.length; index++) {
      Map<String, dynamic> order = userOrder[index];
      if (order["orderId"] == orderId) {
        order["itemsOrdered"] = status;
      }
      break;
    }

    await docRef.updateData({"orders": userOrder});
  }

//</editor-fold>

}
