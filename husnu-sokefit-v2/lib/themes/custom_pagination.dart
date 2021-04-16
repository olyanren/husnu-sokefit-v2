import 'package:sokefit/blocs/pagination_bloc.dart';
import 'package:sokefit/models/pagination_model.dart';
import 'package:sokefit/themes/custom_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac

class CustomPagination<T extends PaginationModel> extends StatefulWidget {
  PaginationBloc<T> bloc;
  Function builder;
  List items;
  int itemCount;
  Widget header;

  CustomPagination(
      {Key key,
      @required this.bloc,
      @required this.builder,
      this.items,
      this.itemCount = 10,
      this.header})
      : super(key: key);

  @override
  _InnerCustomPagination createState() => _InnerCustomPagination<T>();
}

class _InnerCustomPagination<T extends PaginationModel>
    extends State<CustomPagination> {
  String message;
  bool _showProgressBar;
  List items = [];
  int page = 1;
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    if (widget.items != null) {
      items = widget.items;
      page = 2;
    } else {
      widget.bloc.items(page, widget.itemCount).then((value) {
        setState(() {
          items.addAll(value.data.data);
        });
      });
    }
    super.initState();
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (_showProgressBar == true) return;
      setState(() {
        _showProgressBar = true;
      });
      widget.bloc.items(page++, widget.itemCount).then((value) {
        if (value != null)
          setState(() {
            _showProgressBar = false;
            items.addAll(value.data.data);
          });
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          items == null
              ? Container()
              : Expanded(
                  child: MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: <Widget>[
                              widget.header ?? Container(),
                              widget.builder(items[index])
                            ],
                          );
                        }
                        if (index >= items.length) return Container();
                        return widget.builder(items[index]);
                      },
                    ),
                  ),
                ),
          _showProgressBar == true ? CustomProgressBar() : Container()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();

    super.dispose();
  }
}
