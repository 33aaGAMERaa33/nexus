import 'package:flutter/material.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/auth/domain/entities/user_entity.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nexus/features/session/domain/storage/session_storage.dart';
import 'package:nexus/presentation/initialization_page.dart';

enum HomeState {
  clientsPage("Clientes");
  
  final String title;
  const new(this.title);
}

class HomeViewModel with ChangeNotifier {
  final LogoutUsecase _logoutUsecase;
  late final SessionStorage _sessionStorage = getter();

  new({required this._logoutUsecase});
  
  UserEntity get user => _sessionStorage.getSession()!.user;

  HomeState _homeState = .clientsPage;

  HomeState get homeState => _homeState;

  set homeState(HomeState homeState) {
    if(homeState == _homeState) return;
    _homeState = homeState;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<AuthError?> logout() async {
    if(_isLoading) return null;
    _isLoading = true;
    notifyListeners();

    try {
      final OperationResult<void, AuthError> result = await _logoutUsecase();
      return result.success ? null : result.error;
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}