import 'package:flutter/material.dart';
import 'package:online/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.book,
        color: Colors.white,
      ),
      onPressed: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartSreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
