import 'package:nexus/features/auth/domain/entities/user_entity.dart';

class SessionEntity {
  final UserEntity user;
  final DateTime loggedAt;

  const new({
    required this.user, 
    required this.loggedAt,
  });
}