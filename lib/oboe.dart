library oboe;

import 'dart:async';
import 'package:flutter/material.dart';

/// ## Oboe
///
/// > Oboe is like react.Consumer
///
/// Oboe is only one at project; it's single class.
/// Oboe have getState, and setState.
/// setState is trigger all stream listen, update state and call all Oboe widget update.
/// build is use _SubWidget create a StatefulWidget, and subscribe Oboe at _SubWidget.
class Oboe {
  late StreamController _controller;
  late Stream _stream;

  Oboe() {
    _controller = StreamController.broadcast();
    _stream = _controller.stream;
  }

  Widget ob(Widget Function() builder, {List<dynamic> Function()? memo}) {
    return _SubWidget(_stream, builder, memo);
  }

  next() {
    _controller.add(true);
  }
}

/// ## _SubWidget
///
/// > _SubWidget is like react.context.consumer style's state manage widget
///
/// builder[required]: use return widget
/// memo[options]: (state) => [], like react.useMemo, only array object is changed, widget can be update
/// _SubWidget listen Store.stream at initState, and cancel listen at widget dispose.
class _SubWidget extends StatefulWidget {
  final Stream stream;
  final List<dynamic> Function()? memo;
  final Widget Function() builder;

  _SubWidget(this.stream, this.builder, this.memo, {Key? key})
      : super(key: key);

  @override
  _SubWidgetState createState() => _SubWidgetState(stream, memo, builder);
}

class _SubWidgetState extends State<_SubWidget> {
  late StreamSubscription _sub;
  late List<dynamic> _lastMemo;
  final Stream _stream;
  final List<dynamic> Function()? _memo;
  final Widget Function() _builder;

  _SubWidgetState(this._stream, this._memo, this._builder);

  @override
  void initState() {
    super.initState();
    _lastMemo = _memo == null ? [] : [..._memo!()];

    _sub = _stream.listen((data) {
      if (!mounted) {
        return;
      }
      if (_memo == null) {
        setState(() {});
      } else if (_lastMemo.length > 0) {
        bool isUpdate = false;
        List nowMemo = [..._memo!()];
        for (var i = 0; i < _lastMemo.length; i++) {
          if (_lastMemo[i] != nowMemo[i]) {
            isUpdate = true;
            break;
          }
        }
        if (isUpdate == true) {
          _lastMemo = nowMemo;

          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return _builder();
  }
}
