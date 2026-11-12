# Integração TMDB — Morilla Flix

## Estado atual
A integração está **implementada, mas DESATIVADA**, pois a intenção de monetizar o Morilla Flix com anúncios exige avaliar a licença comercial da The Movie Database. Não configure `TMDB_COMMERCIAL_LICENSED=true` sem a autorização correspondente.

## Licença
O TMDB informa que a API de desenvolvedor é gratuita para projetos **não comerciais**. Projetos cujo objetivo principal é gerar receita devem tratar de licença comercial diretamente com o TMDB:
- https://developer.themoviedb.org/docs/faq
- https://www.themoviedb.org/settings/api
- contato: sales@themoviedb.org

O TMDB fornece **dados, pôsteres e imagens**, NÃO os filmes completos. A autorização para usar o TMDB não concede licença para transmitir obras comerciais.

## Segurança das credenciais
Como a chave e o token foram mostrados em uma captura de tela compartilhada, recomendamos substituí-los no painel TMDB. Não envie novos tokens por chat, prints, Issues ou commits.

Após confirmar a permissão comercial:
1. Abra https://vercel.com/iperto/morilla-flix-/settings/environment-variables
2. Adicione **TMDB_READ_ACCESS_TOKEN** com o token de leitura da API recém-gerado, marcado como **Sensitive**, no ambiente **Production**.
3. Adicione **TMDB_COMMERCIAL_LICENSED** com o valor `true` SOMENTE após obter a autorização comercial; use valor sem aspas.
4. Implante novamente a produção, pois mudanças de env não são retroativas.
5. Verifique `/api/tmdb?category=trending`, `/api/tmdb?category=movies`, `/api/tmdb?category=series` e `/api/tmdb?category=search&q=batman`.

A credencial é usada SOMENTE no servidor Vercel: `api/tmdb.js` não devolve o token ao cliente. Nunca ponha o token em HTML, CSS ou código JavaScript público.

## Atribuição e exposição ao público
Antes da ativação: incluir o **logo oficial aprovado do TMDB** na seção de créditos e o aviso obrigatório: "This product uses the TMDB API but is not endorsed or certified by TMDB." Confira https://www.themoviedb.org/about/logos-attribution

## API interna
- `GET /api/tmdb?category=trending`
- `GET /api/tmdb?category=movies`
- `GET /api/tmdb?category=series`
- `GET /api/tmdb?category=search&q=<nome>`

A resposta é uma lista normalizada de metadados e imagens; não contém vídeo. Enquanto não estiver autorizada, retorna HTTP 503 com `code: LICENSING_REQUIRED`.
