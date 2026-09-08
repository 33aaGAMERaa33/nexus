create type public.purchase_status as enum(
    'purchased',
    'no_response',
    'not_purchased'
);