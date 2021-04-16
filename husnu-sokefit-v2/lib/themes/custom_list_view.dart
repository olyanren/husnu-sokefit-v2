import 'package:flutter/cupertino.dart';

class CustomListView extends StatelessWidget {
  List<Widget> children;
  final EdgeInsetsGeometry padding;
  CustomListView({ List<Widget> children = const <Widget>[],this.padding}){
    this.children=children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          children: children,
        ),
      ),
    );
  }
}
