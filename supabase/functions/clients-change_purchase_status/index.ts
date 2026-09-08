import { withSupabase } from "@supabase/server";
import { HttpStatus } from "../_shared/core/http_status.ts";
import { OperationResult } from "../_shared/core/models/operation_result.ts";
import { ChangePurchaseStatusDTO, ClientsRepository } from "../_shared/features/clients/repositories/clients_repository.ts";
import { isPurchaseStatus } from "../_shared/core/helper.ts";
import { ClientError, ClientsService } from "../_shared/features/clients/services/clients_service.ts";
import { ClientEntity } from "../_shared/features/clients/entities/client_entity.ts";

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    if (req.method !== "PATCH") return Response.json({}, { status: HttpStatus.methodNotAllowed });

    const validationResult: OperationResult<ChangePurchaseStatusDTO, Response> = await validateBody(req);
    if (!validationResult.success) return validationResult.error;

    const clientsService: ClientsService = new ClientsService(new ClientsRepository(ctx));
    const changeResult: OperationResult<Partial<ClientEntity>, ClientError> = await clientsService.changePurchaseStatus(validationResult.data);

    if (!changeResult.success) return Response.json(
      { message: changeResult.error.type },
      { status: changeResult.error.status },
    );

    return Response.json(changeResult.data);
  }),
};

async function validateBody(req: Request): Promise<OperationResult<ChangePurchaseStatusDTO, Response>> {
  try {
    const body: ChangePurchaseStatusDTO = await req.json();

    if (!isPurchaseStatus(body.purchase_status)) return {
      success: false,
      error: Response.json(
        { message: "invalid purchase status" },
        { status: HttpStatus.badRequest }
      ),
    };

    return {
      success: true,
      data: body,
    };
  } catch (_) {
    return {
      success: false,
      error: Response.json({}, { status: HttpStatus.badRequest }),
    };
  }
}