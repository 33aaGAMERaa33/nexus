import 'package:flutter/material.dart';
import 'package:nexus/core/info/app_info.dart';
import 'package:nexus/core/utils.dart';
import 'package:nexus/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:nexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:nexus/presentation/clients/clients_page.dart';
import 'package:nexus/presentation/home/home_view_model.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:nexus/presentation/login/login_page.dart';

class HomeViewContent extends StatelessWidget {
  final HomeViewModel _viewModel;
  const HomeViewContent(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppInfo.appName)),
        drawer: _drawer(context),
        body: _body(),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            children: [
              _menuItem(
                label: "Clientes", 
                iconData: Icons.group,
                selected: _viewModel.homeState == .clientsPage,
                onTap: _viewModel.isLoading ? null : () {
                  Navigator.pop(context);
                  _viewModel.homeState = .clientsPage;
                },
              ),
            ],
          ),

          Column(
            children: [
              // _menuItem(
              //   label: "Configurações", 
              //   iconData: Icons.settings,
              // ),

              _menuItem(
                label: "Encerrar sessão", 
                iconData: Icons.exit_to_app,
                onTap: _viewModel.isLoading ? null : () => _logout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    switch(_viewModel.homeState) {
      case .clientsPage: return ClientsPage(
        clientRepository: getter(),
      );
    }
  }

  Widget _menuItem({
    VoidCallback ? onTap,
    required String label,
    bool selected = false,
    required IconData iconData,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(label),
      selected: selected,
      leading: Icon(iconData),
    );
  }

  void _logout(BuildContext context) async {
    Navigator.pop(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      showDialog(context: context, builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      });

      try {
        final AuthError ? result = await _viewModel.logout();

        if(result != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch(result) {
              default: unknownErrorDialog(context); break;
            }
          });

          return;
        }

        if(context.mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return LoginPage(SupabaseAuthRepository());
            }));
          });
        }
      }catch(e, stack) {
        debugPrint(stack.toString());
        debugPrint(e.toString());

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(!context.mounted) return;
          unknownErrorDialog(context);
        });
      }finally {
        if(!context.mounted) return;
        Navigator.pop(context);
      }
    });
  }
}    