
-- Coleções demonstrativas: playlists de filmes abertos, não séries comerciais.
insert into public.titles
(slug,name,description,kind,genre,release_year,duration_minutes,age_rating,poster_url,backdrop_url,video_url,credit,featured,published)
values
('mundos-fantasticos','Mundos Fantásticos','Uma coleção de histórias fantásticas e animações abertas para descobrir e assistir em sequência.','series','Fantasia',2026,35,'L',
 'https://upload.wikimedia.org/wikipedia/commons/2/25/Spring2019AlphaPosterBlender.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/2/25/Spring2019AlphaPosterBlender.jpg',
 null,'Coleção curada Morilla Flix. Obras de Blender Foundation: CC BY 3.0 / 4.0.',false,true),
('futuros-possiveis','Futuros Possíveis','Três visões do futuro em animações de ficção científica produzidas pela Blender Foundation.','series','Ficção científica',2026,29,'12',
 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Charge_-_Blender_Open_Movie-YouTube_thumbnail.jpg',
 'https://upload.wikimedia.org/wikipedia/commons/2/2a/Charge_-_Blender_Open_Movie-YouTube_thumbnail.jpg',
 null,'Coleção curada Morilla Flix. Obras abertas da Blender Foundation. Créditos nos filmes.',false,true)
on conflict(slug) do nothing;

insert into public.episodes(title_id,season_number,episode_number,name,description,duration_minutes,video_url,published)
select t.id,v.s,v.e,v.name,v.description,v.duration,v.url,true
from public.titles t
join (values 
('mundos-fantasticos',1,1,'Sintel','© Blender Foundation, CC BY 3.0',15,'https://storage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
('mundos-fantasticos',1,2,'Spring','© Blender Foundation, CC BY 4.0',8,'https://www.youtube.com/watch?v=WhWc3b3KhnY'),
('mundos-fantasticos',1,3,'Cosmos Laundromat','© Blender Foundation, CC BY 4.0',12,'https://www.youtube.com/watch?v=Y-rmzh0PI3c'),
('futuros-possiveis',1,1,'Charge','© Blender Foundation, CC BY 4.0',4,'https://www.youtube.com/watch?v=UXqq0ZvbOnk'),
('futuros-possiveis',1,2,'Tears of Steel','© Blender Foundation, CC BY 3.0',12,'https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
('futuros-possiveis',1,3,'Elephants Dream','© Blender Foundation, CC BY 2.5',11,'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4')
) v(slug,s,e,name,description,duration,url) on t.slug=v.slug
on conflict(title_id,season_number,episode_number) do nothing;

update public.titles set video_url=replace(video_url,'https://commondatastorage.googleapis.com/gtv-videos-bucket/','https://storage.googleapis.com/gtv-videos-bucket/')
where video_url like 'https://commondatastorage.googleapis.com/gtv-videos-bucket/%';

update public.episodes set video_url=replace(video_url,'https://commondatastorage.googleapis.com/gtv-videos-bucket/','https://storage.googleapis.com/gtv-videos-bucket/')
where video_url like 'https://commondatastorage.googleapis.com/gtv-videos-bucket/%';
