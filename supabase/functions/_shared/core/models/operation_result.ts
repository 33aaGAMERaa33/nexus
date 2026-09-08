export type OperationResult<TData, TError> = {
    success: true;
    data: TData;
} | {
    success: false;
    error: TError;
};