import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:nexus/core/models/env_model.dart';
import 'package:nexus/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nexus/features/clients/data/repositories/supabase_clients_repository.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';
import 'package:nexus/features/session/data/repositories/supabase_session_repository.dart';
import 'package:nexus/features/session/domain/repositories/session_repository.dart';
import 'package:nexus/features/session/domain/storage/session_storage.dart';
import 'package:nexus/presentation/session_page.dart';
import 'package:nexus/presentation/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt getter = GetIt.instance;

class InitializationPage extends StatelessWidget {
  static bool _initialized = false;
  const InitializationPage({super.key});

  @override
  Widget build(BuildContext context) {
    if(!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _init();

        if(context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return SessionPage(getter());
        }));
      });

      return const SplashPage();
    }

    return SessionPage(getter());
  }

  Future<void> _init() async {
    if(_initialized) return;
    _initialized = true;

    await dotenv.load();

    final EnvModel env = getter.registerSingleton(EnvModel(
      development: dotenv.getBool("DEVELOPMENT"), 

      supabaseUrl: dotenv.get("SUPABASE_URL"), 
      supabaseKey: dotenv.get("SUPABASE_KEY"), 
      
      devSupabaseUrl: dotenv.get("DEV_SUPABASE_URL"), 
      devSupabaseKey: dotenv.get("DEV_SUPABASE_KEY"),
    ));

    final Supabase supabase = await Supabase.initialize(      
      url: env.development ? env.devSupabaseUrl : env.supabaseUrl,
      publishableKey: env.development ? env.devSupabaseKey : env.supabaseKey,
    );

    getter.registerSingleton(Dio());
    getter.registerSingleton(supabase.client);
    getter.registerSingleton(SessionStorage());

    getter.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository());
    getter.registerLazySingleton<ClientsRepository>(() => SupabaseClientsRepository());
    getter.registerLazySingleton<SessionRepository>(() => SupabaseSessionRepository());

    getter.registerSingleton(LogoutUsecase(
      sessionStorage: getter(), 
      authRepository: getter(),
    ));
  }
} 