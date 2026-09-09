import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/core/repository/repository_error.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';
import 'package:nexus/features/update/domain/repositories/update_repository.dart';

class FakeUpdateRepository implements UpdateRepository {
  @override
  Future<OperationResult<UpdateEntity, RepositoryError>> getLatestUpdateManifest() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    return OperationResult.success(UpdateEntity(
      build: 4,
      version: "0.0.1",
      createdAt: DateTime.now(),
      sha256: "sha256:62572a2c97b286574ecd38258f1ca9994c7c9e1f480ad0016adba26ea3cbef4b",
      downloadUrl: "https://github.com/33aaGAMERaa33/nexus/releases/download/v0.0.1/0.0.1-1.apk",
    ));
  }
}