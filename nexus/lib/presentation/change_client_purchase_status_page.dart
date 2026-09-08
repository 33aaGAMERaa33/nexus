import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';

class ChangeClientPurchaseStatusPage extends StatefulWidget {
  final ClientEntity client;
  final ClientsRepository _clientsRepository;

  const ChangeClientPurchaseStatusPage({
    super.key,
    required this.client,
    required this._clientsRepository,
  });

  @override
  State<StatefulWidget> createState() => ChangeClientPurchaseStatusPageState();
}

class ChangeClientPurchaseStatusPageState extends State<ChangeClientPurchaseStatusPage> {
  ClientEntity get _client => widget.client;
  ClientsRepository get _clientsRepository => widget._clientsRepository;

  bool _isLoading = false;
  ClientEntity ? _lastDataChange;
  late PurchaseStatus _selectedPurchaseStatus = _client.purchaseStatus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if(didPop || _isLoading) return;
          Navigator.pop(context, _lastDataChange);
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Column(
                spacing: 12,
                mainAxisSize: .min,
                children: [
                  _headerSection(),
                  _purchaseStatusSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerSection() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String createdAtFormatted = DateFormat("dd/MM/yyyy").format(_client.createdAt);

    return Card(
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: _selectedPurchaseStatus.containerColor,
                    child: Text(_client.name[0].toUpperCase(), style: TextStyle(
                      fontSize: 40,
                      color: _selectedPurchaseStatus.textColor,
                    )),
                  ),

                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(_client.name, style: TextStyle(
                        fontSize: 18,
                        fontWeight: .w500
                      )),
                      
                      Text("Cadastrado em: $createdAtFormatted", style: TextStyle(
                        fontSize: 15,
                        color: colorScheme.onSurfaceVariant,
                      ))  
                    ],
                  ),
                ],
              ),

              Column(
                children: [
                  ListTile(
                    title: Text(_client.phone),
                    leading: const Icon(Icons.phone),
                    trailing: IconButton(
                      onPressed: () => Clipboard.setData(ClipboardData(text: _client.phone)),
                      icon: const Icon(Icons.copy),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _purchaseStatusSection() {
    return Column(
      spacing: 6,
      children: PurchaseStatus.values.map((e) {
        final bool selected = e == _selectedPurchaseStatus;

        return Card(
          color: selected ? e.containerColor : null,
          clipBehavior: .hardEdge,
          child: RadioListTile(
            value: e,
            selected: selected,
            enabled: !_isLoading,
            title: Text(e.translate),
            activeColor: e.textColor,
            groupValue: _selectedPurchaseStatus,
            onChanged: (_) async {
              setState(() => _isLoading = true);
              _selectedPurchaseStatus = e;

              try {
                final OperationResult<ClientEntity, ClientError> result = await _clientsRepository.changePurchaseStatus(ChangePurchaseStatusDTO(
                  clientUUid: _client.uuid, 
                  purchaseStatus: e,
                ));

                if(!mounted) return;

                if(!result.success) {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Ops..."),
                      content: Text(result.error.translate),
                    );
                  });

                  return;
                }

                _lastDataChange = result.data;
              }catch(_) {
                setState(() {
                  _selectedPurchaseStatus = _client.purchaseStatus;
                });
              } finally {
                setState(() => _isLoading = false);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}