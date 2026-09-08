create table public.clients(
    id int generated always as identity primary key,
    uuid uuid unique not null default gen_random_uuid(),

    name varchar(256) not null,
    phone varchar(256) unique not null,
    purchase_status public.purchase_status not null,

    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.reported_errors(
    id int generated always as identity primary key,

    message text not null,
    stack_trace text not null,

    reported_at timestamptz not null default now()
);