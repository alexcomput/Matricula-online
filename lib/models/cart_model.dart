import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/data/cart_data.dart';
import 'package:online/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  UserModel user;

  List<CartProduct> products = [];

  CartModel(this.user);

  bool isLoading = false;

  //Metodo estático para chamar o cart
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  CollectionReference getInstanceFirebase() {
    return Firestore.instance
        .collection("users")
        .document(user.firebaseUser.uid)
        .collection("cart");
  }

  void addCardItem(CartProduct cartProduct) {
    products.add(cartProduct);
    this.getInstanceFirebase().add(cartProduct.topMap()).then((doc) {
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCardItem(CartProduct cartProduct) {
    this.getInstanceFirebase().document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();
  }
}
