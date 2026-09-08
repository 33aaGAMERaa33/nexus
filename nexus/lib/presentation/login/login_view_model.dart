import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/auth/domain/entities/user_entity.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';

class LoginViewModel with ChangeNotifier {
  final AuthRepository _loginRepository;
  LoginViewModel(this._loginRepository);

  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController loginFieldController = TextEditingController(text: kDebugMode ? "luan@nexus.com" : "");
  final TextEditingController passwordFieldController = TextEditingController(text: kDebugMode ? "123456" : "");

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthError? _loginError;
  AuthError? get loginError => _loginError;

  Future<void> login() async {
    if (_isLoading || !formKey.currentState!.validate()) return;
    _isLoading = true;
    _loginError = null;
    notifyListeners();

    try {
      final OperationResult<UserEntity, AuthError> result =
          await _loginRepository.login(
            AuthCredentials(
              login: loginFieldController.text.trim(),
              password: passwordFieldController.text.trim(),
            ),
          );

      if(!result.success) {
        _loginError = result.error;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
