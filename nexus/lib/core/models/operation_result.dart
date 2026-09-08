class OperationResult<TData, TError> {
  final bool success;
  final TData ? _data;
  final TError ? _error;
  final Object ? details;

  TData get data => _data!;
  TError get error => _error!;

  const OperationResult.error(TError this._error, [this.details]) : _data = null, success = false;
  const OperationResult.success(TData this._data) : _error = null, details = null, success = true;
}
