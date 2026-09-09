import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/core/repository/repository_error.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';

abstract interface class UpdateRepository {
  Future<OperationResult<UpdateEntity, RepositoryError>> getLatestUpdateManifest();
}