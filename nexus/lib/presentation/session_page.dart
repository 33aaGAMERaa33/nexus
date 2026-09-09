import 'package:flutter/material.dart';
import 'package:nexus/features/session/domain/repositories/session_repository.dart';
import 'package:nexus/features/session/domain/storage/session_storage.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:nexus/presentation/login/login_page.dart';
import 'package:nexus/presentation/splash_page.dart';
import 'package:nexus/presentation/update_page.dart';

class SessionPage extends StatelessWidget {
  final SessionRepository _sessionRepository;
  const SessionPage(this._sessionRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bool hasSession = await _getSession();
      if(!context.mounted) return;

      if(hasSession) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return UpdatePage(getter());
        }));
      }else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return LoginPage(getter());
        }));
      }
    });

    return const SplashPage();
  }

  Future<bool> _getSession() async {
    final SessionStorage sessionStorage = getter();
    return sessionStorage.setSession(await _sessionRepository.getSession()) != null;
  }
}