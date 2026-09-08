create type public.purchase_status as enum(
    'pending',
    'purchased',
    'no_response',
    'not_purchased'
);

create table public.clients(
    id int generated always as identity primary key,
    uuid uuid unique not null default gen_random_uuid(),

    name varchar(256) not null,
    phone varchar(256) unique not null,
    purchase_status public.purchase_status not null,

    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create trigger clients_updated_at
before update on public.clients
for each row
execute function update_updated_at_column();