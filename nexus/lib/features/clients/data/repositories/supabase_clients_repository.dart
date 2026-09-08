import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientsRepository implements ClientsRepository {
  late final SupabaseClient _supabaseClient = getter();

  @override
  Future<OperationResult<ClientEntity, ClientError>> changePurchaseStatus(ChangePurchaseStatusDTO dto) async {
    try {
      final FunctionResponse resposne = await _supabaseClient.functions.invoke("clients-change_purchase_status", method: .patch, body: {
        "client_uuid": dto.clientUUid,
        "purchase_status": dto.purchaseStatus.value,
      });

      return OperationResult.success(_parseClient(resposne.data));
    }on FunctionException catch(e) {
      return OperationResult.error(_parseError(e.details["message"]));
    }
  }

  @override
  Future<OperationResult<ClientEntity, ClientError>> createClient(CreateClientDTO dto) async {
    try {
      final FunctionResponse response = await _supabaseClient.functions.invoke("clients-create_client", method: .post, body: {
        "name": dto.name,
        "phone": dto.phone,
        "purchase_status": dto.purchaseStatus.value,
      });

      return OperationResult.success(_parseClient(response.data));
    }on FunctionException catch(e) {
      return OperationResult.error(_parseError(e.details["message"]));
    }
  }

  @override
  Future<OperationResult<List<ClientEntity>, ClientError>> getClients({
    int ? offset = 0,
    int ? limit = 100, 
  }) async {
    try {
      final FunctionResponse response = await _supabaseClient.functions.invoke("clients-get_clients", method: .get, queryParameters: {
        if(limit != null) "limit": limit.toString(),
        if(offset != null) "offset": offset.toString(),
      });

      return OperationResult.success((response.data["clients"] as List).map(((value) {
        return _parseClient(value);
      })).toList());
    } on FunctionException catch(e) {
      return OperationResult.error(_parseError(e.details["message"]));
    }
  }

  ClientError _parseError(String raw) {
    switch(raw) {
      case "client_already_exists": return .clientAlreadyExists;
      case "unknown":
      default: return .unknown;
    }
  } 

  ClientEntity _parseClient(Map json) => ClientEntity(
    uuid: json["uuid"], 
    name: json["name"], 
    phone: json["phone"], 
    createdAt: DateTime.parse(json["created_at"]), 
    updatedAt: DateTime.parse(json["updated_at"]), 
    purchaseStatus: PurchaseStatus.values.firstWhere((element) => element.value == json["purchase_status"]),
  );
}