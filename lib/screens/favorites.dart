import 'package:flutter/material.dart';
import 'package:meizi/utils/db.dart';
import 'package:meizi/model/model.dart';
import 'package:meizi/screens/meiziView.dart';

class Favorites extends StatefulWidget {
  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> with DbUtils {
  List<Meizi> filteredMeizis = List();
  List<Meizi> meiziCache = List();

  @override
  void initState() {
    filteredMeizis = [];
    meiziCache = [];
    setupList();
    super.initState();
  }

  void setupList() async {
    filteredMeizis = await getMeiziMen();
    setState(() {
      meiziCache = filteredMeizis;
    });
  }

  void onPressed(int index) {
    setState(() {
      filteredMeizis.remove(filteredMeizis[index]);
    });
    deleteMeizi(filteredMeizis[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredMeizis.length,
              itemBuilder: (BuildContext context, int index) {
                return new MeiziView(filteredMeizis[index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
