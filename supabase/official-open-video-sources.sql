-- Fontes de MP4 do catálogo aberto divulgadas no Blender Video, plataforma oficial da Blender Foundation.
-- Verificar disponibilidade e direitos antes de substituir/adicionar outras fontes.

update public.titles set video_url =
 case slug
 when 'sintel' then 'https://video.blender.org/static/webseed/0eb052d0-fd51-43e6-aa33-ecdbf77a5d40-720.mp4'
 when 'tears-of-steel' then 'https://video.blender.org/static/webseed/8533ea43-4271-4a57-9694-e9d0b35e1aa1-720.mp4'
 when 'spring' then 'https://video.blender.org/static/webseed/3d95fb3d-c866-42c8-9db1-fe82f48ccb95-720.mp4'
 when 'sprite-fright' then 'https://video.blender.org/download/videos/a69d68a5-a0e0-4a80-9d66-49f093c97aaf-720.mp4'
 else video_url end,
 updated_at=now()
where slug in ('sintel','tears-of-steel','spring','sprite-fright');
update public.episodes set video_url =
 case
 when name='Sintel' then 'https://video.blender.org/static/webseed/0eb052d0-fd51-43e6-aa33-ecdbf77a5d40-720.mp4'
 when name='Tears of Steel' then 'https://video.blender.org/static/webseed/8533ea43-4271-4a57-9694-e9d0b35e1aa1-720.mp4'
 when name='Spring' then 'https://video.blender.org/static/webseed/3d95fb3d-c866-42c8-9db1-fe82f48ccb95-720.mp4'
 else video_url end
where name in ('Sintel','Tears of Steel','Spring');
select slug, name, video_url from public.titles where slug in ('sintel','tears-of-steel','spring','sprite-fright') order by slug;
