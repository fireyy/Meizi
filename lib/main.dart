import 'package:flutter/material.dart';
import 'package:meizi/screens/homePage.dart';
import 'package:meizi/screens/favorites.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Meizi",
        theme: ThemeData.dark(),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Meizi"),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.home),
                    text: 'Home Page',
                  ),
                  Tab(
                    icon: Icon(Icons.favorite),
                    text: "Favorites",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                HomePage(),
                Favorites(),
              ],
            ),
          ),
        ));
  }
}
