import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/report/domain/repositories/report_repository.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseReportRepository implements ReportRepository {
  late final SupabaseClient _supabaseClient = getter();

  @override
  Future<OperationResult<void, ReportError>> report(ReportErrorDTO dto) async {
    try {
      await _supabaseClient.auth.signOut();
      return OperationResult.success(null);
    }catch(e) {
      return OperationResult.error(.unknown);
    }
  }
}