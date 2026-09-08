import 'package:nexus/features/auth/domain/entities/user_entity.dart';
import 'package:nexus/features/session/domain/entities/session_entity.dart';
import 'package:nexus/features/session/domain/repositories/session_repository.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSessionRepository implements SessionRepository {
  late final SupabaseClient _supabaseClient = getter();

  @override
  Future<SessionEntity?> getSession() async {
    try {
      final User ? user = (await _supabaseClient.auth.getUser()).user;
      if(user == null) return null;

      return SessionEntity(
        loggedAt: DateTime.parse(user.lastSignInAt!),
        user: UserEntity(
          uuid: user.aud, 
          email: user.email!,
        ), 
      );
    }on AuthException catch(_) {
      return null;
    }
  }
}