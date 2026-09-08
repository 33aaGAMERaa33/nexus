import 'package:flutter/material.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';
import 'package:nexus/presentation/clients/clients_view_content.dart';
import 'package:nexus/presentation/clients/clients_view_model.dart';
import 'package:provider/provider.dart';

class ClientsPage extends StatelessWidget {
  final ClientsRepository _clientRepository;

  const ClientsPage({
    super.key,
    required this._clientRepository
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ClientsViewModel(clientRepository: _clientRepository),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<ClientsViewModel>().init();
        });

        return child!;
      },
      child: Consumer<ClientsViewModel>(
        builder: (context, value, child) {
          return ClientsViewContent(value);
        },
      ),
    );
  }
}