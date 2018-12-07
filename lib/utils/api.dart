import 'dart:async';
import 'package:meizi/model/model.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';

class HttpUtils {
  Future<String> get(String url, [Map params]) async {
    http.Response response = await http.get(url, headers: params);
    return response.body.toString();
  }

  List<Meizi> toMeiziList(String responseStr) {
    Map<String, dynamic> map = json.decode(responseStr);
    List<Meizi> list = [];
    for (var item in map['results']) {
      list.add(new Meizi.fromJson(item));
    }
    return list;
  }

  Future<List<Meizi>> fetchMeizi(String cate, int page) async {
    final String responseStr = await get('https://meizi.leanapp.cn/category/$cate/page/$page');

    return toMeiziList(responseStr);
  }
}