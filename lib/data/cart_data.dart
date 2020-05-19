import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online/data/product_data.dart';

class CartProduct {
  String cid;
  String category;
  String pid;

  int quantity;
  String size;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  Map<String, dynamic> topMap() {
    return {
      "category": this.category,
      "pid": this.pid,
      "quantity": this.quantity,
      "size": this.size,
      "product": productData.toResumedMap(),
    };
  }
}
