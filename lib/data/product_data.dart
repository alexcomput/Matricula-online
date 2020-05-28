import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online/data/cart_data.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;

  double price;

  List images;
  List size;

  ProductData.fromDocument(DocumentSnapshot document) {

    id = document.documentID;
    title = document.data["title"];
    description = document.data["description"];
    price = document.data["price"];
    images = document.data["images"];
    size = document.data["size"];
  }

  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": this.description,
      "price": this.price
    };
  }
}
