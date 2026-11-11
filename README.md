# MORILLA FLIX
Plataforma de streaming demonstrativa, responsiva e aberta para assistir a vídeos próprios ou licenciados. Identidade preta (#000) com vermelho (#e50914) e gorila de perfil.

## Stack
Site estático (HTML/CSS/JavaScript módulos) conectado ao Supabase por chave **publishable**. GitHub é o código-fonte e Supabase armazena o catálogo.

## Recursos
Catálogo, pesquisa, filtros, filmes e episódios com player HTML5, histórico e continuar assistindo, perfis locais por navegador, avaliações locais, favoritos, recomendações baseadas em preferências, espaço discreto de patrocinadores e painel protegido com Supabase Auth + RLS.

## Configuração
1. Projeto Supabase: `MorillaFlix`. O script de banco encontra-se em `supabase/schema.sql` e já foi aplicado.
2. Para usar o painel, crie um usuário em **Authentication → Users** do Supabase e depois cadastre seu UUID em **SQL Editor**:
   `insert into public.admin_users(user_id) values ('UUID-DO-USUARIO');`
   Somente usuários presentes em `admin_users` podem alterar o catálogo. A senha nunca deve ir ao repositório.
3. Publique como site estático no Vercel: Framework preset **Other**, sem build command, diretório de saída `.`. Não é necessário ambiente de servidor.
4. Adicione conteúdo somente com direitos de exibição. Para MP4/WebM informe uma URL HTTPS direta; para vídeos oficiais autorizados também aceita URLs YouTube.
5. Visitantes não precisam entrar. Os perfis, favoritos, histórico e avaliações são armazenados em `localStorage` (não sincronizam entre aparelhos). O painel usa autenticação apenas de administradores.

## Catálogo demonstrativo
Sintel, Big Buck Bunny, Tears of Steel e Elephants Dream são obras abertas da Blender Foundation, com atribuição exibida nos detalhes. A fonte de vídeo para a demonstração é o bucket de amostras de vídeos do Google. A disponibilidade das URLs públicas depende do provedor de origem; não há hospedagem própria de vídeo.

## Segurança
RLS habilitado em todas as tabelas. `anon` apenas lê títulos/episódios publicados e patrocínios ativos. Escrita reservada a usuários cadastrados em `admin_users`. Somente chave pública de projeto é usada no navegador. Nunca exponha secret/service_role.

## Limitações da primeira versão
Não existe cobrança, gerenciamento de direitos digitais ou sincronização de perfis; anúncios são cards não intrusivos e não há rede de anúncios integrada. Nenhuma reprodução de catálogos comerciais sem licença.
