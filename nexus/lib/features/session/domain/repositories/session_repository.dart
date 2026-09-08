import 'package:nexus/features/session/domain/entities/session_entity.dart';

abstract interface class SessionRepository {
  Future<SessionEntity?> getSession(); 
}