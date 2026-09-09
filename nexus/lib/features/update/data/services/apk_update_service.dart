import 'dart:async';
import 'dart:io';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:dio/dio.dart';
import 'package:nexus/core/models/operation_state.dart';
import 'package:nexus/core/models/progress.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';
import 'package:nexus/features/update/domain/services/update_service.dart';
import 'package:path_provider/path_provider.dart';

class ApkUpdateService implements UpdateService {
  final Dio _dio;
  const new(this._dio);

  @override
  Stream<OperationState<UpdatingStep, UpdateError>> install(UpdateEntity update) {
    final StreamController<OperationState<UpdatingStep, UpdateError>> streamController = StreamController();

    Future(() async {
      final String filePath = "${(await getTemporaryDirectory()).path}/${update.version}-${update.build}.apk";
      final File file = File(filePath);

      try {
        streamController.add(OperationState.success(.downloading));

        await _dio.download(update.downloadUrl, filePath, onReceiveProgress: (count, total) {
          streamController.add(OperationState.success(
            .downloading, Progress(count: count, total: total),
          ));
        });

        streamController.add(OperationState.success(.installing));
        final int ? statusCode = await AndroidPackageInstaller.installApk(apkFilePath: filePath);
        final PackageInstallerStatus installerStatus = statusCode == null ? .unknown : PackageInstallerStatus.byCode(statusCode);

        if(installerStatus != .success) {
          switch(installerStatus) {
            case .failure:
            case .failureInvalid:
            case .failureStorage:
            case .failureBlocked:
            case .failureIncompatible:
              streamController.add(OperationState<UpdatingStep, UpdateError>.error(.failure));
              return;
          
            case .unknown:
            default: 
              streamController.add(OperationState<UpdatingStep, UpdateError>.error(.unknown));
              return;
          }
        }
      }catch(e) {
        streamController.add(OperationState.error(.unknown));
      }finally {
        try {
          if(await file.exists()) {
            await file.delete();
          }
        }catch(_) {

        }

        await streamController.close();
      }
    });

    return streamController.stream;
  }
}