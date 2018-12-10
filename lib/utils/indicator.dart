import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class IndicatorFactory {
  Widget buildDefaultHeader(BuildContext context, int mode) {
    return new ClassicIndicator(
      failedText: '刷新失败!',
      completeText: '刷新完成!',
      releaseText: '释放可以刷新',
      idleText: '下拉刷新!',
      failedIcon: new Icon(Icons.clear, color: Colors.white),
      completeIcon: new Icon(Icons.done, color: Colors.white),
      idleIcon: new Icon(Icons.arrow_downward, color: Colors.white),
      releaseIcon: new Icon(Icons.arrow_upward, color: Colors.white),
      refreshingText: '正在刷新...',
      textStyle: new TextStyle(inherit: true, color: Colors.white),
      mode: mode,
    );
  }

  Widget buildDefaultFooter(BuildContext context, int mode,[Function requestLoad]) {
    if(mode==RefreshStatus.failed||mode==RefreshStatus.idle) {
      return new InkWell(
        child: new ClassicIndicator(
            mode: mode,
            idleIcon: new Icon(Icons.arrow_upward, color: Colors.white),
            textStyle: new TextStyle(inherit: true, color: Colors.white),
            refreshingText: '加载中...',
            idleText: '上拉加载',
            failedText: '网络异常',
            noDataText: '没有更多数据'),
        onTap: requestLoad,
      );
    } else return new ClassicIndicator(
        mode: mode,
        idleIcon: new Icon(Icons.arrow_upward, color: Colors.white),
        textStyle: new TextStyle(inherit: true, color: Colors.white),
        refreshingText: '加载中...',
        idleText: '上拉加载',
        failedText: '网络异常',
        noDataText: '没有更多数据');
  }
}
