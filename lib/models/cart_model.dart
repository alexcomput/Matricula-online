import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/data/cart_data.dart';
import 'package:online/data/product_data.dart';
import 'package:online/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user) {
    if (user.isLoggedIn()) _loadCartItems();
  }

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //Metodo estático para chamar o cart
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  CollectionReference getInstanceFirebaseCard() {
    return Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart");
  }

  CollectionReference getInstanceFirebaseOrders() {
    return Firestore.instance.collection("orders");
  }

  void addCardItem(CartProduct cartProduct) {
    products.add(cartProduct);
    this.getInstanceFirebaseCard().add(cartProduct.topMap()).then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCardItem(CartProduct cartProduct) {
    this.getInstanceFirebaseCard().document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    this
        .getInstanceFirebaseCard()
        .document(cartProduct.cid)
        .updateData(cartProduct.topMap());
    notifyListeners();
  }

  void inProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    this
        .getInstanceFirebaseCard()
        .document(cartProduct.cid)
        .updateData(cartProduct.topMap());
    notifyListeners();
  }

  void setCoupon(String couponcode, int discountPercent) {
    this.couponCode = couponcode;
    this.discountPercentage = discountPercent;
  }

  void upddatePrices() {
    notifyListeners();
  }

  double getProductPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }

    return price;
  }

  double getDiscount() {
    return getProductPrice() * discountPercentage / 100;
  }

  Future<String> finishOrrder() async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    DocumentReference refOrder = await this.getInstanceFirebaseOrders().add({
      "clientId": user.firebaseUser.uid,
      "products":
          products.map((cartProduct) => cartProduct.topMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
    });

    //Salvando a ordem para o usuário
    await Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("orders")
        .document(refOrder.documentID)
        .setData({"orderId": refOrder.documentID});

    //Remover todos os produtos do carirnho no firabase
    QuerySnapshot query = await this.getInstanceFirebaseCard().getDocuments();
    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }

    //Limpar a lista local
    products.clear();

    discountPercentage = 0;
    couponCode = null;

    isLoading = false;

    notifyListeners();

    return refOrder.documentID;
  }

  double getShipPrice() {
    return 9.99;
  }

  void _loadCartItems() async {
    QuerySnapshot querySnapshot =
        await this.getInstanceFirebaseCard().getDocuments();

    this.products = querySnapshot.documents
        .map((doc) => CartProduct.fromDocument(doc))
        .toList();
    notifyListeners();
  }
}
