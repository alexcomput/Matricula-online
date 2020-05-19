import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:online/screens/login_screen.dart';

class LoginUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.view_list,
            size: 80.0,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "Faça o login para acompanhar",
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          RaisedButton(
            child: Text(
              "Entrar",
              style: TextStyle(fontSize: 18.0),
            ),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}
