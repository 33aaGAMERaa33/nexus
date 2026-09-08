import 'package:nexus/features/session/domain/entities/session_entity.dart';

class SessionStorage {
  SessionEntity ? _session;

  SessionEntity ? setSession(SessionEntity ? session) {
    _session = session;
    return session;
  }

  SessionEntity ? getSession() {
    return _session;
  }
}