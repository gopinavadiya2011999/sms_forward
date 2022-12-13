import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routing/locator.dart';
import 'base_model.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext buildContext, T model, Widget? child)
  builder;
  final Function(T)? onModelReady;

  BaseView({required this.builder, this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();
  @override
  void initState() {
    // TODO: implement initState
    widget.onModelReady!(model);
    super.initState();
  }

  @override
  void dispose() {
    //  userNotOnlineFalse();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}
