import 'package:flutter/material.dart';
import 'package:meizi/utils/db.dart';
import 'package:meizi/model/model.dart';
import 'package:meizi/screens/meiziView.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      child: new GridView.count(
        crossAxisCount: 2,
        children: new List.generate(filteredMeizis.length, (index) {
          return new MeiziView(filteredMeizis[index]);
        }),
      ),
      // child: new StaggeredGridView.countBuilder(
      //   crossAxisCount: 4,
      //   itemCount: filteredMeizis.length,
      //   itemBuilder: (BuildContext context, int index) => new MeiziView(filteredMeizis[index]),
      //   staggeredTileBuilder: (int index) =>
      //       new StaggeredTile.count(2, index.isEven ? 2 : 1),
      //   mainAxisSpacing: 4.0,
      //   crossAxisSpacing: 4.0,
      // ),
    );
  }
}
