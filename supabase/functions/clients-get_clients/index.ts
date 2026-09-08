import { withSupabase } from "@supabase/server";
import { HttpStatus } from "../_shared/core/http_status.ts";
import { OperationResult } from "../_shared/core/models/operation_result.ts";
import { ClientsRepository } from "../_shared/features/clients/repositories/clients_repository.ts";
import { ClientsService } from "../_shared/features/clients/services/clients_service.ts";
import { Pagination } from "../_shared/core/repository/query_options.ts";

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    if (req.method !== "GET") return Response.json({}, { status: HttpStatus.methodNotAllowed });

    const parseParamsResult: OperationResult<Pagination, Response> = parseParams(req);
    if (!parseParamsResult.success) return parseParamsResult.error;

    const clientsService: ClientsService = new ClientsService(new ClientsRepository(ctx));
    const getClientsResult = await clientsService.getClients(parseParamsResult.data);

    if (!getClientsResult.success) return Response.json(
      { message: getClientsResult.error.type },
      { status: getClientsResult.error.status }
    );

    return Response.json({
      clients: getClientsResult.data,
      count: getClientsResult.data.length,
    });
  }),
};

function parseParams(req: Request): OperationResult<Pagination, Response> {
  try {
    const url: URL = new URL(req.url);
    const searchParams: URLSearchParams = url.searchParams;

    const limit: number | undefined = searchParams.has("limit") ? Number(searchParams.get("limit")) : undefined;
    const offset: number | undefined = searchParams.has("offset") ? Number(searchParams.get("offset")) : undefined;

    return {
      success: true,
      data: {
        limit: limit,
        offset: offset,
      }
    };
  } catch (_) {
    return {
      success: false,
      error: Response.json({}, {
        status: HttpStatus.badRequest,
      }),
    }
  }
}