import 'dart:async';

import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    implements BaseViewModelOutputs {
  StreamController _inputStateStremController =
      StreamController<FlowState>.broadcast();
  @override
  void dispose() {
    _inputStateStremController.close();
  }

  Sink get inputState => _inputStateStremController.sink;

  Stream<FlowState> get outputState =>
      _inputStateStremController.stream.map((flowState) => flowState);
}

abstract class BaseViewModelInputs {
  void start();
  void dispose();
  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
