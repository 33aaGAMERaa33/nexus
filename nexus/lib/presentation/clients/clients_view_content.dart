import 'package:flutter/material.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';
import 'package:nexus/presentation/build_client_page.dart';
import 'package:nexus/presentation/change_client_purchase_status_page.dart';
import 'package:nexus/presentation/clients/clients_view_model.dart';
import 'package:nexus/presentation/initialization_page.dart';

class ClientsViewContent extends StatelessWidget {
  final ClientsViewModel _viewModel;
  const ClientsViewContent(this._viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.only(bottom: 50),
        child: ListView.builder(
          controller: _viewModel.scrollController,
          itemCount: _viewModel.clients.length + 1,
          itemBuilder: (context, index) {
            if(index == _viewModel.clients.length) return AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child: !_viewModel.isLoading ? const SizedBox() : const Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: CircularProgressIndicator()
                ),
              ),
            );

            return _clientWidget(context, _viewModel.clients.elementAt(index));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ClientEntity ? client = await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return BuildClientPage(getter());
          }));

          if(client != null) {
            await _viewModel.getClients();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _clientWidget(BuildContext context, ClientEntity client) {
    return Card(
      key: Key(client.uuid),
      clipBehavior: .hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: client.purchaseStatus.containerColor,
            child: Text(client.name[0].toUpperCase(), style: TextStyle(
              color: client.purchaseStatus.textColor,
            )),
          ),
          title: Text(client.name, overflow: .ellipsis),
          subtitle: Text(client.phone),
          trailing: Row(
            mainAxisSize: .min,
            children: [
              Chip(
                label: Row(
                  spacing: 12,
                  children: [
                    CircleAvatar(backgroundColor: client.purchaseStatus.textColor, radius: 5),

                    Text(client.purchaseStatus.translate, style: TextStyle(
                      color: client.purchaseStatus.textColor
                    )),
                  ],
                ),
              ),

              const Icon(Icons.arrow_right),
            ],
          ),
          onTap: _viewModel.isLoading ? null : () async {
            final ClientEntity ? clientDataChange = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeClientPurchaseStatusPage(
                client: client, 
                clientsRepository: getter(),
              );
            }));

            if(clientDataChange != null) {
              _viewModel.updateClient(client, clientDataChange);
            }
          },
        ),
      ),
    );
  }
}