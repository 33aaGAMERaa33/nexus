import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/auth/domain/entities/user_entity.dart';

enum AuthError { 
  unknown("Erro desconhecido"), 
  invalidCredentials("Credenciais inválidas");

  final String translate;
  const new(this.translate);
}

class AuthCredentials {
  final String login;
  final String password;

  const new({required this.login, required this.password});
}

abstract interface class AuthRepository {
  Future<OperationResult<UserEntity, AuthError>> login(
    AuthCredentials credentials,
  );

  Future<OperationResult<void, AuthError>> logout();
}
