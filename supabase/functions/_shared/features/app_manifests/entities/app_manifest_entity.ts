export interface AppManifestEntity {
    id: number;

    build: number;
    version: string;

    sha256: string;
    download_url: string;

    created_at: Date;
}