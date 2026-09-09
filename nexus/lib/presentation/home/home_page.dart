import 'package:flutter/material.dart';
import 'package:nexus/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nexus/presentation/home/home_view_content.dart';
import 'package:nexus/presentation/home/home_view_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final LogoutUsecase _logoutUsecase;

  const HomePage({
    super.key,
    required this._logoutUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(logoutUsecase: _logoutUsecase),
      child: Consumer<HomeViewModel>(
        builder: (context, value, child) {
          return HomeViewContent(value);
        },
      ),
    );
  }
}