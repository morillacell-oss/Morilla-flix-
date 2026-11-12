# TMDB no Morilla Flix

## Estado — 11/11/2026
A integração usa um **servidor de API** em `api/tmdb.js`, e não expõe a credencial ao navegador. A credencial v3 fornecida pelo proprietário foi cadastrada no Vercel como variável **sensitive** `TMDB_API_KEY`. A opção temporária `TMDB_NONCOMMERCIAL_DEMO=true` permite mostrar pôsteres e informações para demonstrar a interface **sem monetização**.

A integração do TMDB **não** disponibiliza vídeos completos. As fichas TMDB mostram botão "Informações"; apenas títulos com links autorizados no Supabase podem mostrar "Assistir".

## Antes de monetizar
A API de desenvolvedor do TMDB é gratuita para fins não comerciais com atribuição. A documentação oficial considera comercial o projeto cujo objetivo principal seja gerar receita. **Para ativar anúncios ou lançar o produto comercialmente, obtenha uma licença do TMDB ou desative a integração**.

- FAQ: https://developer.themoviedb.org/docs/faq
- Contato comercial: sales@themoviedb.org (informar Brasil)
- Atribuição: https://www.themoviedb.org/about/logos-attribution

O modo de demonstração impede a renderização de anúncios na home com o catálogo TMDB ativo. Isso não substitui uma autorização de uso comercial.

## Segurança da credencial
A captura de tela enviada no chat mostrou a chave e o token. É recomendável **substituir ambos** quando possível. Não compartilhe novas credenciais em chat, repositórios ou screenshots.

Após a rotação, edite a chave **somente no painel de Environment Variables da Vercel**:
https://vercel.com/iperto/morilla-flix-/settings/environment-variables

- `TMDB_API_KEY`: chave v3 de 32 dígitos hexadecimais (sensitive), apenas lado servidor;
- `TMDB_READ_ACCESS_TOKEN`: alternativa bearer (sensitive), nunca expor no frontend. Se definida, tem prioridade sobre a chave v3;
- `TMDB_NONCOMMERCIAL_DEMO=true`: apenas para protótipos que não monetizam;
- `TMDB_COMMERCIAL_LICENSED=true`: apenas após obter licença comercial válida. Não deixe nenhum modo ativado ao retirar o direito de uso.

Depois de alterar valores, é necessário fazer novo deploy para carregar as variáveis. **Não coloque chaves no código GitHub.**

## Endpoints
- `GET /api/tmdb?category=trending`
- `GET /api/tmdb?category=movies`
- `GET /api/tmdb?category=series`
- `GET /api/tmdb?category=search&q=nome`

Todos os retornos são dados normalizados, sem credenciais. Quando desativado, o servidor retorna HTTP 503 com o código `LICENSING_REQUIRED`.

## Testes
O código da função foi testado com dados simulados para: modo desativado, modo demonstração, normalização da lista, exclusão de pessoas do resultado, ocultação da chave na resposta e categoria inválida. O deploy automático GitHub/Vercel é acompanhado separadamente. A visualização no navegador real e resposta externa do TMDB dependem de uma consulta de rede ao site publicado.
