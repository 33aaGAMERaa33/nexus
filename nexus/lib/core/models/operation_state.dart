import 'package:nexus/core/models/progress.dart';

class OperationState<TData, TError> {
  final bool success;
  final TData ? _data;
  final TError ? _error;
  final Progress ? progress;

  TData get data => _data!;
  TError get error => _error!;

  const OperationState.error(TError this._error) : success = false, _data = null, progress = null;
  const OperationState.success(TData this._data, [this.progress]) : success = true, _error = null;
}
