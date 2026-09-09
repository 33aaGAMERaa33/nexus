import 'package:nexus/core/models/operation_state.dart';
import 'package:nexus/features/update/domain/entities/update_entity.dart';

enum UpdatingStep {
  fetching("Buscando atualizações"),
  downloading("Baixando atualizações"),
  installing("Instalando atualizações");

  final String translate;
  const new(this.translate);
}

enum UpdateError {
  unknown("Desconhecido"),
  failureByUser("Atualização cancelada"),
  failure("Não foi possivel atualizar o aplicativo");

  final String translate;
  const new(this.translate);
}

abstract interface class UpdateService {
  Stream<OperationState<UpdatingStep, UpdateError>> install(UpdateEntity update);
}