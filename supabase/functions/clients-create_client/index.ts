import { withSupabase } from "@supabase/server";
import { HttpStatus } from "../_shared/core/http_status.ts";
import { OperationResult } from "../_shared/core/models/operation_result.ts";
import { ClientsRepository, CreateClientDTO } from "../_shared/features/clients/repositories/clients_repository.ts";
import { isPurchaseStatus } from "../_shared/core/helper.ts";
import { ClientError, ClientsService } from "../_shared/features/clients/services/clients_service.ts";
import { ClientEntity } from "../_shared/features/clients/entities/client_entity.ts";

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    if (req.method !== "POST") return Response.json({}, { status: HttpStatus.methodNotAllowed });

    const validationResult: OperationResult<CreateClientDTO, Response> = await validateBody(req);
    if (!validationResult.success) return validationResult.error;

    const clientsService: ClientsService = new ClientsService(new ClientsRepository(ctx));
    const createResult: OperationResult<Partial<ClientEntity>, ClientError> = await clientsService.create(validationResult.data);

    if (!createResult.success) return Response.json(
      { message: createResult.error.type }, { status: createResult.error.status }
    );

    return Response.json(createResult.data);
  }),
};

async function validateBody(req: Request): Promise<OperationResult<CreateClientDTO, Response>> {
  try {
    const data: CreateClientDTO = await req.json();
    const phoneOnlyNumbers = data.phone.replace(/[^0-9]/g, "");

    if (data.name.length < 3 || data.name.length > 256) return {
      success: false,
      error: Response.json(
        { message: "invalid name length" }, { status: HttpStatus.badRequest }
      ),
    };

    if (phoneOnlyNumbers.length < 10 || phoneOnlyNumbers.length > 11) return {
      success: false,
      error: Response.json(
        { message: "invalid phone length" }, { status: HttpStatus.badRequest }
      ),
    };

    if (!isPurchaseStatus(data.purchase_status)) return {
      success: false,
      error: Response.json({ message: "invalid purchase status" }, { status: HttpStatus.badRequest }),
    };

    return {
      success: true,
      data: data,
    }
  } catch (_) {
    return {
      success: false,
      error: Response.json({}, { status: HttpStatus.badRequest }),
    }
  }
}