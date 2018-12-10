import 'package:flutter/material.dart';

class CustomIndicator extends StatefulWidget {

  final ValueNotifier offsetLis;

  final Color color;

  CustomIndicator({this.color,this.offsetLis});

  @override
  _CustomIndicatorState createState() => new _CustomIndicatorState();
}

class _CustomIndicatorState extends State<CustomIndicator> {

  Function _update ;

  @override
  void initState() {
    // TODO: implement initState
    _update =  (){
      setState(() {

      });
    };
    widget.offsetLis.addListener(_update);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.offsetLis.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new ClipPath(
      clipper: new ArcClipper(offset: widget.offsetLis.value),
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: widget.color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path>{
  final double offset;
  ArcClipper({this.offset});
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    final Path path = new Path();
    path.cubicTo(0.0, 0.0, size.width/2, offset*2.3, size.width , 0.0 );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return this != oldClipper;
  }
}
