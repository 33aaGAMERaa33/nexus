import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/features/session/domain/storage/session_storage.dart';

class LogoutUsecase {
  final SessionStorage _sessionStorage;
  final AuthRepository _authRepository;

  const new({
    required this._sessionStorage, 
    required this._authRepository,
  });

  Future<OperationResult<void, AuthError>> call() async {
    try {
      final OperationResult<void, AuthError> result = await _authRepository.logout();
      if(!result.success) return OperationResult.error(result.error);
      
      _sessionStorage.setSession(null);
      return OperationResult.success(null);
    }catch(e) {
      return OperationResult.error(.unknown);
    }
  }
}