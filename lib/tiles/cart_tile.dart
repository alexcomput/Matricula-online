import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online/data/cart_data.dart';
import 'package:online/data/product_data.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  CollectionReference getInstanceProduct() {
    return Firestore.instance.collection("products");
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(cartProduct.productData.images[0],
              fit: BoxFit.cover,),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    cartProduct.productData.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${cartProduct.productData.price.toDouble()
                        .toStringAsFixed(2)}",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .primaryColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {},
                      ),
                      Text(
                          cartProduct.quantity.toString()
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {},
                      ),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed: (){},
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    }
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
          future: this.getInstanceProduct()
              .document(cartProduct.category)
              .collection("items")
              .document(cartProduct.pid).get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            } else {
              return Container(
                height: 70.0,
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            }
          },
        ) :
        _buildContent()
    );
  }
}
