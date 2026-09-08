export type PurchaseStatus = "purchased" | "no_response" | "not_purchased";

export interface ClientEntity {
    id: number;
    uuid: string;

    name: string;
    phone: string;
    purchase_status: PurchaseStatus;

    created_at: Date;
    updated_at: Date;
}