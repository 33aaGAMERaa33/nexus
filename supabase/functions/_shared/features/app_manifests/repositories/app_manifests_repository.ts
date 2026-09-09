import { SupabaseContext } from "@supabase/server";
import { Database } from "../../../core/types.ts";
import { OperationResult } from "../../../core/models/operation_result.ts";
import { AppManifestEntity } from "../entities/app_manifest_entity.ts";
import { RepositoryError } from "../../../core/repository/repository_error.ts";

export class AppManifestsRepository {
    private readonly context: SupabaseContext<Database>;

    public constructor(context: SupabaseContext<Database>) {
        this.context = context;
    }

    public async getLatestManifest(): Promise<OperationResult<Partial<AppManifestEntity>, RepositoryError>> {
        const result = await this.context.supabase.from("app_manifests").select(
            "build, version, sha256, download_url, created_at",
        ).limit(1).order("created_at", {ascending: true});

        if(!result.success) return {
            success: false,
            error: "unknown",
        };

        return {
            success: true,
            data: {
                ...result.data[0],
                created_at: new Date(result.data[0].created_at),
            }
        };
    }
}