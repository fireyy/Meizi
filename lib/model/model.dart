import 'package:meta/meta.dart';

class Meizi {
  Meizi({
    @required this.title,
    @required this.thumbUrl,
    @required this.id,
    @required this.imageUrl,
    this.favored,
    this.isExpanded,
  });

  String title, thumbUrl, id, imageUrl;
  bool favored, isExpanded;

  Meizi.fromJson(Map json)
      : title = json["title"],
        thumbUrl = json["thumb_url"],
        id = json["objectId"],
        imageUrl = json["image_url"],
        favored = false;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['thumb_url'] = thumbUrl;
    map['image_url'] = imageUrl;
    map['favored'] = favored;
    return map;
  }

  Meizi.fromDb(Map map)
      : title = map["title"],
        thumbUrl = map["thumb_url"],
        id = map["id"],
        imageUrl = map["image_url"],
        favored = map['favored'] == 1 ? true : false;
}
