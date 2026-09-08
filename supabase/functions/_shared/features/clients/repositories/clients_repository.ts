import { SupabaseContext } from "@supabase/server";
import { OperationResult } from "../../../core/models/operation_result.ts";
import { ClientEntity, PurchaseStatus } from "../entities/client_entity.ts";
import { Database } from "../../../core/types.ts";
import { RepositoryError } from "../../../core/repository/repository_error.ts";
import { Pagination } from "../../../core/repository/query_options.ts";

export interface CreateClientDTO {
    name: string;
    phone: string;
    purchase_status: PurchaseStatus;
}

export interface ChangePurchaseStatusDTO {
  client_uuid: string;
  purchase_status: PurchaseStatus;
}

export class ClientsRepository {
  private readonly context: SupabaseContext<Database>;

  public constructor(context: SupabaseContext<Database>) {
    this.context = context;
  }

  async create(data: CreateClientDTO): Promise<OperationResult<Partial<ClientEntity>, RepositoryError>> {
    const createResult = await this.context.supabase.from("clients").insert(data);

    if(!createResult.success) return {
      success: false,
      error: "unknown",
    };

    const getClientResult: OperationResult<Partial<ClientEntity>, RepositoryError> = await this.getClient({
      phone: data.phone,
    });

    if(!getClientResult.success) return {
      success: false,
      error: getClientResult.error,
    };

    return {
      success: true,
      data: getClientResult.data!,
    };
  }
  
  async changePurchaseStatus(data: ChangePurchaseStatusDTO): Promise<OperationResult<void, RepositoryError>> {
    const result = await this.context.supabase.from("clients").update({
      purchase_status: data.purchase_status,
    }).eq("uuid", data.client_uuid);

    if(!result.success) return {
      success: false,
      error: "unknown",
    };

    return {
      success: true,
      data: undefined
    };
  }

  async getClient(data: Partial<ClientEntity>): Promise<OperationResult<Partial<ClientEntity>, RepositoryError>> {
    let queryBuilder = this.context.supabase.from("clients").select(
      "uuid, name, phone, purchase_status, created_at, updated_at",
    ).limit(1);
    
    for(const [field, value] of Object.entries(data)) {
      if(value === undefined) continue;
      queryBuilder = queryBuilder.eq(field, value);
    }

    const result = await queryBuilder;

    if(!result.success) return {
      success: false,
      error: "unknown",
    };

    if(result.data.length < 1) return {
      success: false,
      error: "not_found",
    };

    return {
      success: true,
      data: {
        ...result.data[0],
        created_at: new Date(result.data[0].created_at),
        updated_at: new Date(result.data[0].updated_at),
      },
    }
  }

  async getAll(pagination?: Pagination): Promise<OperationResult<Partial<ClientEntity>[], RepositoryError>> {
    const queryBuilder = this.context.supabase.from("clients").select(
      "uuid, name, phone, purchase_status, created_at, updated_at",
    ).order("purchase_status", {ascending: true});

    const limit: number = pagination!.limit ?? 0;
    const offset: number = pagination!.offset ?? 0;
    
    if(pagination !== undefined) queryBuilder.range(
      offset, offset + limit
    );
    
    const result = await queryBuilder;
    
    console.log(pagination!.offset ?? 0);
    console.log(pagination!.limit ?? 99);
    
    if(!result.success) return {
      success: false,
      error: "unknown",
    };

    return {
      success: true,
      data: result.data!.map((value) => {
        return {
          ...value,

          created_at: new Date(value.created_at),
          updated_at: new Date(value.updated_at),
        };
      }),
    };
  }
}