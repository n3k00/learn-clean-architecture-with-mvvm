import 'dart:async';

import 'package:complete_advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:dartz/dartz.dart';

class LoginViewModel extends BaseViewModel
    implements LoginViewModelInputs, LoginViewModelOutput {
  late final StreamController<String> _userNameStreamController =
      StreamController<String>.broadcast();
  late final StreamController<String> _passwordStreamController =
      StreamController<String>.broadcast();

  late final StreamController<void> _isAllInputsValidateStreamController =
      StreamController<void>.broadcast();

  late final StreamController<bool> isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject("", "");

  LoginUseCase? _loginUseCase;
  LoginViewModel(this._loginUseCase);

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidateStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputIsAllInputsValidate =>
      _isAllInputsValidateStreamController.sink;

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _loginUseCase!.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((failure) {
      print(failure.message);
      // left -> failure
      inputState.add(
          ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
    }, (data) {
      // right -> success (data)
      inputState.add(ContentState());

      // navigate to main screen after the login
      isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _validate();
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    _validate();
  }

  @override
  Stream<bool> get outputIsPasswordValidate => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserNameValidate => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outputIsAllInputsValidate =>
      _isAllInputsValidateStreamController.stream
          .map((_) => _isAllInputsValid());

  _validate() {
    inputIsAllInputsValidate.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _isAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputIsAllInputsValidate;
}

abstract class LoginViewModelOutput {
  Stream<bool> get outputIsUserNameValidate;
  Stream<bool> get outputIsPasswordValidate;
  Stream<bool> get outputIsAllInputsValidate;
}
