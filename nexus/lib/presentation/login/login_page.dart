import 'package:flutter/material.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/presentation/login/login_view_content.dart';
import 'package:nexus/presentation/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final AuthRepository _loginRepository;
  const LoginPage(this._loginRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(_loginRepository),
      child: Consumer<LoginViewModel>(
        builder: (context, value, child) {
          return LoginViewContent(value);
        },
      ),
    );
  }
}