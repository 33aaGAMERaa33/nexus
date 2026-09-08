import { PURCHASE_STATUS_VALUES, PurchaseStatus } from "../features/clients/entities/client_entity.ts";

export function isPurchaseStatus(value: string): value is PurchaseStatus {
  return PURCHASE_STATUS_VALUES.includes(value);
}