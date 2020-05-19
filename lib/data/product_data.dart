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

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    print(snapshot);
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"];
    images = snapshot.data["images"];
    size = snapshot.data["size"];
  }

  Map<String, dynamic> toResumeMap() {
    return {
      "title": title,
      "description": this.description,
      "price": this.price
    };
  }
}
