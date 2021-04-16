import 'package:crossfit/ui/base_bloc_screen.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class BlocBuilder<T extends BaseBloc> extends StatefulWidget {
  final BaseBlocScreen root;
  final Widget child;
  final T bloc;
  final EdgeInsetsGeometry padding;

  BlocBuilder({
    Key key,
    @required this.root,
    @required this.child,
    @required this.bloc,
    this.padding,
  }) : super(key: key);

  @override
  _BlocBuilderState<T> createState() => _BlocBuilderState<T>();
}

class _BlocBuilderState<T extends BaseBloc> extends State<BlocBuilder<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    widget.root?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    widget.root?.init(context);
    widget.bloc?.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.padding != null
        ? Padding(
      padding: widget.padding,
      child: widget.child,
    ) : widget.child;
  }
}
