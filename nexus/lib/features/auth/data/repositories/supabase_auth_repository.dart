import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/auth/domain/entities/user_entity.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  late final SupabaseClient _supabaseClient = getter();

  @override
  Future<OperationResult<UserEntity, AuthError>> login(
    AuthCredentials params,
  ) async {
    try {
      final AuthResponse response = await _supabaseClient.auth.signInWithPassword(
        email: params.login, password: params.password
      );

      return OperationResult.success(
        UserEntity(uuid: response.user!.aud, email: response.user!.email!),
      );
    } on AuthException catch (e) {
      switch (e.statusCode) {
        case "400":
          return OperationResult.error(.invalidCredentials);
        default:
          return OperationResult.error(.unknown);
      }
    }
  }

  @override
  Future<OperationResult<void, AuthError>> logout() async {
    try {
      await _supabaseClient.auth.signOut();
      return OperationResult.success(null);
    }catch(e) {
      return OperationResult.error(.unknown);
    }
  }
}
