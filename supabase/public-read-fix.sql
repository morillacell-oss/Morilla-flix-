-- Necessário porque as políticas de SELECT do catálogo consultam admin_users.
-- A RLS dessa tabela continua ocultando as linhas de administradores para visitantes anônimos.
grant select on public.admin_users to anon;
