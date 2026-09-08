import 'package:nexus/core/models/operation_result.dart';

enum ReportError {
  unknown,
}

class ReportErrorDTO {
  final String message;
  final StackTrace stackTrace;

  const new({required this.message, required this.stackTrace});
}

abstract interface class ReportRepository {
  Future<OperationResult<void, ReportError>> report(ReportErrorDTO dto);
}