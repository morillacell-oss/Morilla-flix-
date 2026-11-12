# 🦍 MORILLA FLIX — Cinema aberto, experiência premium

Site responsivo com identidade preta e vermelha, logo de gorila de perfil, interface inspirada em plataformas de streaming e player de vídeos autorizados.

**Produção:** https://morilla-flix-rho.vercel.app  
**GitHub:** https://github.com/morillacell-oss/Morilla-flix-  
**Supabase:** projeto `MorillaFlix`.

## O que funciona

- Catálogo Supabase com 11 títulos (8 filmes e 3 coleções de curtas) e 10 episódios de demonstração.
- Filme completo por MP4 HTTPS ou conteúdo oficial incorporado via YouTube, conforme permissão de exibição.
- Player amplo, controles nativos, voltar/avançar 10s, velocidade, tela cheia, Picture-in-Picture quando disponível, seleção de episódios, retomar de onde parou.
- Botão de reproduzir nas capas de filmes liberados, fileiras com setas no desktop e rolagem por toque no celular, barra de progresso da sessão.
- Perfis locais, favoritos, avaliações pessoais e recomendações simples baseadas no comportamento no mesmo navegador, sem login para visitantes.
- Painel administrativo com **Supabase Auth e RLS** para cadastrar/alterar títulos, temporadas, episódios e patrocínios.
- Integração TMDB **temporária de demonstração não comercial**, com imagens, sinopses, tendências e **trailers oficiais disponíveis via YouTube**, sem oferecer filmes comerciais completos.

## Como assistir

1. Acesse o endereço de produção.
2. No banner ou nas capas identificadas como conteúdo liberado, clique em **Assistir** (triângulo vermelho).
3. No player, use o controle do próprio vídeo, selecione outro episódio ou clique em Tela cheia.
4. Se o provedor externo não responder, o botão **Fonte oficial** abre a página/arquivo original.
5. O ponto de reprodução é salvo **no navegador** (sem sincronização entre dispositivos).

**A disponibilidade dos arquivos MP4/YouTube depende do provedor externo.** Os links diretos de Sintel, Spring, Tears of Steel e Sprite Fright foram substituídos por links do Blender Video; a compatibilidade final precisa ser conferida no navegador do visitante.

## Painel administrativo — falta configurar a conta proprietária

Visitantes **não precisam de login**. O administrador precisa cadastrar uma conta própria.

1. No Supabase, abra: https://supabase.com/dashboard/project/bpipdcbwlllwnvolorfp/auth/users
2. Crie seu usuário com e-mail e senha. Não compartilhe a senha no ChatGPT.
3. Copie seu UUID (User ID) e no [SQL Editor](https://supabase.com/dashboard/project/bpipdcbwlllwnvolorfp/sql/new) execute, substituindo o valor:

```sql
insert into public.admin_users (user_id)
values ('UUID-DA-SUA-CONTA')
on conflict (user_id) do nothing;
```

4. No rodapé do Morilla Flix, clique em **Administração** e use seu e-mail e senha.

O painel só concede escrita a usuários na tabela `admin_users`. RLS protege conteúdo e administradores; **não use** chaves `service_role` no navegador.

## TMDB — API e licenças

A chave v3 do TMDB está armazenada no Vercel em `TMDB_API_KEY` como variável **sensitive**. O modo `TMDB_NONCOMMERCIAL_DEMO=true` permite testar a interface; ele não deve ser usado para monetização.

A chave e o token já foram exibidos em um print na conversa; **substitua-os quando possível**, editando a variável apenas no painel da Vercel: https://vercel.com/iperto/morilla-flix-/settings/environment-variables.

**Importante:** a API gratuita do TMDB permite uso não comercial sob suas condições. Antes de ligar anúncios ou faturar com dados/imagens do TMDB, obtenha licença comercial e direitos pertinentes. O TMDB **não disponibiliza** os filmes comerciais para reprodução. A integração de trailers mostra vídeos do YouTube, não longas-metragens completos.

Manual detalhado: [docs/TMDB.md](docs/TMDB.md).

## Infraestrutura

- Site HTML/CSS/JavaScript no GitHub, entregue pelo Vercel.
- Vercel Function `api/tmdb.js`: proxy da API TMDB, sem expor o token ao navegador.
- Supabase para catálogo, episódios e dados administrativos.
- `localStorage` para dados pessoais por perfil neste dispositivo.
- GitHub Actions `.github/workflows/quality.yml` executa testes Node sem depender de credenciais de produção.

Para rodar os testes localmente:

```bash
node --test tests/*.test.cjs
```

## Limitações e próximos passos

- Não há biblioteca de filmes comerciais sem licenciamento, cobrança, DRM, autenticação de espectadores, nem streaming de vídeo hospedado pelo Morilla Flix.
- Os vídeos são incorporados ou carregados de fontes externas autorizadas e podem ficar indisponíveis.
- Para catálogo comercial com publicidade, obtenha os direitos de conteúdo e licenciamento TMDB; apenas depois ative patrocinadores.
- Ainda falta conferir visualmente e testar reprodução real do player em Android/desktop.
