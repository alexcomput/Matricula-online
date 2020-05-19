import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserModel extends Model {
  bool isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  } // Retorna a document do User do Firecebase

  DocumentReference getInstance() {
    return Firestore.instance.collection("users").document(firebaseUser.uid);
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((user) async {
      firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    this.isLoading = true;
    notifyListeners();
    await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((result) async {
      firebaseUser = result.user;
      await _loadCurrentUser();

      onSuccess();
      this.isLoading = false;

      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await getInstance().setData(userData).then((reto) {
      print("Cadastro Realizado com sucesso!");
    }).catchError((error) {
      print(error.toString());
    });
  }

  void recovePass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  void recoverPass() {}

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await getInstance().get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
