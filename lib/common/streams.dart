import 'dart:async';

import 'package:flutter/material.dart';

abstract class StreamSubController {
  final _subList = List<StreamSubscription>();

  @protected
  void bindSub(StreamSubscription sub) {
    _subList.add(sub);
  }

  @protected
  void subDispose() {
    _subList.forEach((v) => v.cancel());
    _subList.clear();
  }
}

extension SubscriptionExt on StreamSubscription {
  void bindLife(StreamSubController controller) {
    controller.bindSub(this);
  }
}

extension ControllerExt on StreamController<dynamic> {
  void safeAdd(dynamic data) {
    if (this.isClosed) return;

    this.add(data);
  }
}
