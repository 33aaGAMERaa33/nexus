create trigger clients_updated_at
before update on public.clients
for each row
execute function update_updated_at_column();