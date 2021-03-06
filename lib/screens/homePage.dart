import 'package:flutter/material.dart';
import 'package:meizi/model/model.dart';
import 'package:meizi/screens/meiziView.dart';
import 'package:meizi/utils/api.dart';
import 'package:meizi/utils/db.dart';
import 'package:meizi/utils/indicator.dart';
import 'package:meizi/widget/custom_indicator.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const categories = {
  'All': 'All',
  'DaXiong': 'DaXiong',
  'QiaoTun': 'QiaoTun',
  'HeiSi': 'HeiSi',
  'MeiTui': 'MeiTui',
  'QingXin': 'QingXin',
  'ZaHui': 'ZaHui',
};

class HomePage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> with HttpUtils, DbUtils, IndicatorFactory, AutomaticKeepAliveClientMixin {
  List<Meizi> meiziMen = List();
  int _page = 1;
  String _cate = 'All';
  RefreshController _refreshController;
  ValueNotifier<double> offsetLis = new ValueNotifier(0.0);

  @override
  bool get wantKeepAlive => true;

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
    fetchMeizi(_cate, 1).then((moreMeizi) {
      // TODO: use unshift not clear
      setState(() =>  meiziMen = moreMeizi);
      _refreshController.sendBack(true, RefreshStatus.completed);
    }).catchError((error) {
      _refreshController.sendBack(true, RefreshStatus.failed);
      return false;
    });
  }

  void fetchMoreMeizi() {
    fetchMeizi(_cate, _page).then((moreMeizi) {
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

  void _onRefresh(bool up) {
    if (!up) {
      print('more');
      fetchMoreMeizi();
    } else {
      print('new');
      fetchNewMeizi();
    }
  }

  void _onOffsetCall(bool up, double offset) {
    if (up) {
      offsetLis.value = offset;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          new Container(
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Text('Filter: ', textAlign: TextAlign.left),
                ),
                Expanded(
                  child: new DropdownButton(
                    hint: new Text("Select a Category"),
                    value: _cate,
                    items: categories.keys.map((key) {
                      return new DropdownMenuItem<String>(
                        child: new Text(categories[key]),
                        value: key
                      );
                    }).toList(),
                    onChanged: (String v) {
                      setState(() {
                        _cate = v;
                        meiziMen.clear();
                        fetchNewMeizi();
                      });
                    },
                  )
                ),
              ],
            )
          ),
          Expanded(
            child: new Stack(children: <Widget>[
              new CustomIndicator(
                offsetLis: offsetLis,
              ),
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
                footerBuilder: (context,mode) => buildDefaultFooter(context,mode,(){
                  _refreshController.sendBack(false, RefreshStatus.refreshing);
                }),
                headerBuilder: buildDefaultHeader,
                onOffsetChange: _onOffsetCall,
              )
            ])
          )
        ],
      ),
    );
  }
}
