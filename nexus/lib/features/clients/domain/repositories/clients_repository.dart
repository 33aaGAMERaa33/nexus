import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';

enum ClientError {
  unknown("Erro desconhecido"),
  clientNotFound("Cliente não encontrado"),
  clientAlreadyExists("Cliente já existe");

  final String translate;
  const new(this.translate);
}

class CreateClientDTO {
  final String name;
  final String phone;
  final PurchaseStatus purchaseStatus;

  const new({
    required this.name, 
    required this.phone, 
    required this.purchaseStatus,
  });
}

class ChangePurchaseStatusDTO {
  final String clientUUid;
  final PurchaseStatus purchaseStatus;

  const new({
    required this.clientUUid, 
    required this.purchaseStatus,
  });
}

abstract interface class ClientsRepository {
  Future<OperationResult<ClientEntity, ClientError>> changePurchaseStatus(ChangePurchaseStatusDTO dto);
  
  Future<OperationResult<ClientEntity, ClientError>> createClient(CreateClientDTO dto);

  Future<OperationResult<List<ClientEntity>, ClientError>> getClients({
    int ? limit,
    int ? offset,
  });
}
