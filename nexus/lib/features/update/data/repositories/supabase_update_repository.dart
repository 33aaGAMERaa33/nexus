import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/core/repository/repository_error.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';
import 'package:nexus/features/update/domain/repositories/update_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUpdateRepository implements UpdateRepository {
  final SupabaseClient _supabaseClient;
  const new(this._supabaseClient);

  @override
  Future<OperationResult<UpdateEntity, RepositoryError>> getLatestUpdateManifest() async {
    try {
      final FunctionResponse response = await _supabaseClient.functions.invoke("update-get_latest", method: .get);

      return OperationResult.success(UpdateEntity(
        build: response.data["build"], 
        version: response.data["version"], 

        sha256: response.data["sha256"], 
        downloadUrl: response.data["download_url"],

        createdAt: DateTime.parse(response.data["created_at"]), 
      ));
    } on FunctionException catch(_) {
      return OperationResult.error(.unknown);
    }
  }
}