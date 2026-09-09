import 'dart:io';
import 'dart:typed_data';

import 'package:android_package_installer/android_package_installer.dart';
import 'package:flutter/services.dart';
import 'package:nexus/core/models/operation_state.dart';
import 'package:nexus/core/models/progress.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';
import 'package:nexus/features/update/domain/services/update_service.dart';
import 'package:path_provider/path_provider.dart';

class FakeUpdateService implements UpdateService {
  @override
  Stream<OperationState<UpdatingStep, UpdateError>> install(UpdateEntity update) async* {
    final ByteData data = await rootBundle.load("assets/update.apk");

    final String filePath = "${(await getTemporaryDirectory()).path}/${update.version}-${update.build}.apk";
    final File file = File(filePath);

    try {
      yield OperationState.success(.downloading);
      await file.writeAsBytes(data.buffer.asInt8List());

      for(int i = 0; i <= 100; i += 10) {
        yield OperationState.success(.downloading, Progress(count: i, total: 100));  
        await Future.delayed(const Duration(milliseconds: 100));
      }

      yield OperationState.success(.installing);
      final int ? statusCode = await AndroidPackageInstaller.installApk(apkFilePath: filePath);
      final PackageInstallerStatus installerStatus = statusCode == null ? .unknown : PackageInstallerStatus.byCode(statusCode);

      if(installerStatus != .success) {
        switch(installerStatus) {
          case .failure:
          case .failureInvalid:
          case .failureStorage:
          case .failureBlocked:
          case .failureIncompatible:
            yield OperationState<UpdatingStep, UpdateError>.error(.failure);
            return;
        
          case .unknown:
          default: 
            yield OperationState<UpdatingStep, UpdateError>.error(.unknown);
            return;
        }
      }
    }finally {
      try {
        if(await file.exists()) {
          await file.delete();
        }
      }catch(_) {

      }
    }
  }
}