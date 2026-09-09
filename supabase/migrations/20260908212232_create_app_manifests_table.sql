create table public.app_manifests(
    id int generated always as identity primary key,

    version text not null,
    build int unique not null,

    sha256 text not null,
    download_url text not null,
    
    created_at timestamptz not null default now()
);