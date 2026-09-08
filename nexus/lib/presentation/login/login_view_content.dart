import 'package:flutter/material.dart';
import 'package:nexus/core/form/validators.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/features/session/data/repositories/supabase_session_repository.dart';
import 'package:nexus/presentation/login/login_view_model.dart';
import 'package:nexus/presentation/session_page.dart';

class LoginViewContent extends StatelessWidget {
  final LoginViewModel _viewModel;
  const LoginViewContent(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _viewModel.formKey,
              child: Column(
                spacing: 12,
                mainAxisSize: .min,
                children: [
                  _loginField(),
                  _passwordField(),
                  _loginButton(context),
                  _errorMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginField() {
    return TextFormField(
      validator: basicValidator,
      keyboardType: .emailAddress,
      enabled: !_viewModel.isLoading,
      controller: _viewModel.loginFieldController,
      decoration: InputDecoration(labelText: "Login"),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      validator: basicValidator,
      enabled: !_viewModel.isLoading,
      obscureText: !_viewModel.passwordVisible,
      controller: _viewModel.passwordFieldController,
      keyboardType: _viewModel.passwordVisible ? .visiblePassword : null,
      decoration: InputDecoration(
        labelText: "Senha",
        suffixIcon: IconButton(
          onPressed: () => _viewModel.passwordVisible = !_viewModel.passwordVisible, 
          icon: Icon(_viewModel.passwordVisible ? Icons.remove_red_eye : Icons.password),
        )
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _viewModel.isLoading ? null : () async {
          await _viewModel.login();
          if(!context.mounted) return;
      
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return SessionPage(SupabaseSessionRepository());
          }));
        },
        child: Text("Entrar"),
      ),
    );
  }

  Widget _errorMessage() {
    if(_viewModel.loginError == null) return const SizedBox();
    final AuthError loginError = _viewModel.loginError!;

    late final String label;

    switch(loginError) {
      case .unknown:
        label = "Houve um erro desconhecido";
        break;
      case .invalidCredentials:
        label = "Credenciais inválidas";
        break;
    }

    return Text(label, style: TextStyle(

    ));
  }  
}