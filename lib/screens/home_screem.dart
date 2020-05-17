import 'package:flutter/material.dart';
import 'package:online/tabs/home_tabs.dart';
import 'package:online/tabs/products_tab.dart';
import 'package:online/widgets/custom_drawer.dart';

class HomeScreem extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Scaffold(
            body: HomeTab(),
            drawer: CustomDrawer(_pageController),
          ),
          Scaffold(
            appBar: AppBar(
              title: Text("Matrícula-se"),
              centerTitle: true,
            ),
            drawer: CustomDrawer(_pageController),
            body: ProductsTab(),
          ),
        ]);
  }
}