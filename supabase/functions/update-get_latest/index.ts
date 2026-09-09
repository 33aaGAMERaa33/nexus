import "@supabase/functions-js/edge-runtime.d.ts";
import { withSupabase } from "@supabase/server";
import { HttpStatus } from "../_shared/core/http_status.ts";
import { AppManifestsRepository } from "../_shared/features/app_manifests/repositories/app_manifests_repository.ts";
import { OperationResult } from "../_shared/core/models/operation_result.ts";
import { RepositoryError } from "../_shared/core/repository/repository_error.ts";
import { AppManifestEntity } from "../_shared/features/app_manifests/entities/app_manifest_entity.ts";

export default {
  fetch: withSupabase({ auth: "user" }, async (req, ctx) => {
    if(req.method !== "GET") return Response.json({}, {status: HttpStatus.methodNotAllowed});

    const appManifestsRepository: AppManifestsRepository = new AppManifestsRepository(ctx);
    const getLatestManifestResult: OperationResult<Partial<AppManifestEntity>, RepositoryError> = await appManifestsRepository.getLatestManifest();

    if(!getLatestManifestResult.success) return Response.json(
      getLatestManifestResult.error, {status: HttpStatus.internalServerError}
    );

    return Response.json(getLatestManifestResult.data);
  }),
};