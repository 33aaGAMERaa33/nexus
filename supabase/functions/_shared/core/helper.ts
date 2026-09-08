import { PurchaseStatus } from "../features/clients/entities/client_entity.ts";
import { Constants } from "./types.ts";

export function isPurchaseStatus(value: string): value is PurchaseStatus {
  return Constants.public.Enums.purchase_status.includes(value as PurchaseStatus);
}