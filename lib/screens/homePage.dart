import 'package:flutter/material.dart';
import 'package:meizi/model/model.dart';
import 'package:meizi/screens/meiziView.dart';
import 'package:meizi/utils/api.dart';
import 'package:meizi/utils/db.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> with HttpUtils, DbUtils {
  List<Meizi> meiziMen = List();
  int _page = 1;
  RefreshController _refreshController;

  @override
  void initState() {
    super.initState();

    _refreshController = new RefreshController();

    // init DataBase.
    initDB().then((val) {
      fetchMoreMeizi();
    });
  }

  void fetchNewMeizi() {
    fetchMeizi('All', 1).then((moreMeizi) {
      // TODO: use unshift not clear
      setState(() =>  meiziMen = moreMeizi);
      _refreshController.sendBack(true, RefreshStatus.completed);
    }).catchError((error) {
      _refreshController.sendBack(true, RefreshStatus.failed);
      return false;
    });
  }

  void fetchMoreMeizi() {
    fetchMeizi('All', _page).then((moreMeizi) {
      if (moreMeizi.isEmpty) {
        _refreshController.sendBack(false, RefreshStatus.noMore);
      } else {
        setState(() =>  meiziMen.addAll(moreMeizi));
        _page++;
        _refreshController.sendBack(false, RefreshStatus.idle);
      }
    }).catchError((error) {
      _refreshController.sendBack(false, 4);
      return false;
    });
  }

  Widget _buildHeader(context,mode){
   return new ClassicIndicator(mode: mode);
  }
  
 
  Widget _buildFooter(context,mode){
    return new ClassicIndicator(mode: mode);
  }

  void _onRefresh(bool up) {
    if (!up) {
      print('more');
      fetchMoreMeizi();
    } else {
      print('new');
      fetchNewMeizi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: new Stack(children: <Widget>[
              new SmartRefresher(
                controller: _refreshController,
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 4,
                  itemCount: meiziMen.length,
                  itemBuilder: (BuildContext context, int index) => new MeiziView(meiziMen[index]),
                  staggeredTileBuilder: (int index) =>
                      new StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                onRefresh: _onRefresh,
                enablePullUp: true,
                enablePullDown: true,
                footerBuilder: _buildFooter,
                headerBuilder: _buildHeader
              )
            ])
          )
        ],
      ),
    );
  }
}
