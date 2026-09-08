import 'package:flutter/material.dart';
import 'package:nexus/core/form/masks.dart';
import 'package:nexus/core/form/validators.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';

class BuildClientPage extends StatefulWidget {
  final ClientsRepository _clientsRepository;
  const BuildClientPage(this._clientsRepository, {super.key});

  @override
  State<StatefulWidget> createState() => BuildClientPageState();
}

class BuildClientPageState extends State<BuildClientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  ClientsRepository get _clientsRepository => widget._clientsRepository;

  final FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameFieldController = TextEditingController();

  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _phoneFieldController = TextEditingController();

  PurchaseStatus ? _purchaseStatus;
  
  ClientError ? _error;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Novo Cliente"),
        ),
      
        body: Form(
          key: _formKey,
          child: Column(
            spacing: 12,
            children: [
              _nameField(),
              _phoneField(),
              _purchaseStatusField(),
              _createButton(),

              if(_error != null) Text(_error!.translate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      keyboardType: .name,
      validator: basicValidator,
      focusNode: _nameFocusNode,
      controller: _nameFieldController,
      autovalidateMode: .onUserInteractionIfError,
      onTapOutside: (_) => _nameFocusNode.unfocus(),
      decoration: InputDecoration(
        labelText: "Nome *",
        hintText: "Nome completo",
      ),
    );
  }
  
  Widget _phoneField() {
    return TextFormField(
      keyboardType: .phone,
      validator: phoneValidator,
      focusNode: _phoneFocusNode,
      controller: _phoneFieldController,
      inputFormatters: [PhoneMaskFormatter()],
      autovalidateMode: .onUserInteractionIfError,
      onTapOutside: (_) => _phoneFocusNode.unfocus(),
      decoration: InputDecoration(
        labelText: "Telefone *",
        hintText: "(xx) xxxxx-xxxx",
      ),
    );
  }

  Widget _purchaseStatusField() {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Wrap(
          spacing: 12,
          children: PurchaseStatus.values.map((e) {
            return ChoiceChip(
              checkmarkColor: e.textColor,
              selected: _purchaseStatus == e,
              backgroundColor: e.containerColor,
              label: Text(e.translate, style: TextStyle(color: e.textColor)), 
              onSelected: (_) => setState(() {
                _purchaseStatus = e;
              }),
            ); 
          }).toList(),
        )
      ],
    );
  }

  Widget _createButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _purchaseStatus == null ? null : () async {
          if(!_formKey.currentState!.validate()) return;

          setState(() {
            _error = null;
            _isLoading = true;
          });

          try {
            final OperationResult<ClientEntity, ClientError> result = await _clientsRepository.createClient(CreateClientDTO(
              purchaseStatus: _purchaseStatus!,
              name: _nameFieldController.text.trim(), 
              phone: _phoneFieldController.text.trim(), 
            ));

            if(!result.success) {
              _error = result.error;
              return;
            }

            if(!mounted) return;
            Navigator.pop(context, result.data);
          }finally {
            setState(() => _isLoading = false);
          }
        }, 
        child: _isLoading ? const Center(child: CircularProgressIndicator()) : Text("Criar cliente"),
      ),
    );
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _nameFieldController.dispose();

    _phoneFocusNode.dispose();
    _phoneFieldController.dispose();

    super.dispose();
  }
}