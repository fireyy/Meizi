import 'package:flutter/material.dart';
import 'package:meizi/utils/db.dart';
import 'package:meizi/model/model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class MeiziView extends StatefulWidget {
  MeiziView(this.meizi);

  final Meizi meizi;

  @override
  MeiziViewState createState() => MeiziViewState();
}

class MeiziViewState extends State<MeiziView> with DbUtils {
  Meizi meiziState;

  @override
  void initState() {
    super.initState();
    meiziState = widget.meizi;
    getMeizi(meiziState.id).then((meizi) {
      if(meizi != null) setState(() => meiziState.favored = meizi.favored);
    });
  }

  void onPressed() {
    setState(() => meiziState.favored = !meiziState.favored);
    meiziState.favored == true
        ? addMeizi(meiziState)
        : deleteMeizi(meiziState.id);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new ImagePreViewWidget(url: meiziState.imageUrl),
          )
        );
      },
      child: new Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: <Widget>[
          new CachedNetworkImage(
            imageUrl: meiziState.imageUrl,
            fit: BoxFit.cover,
            placeholder: new LinearProgressIndicator(),
            errorWidget: new Icon(Icons.error),
          ),
          new Positioned(
            left: 5,
            bottom: 5,
            child: new Text(
              meiziState.title,
              textAlign: TextAlign.center,
              maxLines: 10,
            ),
          ),
          new Positioned(
            right: 5,
            top: 5,
            child: IconButton(
              icon: meiziState.favored ? Icon(Icons.star) : Icon(Icons.star_border),
              color: Colors.white,
              onPressed: () {
                onPressed();
              },
            ),
          ),
        ]
      ),
    );
  }
}

class ImagePreViewWidget extends StatelessWidget {
  final String url;

  const ImagePreViewWidget({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(url),
          ))));
  }
}