/*
 * Morilla Flix • conector TMDB (metadados e imagens, SEM fontes de vídeo).
 * ATIVAÇÃO: exige licença comercial do TMDB, depois configurar no Vercel:
 * TMDB_READ_ACCESS_TOKEN (sensitive) e TMDB_COMMERCIAL_LICENSED=true.
 * O token nunca é enviado ao navegador e o endpoint é desabilitado por padrão.
 */
const endpoints = Object.freeze({
  trending: "/3/trending/all/week",
  movies: "/3/movie/popular",
  series: "/3/tv/popular",
  search: "/3/search/multi"
});

module.exports = async function handler(req, res) {
  res.setHeader("X-Content-Type-Options", "nosniff");
  res.setHeader("Vary", "Accept-Encoding");

  if (req.method !== "GET") {
    res.setHeader("Allow", "GET");
    return res.status(405).json({ error: "Método não permitido." });
  }

  if (process.env.TMDB_COMMERCIAL_LICENSED !== "true") {
    res.setHeader("Cache-Control", "no-store");
    return res.status(503).json({
      enabled: false,
      code: "LICENSING_REQUIRED",
      message: "A integração de catálogo TMDB aguarda autorização comercial."
    });
  }

  const token = process.env.TMDB_READ_ACCESS_TOKEN || "";
  if (!token || token.length < 20) {
    res.setHeader("Cache-Control", "no-store");
    return res.status(503).json({
      enabled: false,
      code: "CREDENTIAL_NOT_CONFIGURED",
      message: "Configure o token TMDB no ambiente protegido da Vercel."
    });
  }

  const category = typeof req.query.category === "string" ? req.query.category : "trending";
  const endpoint = endpoints[category];
  if (!endpoint) return res.status(400).json({ error: "Categoria inválida." });

  const query = typeof req.query.q === "string" ? req.query.q.trim().slice(0, 80) : "";
  if (category === "search" && query.length < 2) {
    return res.status(400).json({ error: "Informe ao menos dois caracteres." });
  }

  const target = new URL("https://api.themoviedb.org" + endpoint);
  target.searchParams.set("language", "pt-BR");
  target.searchParams.set("page", "1");
  if (category === "search") {
    target.searchParams.set("query", query);
    target.searchParams.set("include_adult", "false");
  }

  try {
    const upstream = await fetch(target, {
      headers: {
        Authorization: "Bearer " + token,
        Accept: "application/json"
      },
      signal: AbortSignal.timeout(8500)
    });

    if (!upstream.ok) {
      res.setHeader("Cache-Control", "no-store");
      return res.status(upstream.status === 429 ? 429 : 502).json({
        error: upstream.status === 429
          ? "Limite temporário do catálogo atingido."
          : "O serviço de catálogo está indisponível."
      });
    }

    const json = await upstream.json();
    const results = (Array.isArray(json.results) ? json.results : [])
      .filter(item => (item.media_type || (category === "series" ? "tv" : "movie")) !== "person")
      .slice(0, 20).map(item => ({
        id: Number(item.id) || 0,
        media_type: item.media_type === "tv" || (category === "series") ? "tv" : "movie",
        title: String(item.title || item.name || "").slice(0, 170),
        description: String(item.overview || "").slice(0, 1100),
        release_date: String(item.release_date || item.first_air_date || "").slice(0, 10),
        poster_path: typeof item.poster_path === "string" && /^\/[\w.-]+\.(?:jpg|png|webp)$/.test(item.poster_path) ? item.poster_path : null,
        backdrop_path: typeof item.backdrop_path === "string" && /^\/[\w.-]+\.(?:jpg|png|webp)$/.test(item.backdrop_path) ? item.backdrop_path : null,
        vote_average: Number(item.vote_average) || 0
      })).filter(item => item.id > 0 && item.title && (item.poster_path || item.backdrop_path));

    res.setHeader("Cache-Control", "public, s-maxage=900, stale-while-revalidate=600");
    res.status(200).json({
      enabled: true,
      provider: "TMDB",
      note: "Somente informações e imagens; nenhuma licença de reprodução de vídeo.",
      results
    });
  } catch (err) {
    console.error("Erro de consulta TMDB:", err?.name || "unknown");
    res.setHeader("Cache-Control", "no-store");
    return res.status(502).json({ error: "Não foi possível consultar o catálogo agora." });
  }
};
