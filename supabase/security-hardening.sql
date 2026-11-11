-- Restringir função interna de trigger de evento existente no projeto.
-- Esta rotina deve ser executada apenas pelo PostgreSQL ao criar tabelas.
revoke execute on function public.rls_auto_enable() from public, anon, authenticated;
