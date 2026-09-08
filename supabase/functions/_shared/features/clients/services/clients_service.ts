import { HttpStatus } from "../../../core/http_status.ts";
import { OperationResult } from "../../../core/models/operation_result.ts";
import { Pagination } from "../../../core/repository/query_options.ts";
import { RepositoryError } from "../../../core/repository/repository_error.ts";
import { ClientEntity } from "../entities/client_entity.ts";
import { ChangePurchaseStatusDTO, ClientsRepository, CreateClientDTO } from "../repositories/clients_repository.ts";

export type ClientError = {
    status: HttpStatus.internalServerError,
    type: "unknown",
} | {
    type: "client_not_found",
    status: HttpStatus.notFound,
} | {
    status: HttpStatus.conflict,
    type: "client_already_exists",
}

export class ClientsService {
    private readonly repository: ClientsRepository;

    public constructor(repository: ClientsRepository) {
        this.repository = repository;
    }

    public async create(data: CreateClientDTO): Promise<OperationResult<Partial<ClientEntity>, ClientError>> {
        const getClientResult: OperationResult<Partial<ClientEntity>, ClientError> = await this.getClient({
            phone: data.phone,
        });
        
        if(getClientResult.success) return {
            success: false,
            error: {
                type: "client_already_exists",
                status: HttpStatus.conflict,
            }
        };
        
        const createResult: OperationResult<Partial<ClientEntity>, RepositoryError> = await this.repository.create(data);

        if (!createResult.success) return {
            success: false,
            error: { type: "unknown", status: HttpStatus.internalServerError }
        };

        return {
            success: true,
            data: createResult.data,
        }
    }

    public async changePurchaseStatus(data: ChangePurchaseStatusDTO): Promise<OperationResult<Partial<ClientEntity>, ClientError>> {
        let getClientResult: OperationResult<Partial<ClientEntity>, ClientError> = await this.getClient({
            uuid: data.client_uuid,
        });

        if(!getClientResult.success) return {
            success: false,
            error: getClientResult.error,
        };

        const updateResult: OperationResult<void, RepositoryError> = await this.repository.changePurchaseStatus(
            data
        );

        if(!updateResult.success) return {
            success: false,
            error: { type: "unknown", status: HttpStatus.internalServerError }
        };

        getClientResult = await this.getClient({
            uuid: data.client_uuid,
        });

        if(!getClientResult.success) return {
            success: false,
            error: getClientResult.error,
        };

        return {
            success: true,
            data: getClientResult.data,
        };
    }

    public async getClients(pagination?: Pagination): Promise<OperationResult<Partial<ClientEntity>[], ClientError>> {
        const result: OperationResult<Partial<ClientEntity>[], RepositoryError> = await this.repository.getAll(pagination);

        if (!result.success) return {
            success: false,
            error: { type: "unknown", status: HttpStatus.internalServerError }
        };

        return {
            success: true,
            data: result.data,
        };
    }

    public async getClient(data: Partial<ClientEntity>): Promise<OperationResult<Partial<ClientEntity>, ClientError>> {
        const result = await this.repository.getClient(data);

        if(!result.success) return {
            success: false,
            error: {
                type: "client_not_found",
                status: HttpStatus.notFound,
            }
        };

        return {
            success: true,
            data: result.data
        };
    }
}