
-- Morilla Flix: pôsteres e cenas provenientes de filmes abertos da Blender Foundation.
-- Crédito e licença preservados nos registros; não são títulos de Hollywood sem autorização.
update public.titles set
 poster_url='https://upload.wikimedia.org/wikipedia/commons/8/8f/Sintel_poster.jpg',
 backdrop_url='https://upload.wikimedia.org/wikipedia/commons/b/b6/Sintel-screenshot-4.jpg',
 credit='© Blender Foundation / Sintel.org — CC BY 3.0. Arte: https://commons.wikimedia.org/wiki/File:Sintel_poster.jpg',
 featured=false, updated_at=now()
where slug='sintel';

update public.titles set
 poster_url='https://upload.wikimedia.org/wikipedia/commons/7/70/Tos-poster.png',
 backdrop_url='https://upload.wikimedia.org/wikipedia/commons/7/70/Tos-poster.png',
 credit='© Blender Foundation — CC BY 3.0. Pôster: https://commons.wikimedia.org/wiki/File:Tos-poster.png',
 featured=false, updated_at=now()
where slug='tears-of-steel';

update public.titles set
 poster_url='https://upload.wikimedia.org/wikipedia/commons/c/c5/Big_buck_bunny_poster_big.jpg',
 backdrop_url='https://upload.wikimedia.org/wikipedia/commons/c/c5/Big_buck_bunny_poster_big.jpg',
 credit='© Blender Foundation | www.bigbuckbunny.org — CC BY 3.0',
 updated_at=now()
where slug='big-buck-bunny';

update public.titles set
 poster_url='https://upload.wikimedia.org/wikipedia/commons/0/0c/ElephantsDreamPoster.jpg',
 backdrop_url='https://upload.wikimedia.org/wikipedia/commons/0/0c/ElephantsDreamPoster.jpg',
 credit='© Blender Foundation — CC BY 4.0. Pôster: Wikimedia Commons',
 updated_at=now()
where slug='elephants-dream';

update public.titles set
 poster_url='https://upload.wikimedia.org/wikipedia/commons/c/c5/CosmosLaundromatPoster.jpg',
 backdrop_url='https://upload.wikimedia.org/wikipedia/commons/c/c5/CosmosLaundromatPoster.jpg',
 credit='© Blender Foundation / cloud.blender.org — CC BY 4.0. Pôster: Wikimedia Commons',
 updated_at=now()
where slug='colecao-cinema-aberto';

insert into public.titles
(slug,name,description,kind,genre,release_year,duration_minutes,age_rating,poster_url,backdrop_url,video_url,credit,featured,published)
values
('charge','CHARGE','Em um futuro onde a energia é escassa, um homem invade uma fábrica e enfrenta um androide letal. Uma ficção científica de tirar o fôlego.','movie','Ficção científica',2022,4,'12',
 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Charge_-_Blender_Open_Movie-YouTube_thumbnail.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Charge_-_Blender_Open_Movie-YouTube_thumbnail.jpg',
 'https://www.youtube.com/watch?v=UXqq0ZvbOnk',
 '© Blender Foundation / Blender Studio — curta aberto, atribuição CC BY. Reprodução pelo canal oficial.',true,true),
('spring','Spring','Uma garota e seu cachorro enfrentam antigos espíritos em uma aventura poética e visualmente deslumbrante.','movie','Fantasia',2019,8,'L',
 'https://upload.wikimedia.org/wikipedia/commons/2/25/Spring2019AlphaPosterBlender.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/2/25/Spring2019AlphaPosterBlender.jpg',
 'https://www.youtube.com/watch?v=WhWc3b3KhnY',
 '© Blender Foundation — CC BY 4.0. Cartaz: Wikimedia Commons / Blender Studio.',false,true),
('cosmos-laundromat','Cosmos Laundromat','Um curta surreal e inesquecível sobre escolhas, destino e um estranho visitante em uma ilha deserta.','movie','Fantasia',2015,12,'12',
 'https://upload.wikimedia.org/wikipedia/commons/c/c5/CosmosLaundromatPoster.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/c/c5/CosmosLaundromatPoster.jpg',
 'https://www.youtube.com/watch?v=Y-rmzh0PI3c',
 '© Blender Foundation / cloud.blender.org — CC BY 4.0. Cartaz: Wikimedia Commons.',false,true),
('sprite-fright','Sprite Fright','Adolescentes exploram uma floresta mágica e descobrem pequenos habitantes muito menos inocentes do que parecem.','movie','Animação',2021,11,'12',
 'https://i.ytimg.com/vi/_cMxraX_5RE/hqdefault.jpg',
 'https://i.ytimg.com/vi/_cMxraX_5RE/maxresdefault.jpg',
 'https://www.youtube.com/watch?v=_cMxraX_5RE',
 '© Blender Foundation / Blender Studio — CC BY 4.0. Reprodução pelo canal oficial.',false,true)
on conflict (slug) do update set 
name=excluded.name,description=excluded.description,kind=excluded.kind,genre=excluded.genre,
release_year=excluded.release_year,duration_minutes=excluded.duration_minutes,age_rating=excluded.age_rating,
poster_url=excluded.poster_url,backdrop_url=excluded.backdrop_url,video_url=excluded.video_url,
credit=excluded.credit,featured=excluded.featured,published=excluded.published,updated_at=now();
