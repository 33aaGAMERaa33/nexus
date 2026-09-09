import 'package:flutter/foundation.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/core/models/operation_state.dart';
import 'package:nexus/core/repository/repository_error.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';
import 'package:nexus/features/update/domain/repositories/update_repository.dart';
import 'package:nexus/features/update/domain/services/update_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateUsecase {
  final UpdateService _updateService;
  final UpdateRepository _updateRepository;

  new({
    required this._updateService, 
    required this._updateRepository,
  });

  Stream<OperationState<UpdatingStep, UpdateError>> call() async* {
    try {
      yield OperationState.success(.fetching);
      final OperationResult<UpdateEntity, RepositoryError> getLatestUpdateManifestResult = await _updateRepository.getLatestUpdateManifest();

      if(!getLatestUpdateManifestResult.success) {
        yield OperationState.error(.unknown);
        return;
      }

      if(!(await _shouldUpdate(getLatestUpdateManifestResult.data))) {
        return;
      }

      await for(final OperationState<UpdatingStep, UpdateError> state in _updateService.install(getLatestUpdateManifestResult.data)) {
        yield state;
      }
    }catch(_) {
      yield OperationState.error(.unknown);
    }
  }

  Future<bool> _shouldUpdate(UpdateEntity update) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return !kDebugMode && update.build > int.parse(packageInfo.buildNumber);
  } 
}