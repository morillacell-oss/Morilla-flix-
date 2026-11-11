
-- Morilla Flix • primeira versão. Vídeos demonstrativos abertos (Blender Foundation).
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.titles (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9-]+$'),
  name text not null check (char_length(name) between 1 and 160),
  description text not null default '',
  kind text not null default 'movie' check (kind in ('movie','series')),
  genre text not null default 'Drama',
  release_year int check (release_year between 1888 and 2200),
  duration_minutes int check (duration_minutes is null or duration_minutes > 0),
  age_rating text not null default 'L',
  poster_url text,
  backdrop_url text,
  video_url text,
  credit text not null default '',
  featured boolean not null default false,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.episodes (
  id uuid primary key default gen_random_uuid(),
  title_id uuid not null references public.titles(id) on delete cascade,
  season_number int not null default 1 check (season_number > 0),
  episode_number int not null check (episode_number > 0),
  name text not null,
  description text not null default '',
  duration_minutes int,
  video_url text,
  published boolean not null default true,
  unique(title_id, season_number, episode_number)
);

create table if not exists public.sponsors (
  id uuid primary key default gen_random_uuid(),
  heading text not null,
  description text not null default '',
  destination_url text,
  is_active boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists titles_filter_idx on public.titles(published,kind,featured);
create index if not exists episodes_title_idx on public.episodes(title_id,season_number,episode_number);
create index if not exists sponsors_active_idx on public.sponsors(is_active);

alter table public.admin_users enable row level security;
alter table public.titles enable row level security;
alter table public.episodes enable row level security;
alter table public.sponsors enable row level security;

revoke all on public.admin_users, public.titles, public.episodes, public.sponsors from anon, authenticated;
grant select on public.titles, public.episodes, public.sponsors to anon, authenticated;
grant insert, update, delete on public.titles, public.episodes, public.sponsors to authenticated;
grant select on public.admin_users to authenticated;

create policy "admin users see own membership" on public.admin_users
  for select to authenticated using (user_id = (select auth.uid()));

create policy "visitors can see published titles" on public.titles
  for select to anon, authenticated using (
    published = true or exists(select 1 from public.admin_users a where a.user_id = (select auth.uid()))
  );
create policy "admins manage titles" on public.titles
  for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())))
  with check (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())));

create policy "visitors can see published episodes" on public.episodes
  for select to anon, authenticated using (
    (published = true and exists(select 1 from public.titles t where t.id=title_id and t.published = true))
    or exists(select 1 from public.admin_users a where a.user_id = (select auth.uid()))
  );
create policy "admins manage episodes" on public.episodes
  for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())))
  with check (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())));

create policy "visitors see active sponsors" on public.sponsors
  for select to anon, authenticated using (
    is_active = true or exists(select 1 from public.admin_users a where a.user_id = (select auth.uid()))
  );
create policy "admins manage sponsors" on public.sponsors
  for all to authenticated
  using (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())))
  with check (exists(select 1 from public.admin_users a where a.user_id = (select auth.uid())));

insert into public.titles
(slug,name,description,kind,genre,release_year,duration_minutes,age_rating,poster_url,backdrop_url,video_url,credit,featured,published)
values
('sintel','Sintel','Uma jovem embarca em uma jornada extraordinária em busca de um dragão. Uma aventura emocionante do Blender Institute.','movie','Fantasia',2010,15,'12',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
'© Blender Foundation / Blender Institute — CC BY 3.0. Filme de demonstração.',true,true),
('tears-of-steel','Tears of Steel','Em uma Amsterdã futurista, um grupo se reúne para enfrentar uma ameaça mecânica. Ficção científica do projeto Mango.','movie','Ficção científica',2012,12,'12',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
'© Blender Foundation — CC BY 3.0. Filme de demonstração.',true,true),
('big-buck-bunny','Big Buck Bunny','Um coelho gigante vive uma aventura divertida e colorida enquanto lida com três pequenos encrenqueiros.','movie','Animação',2008,10,'L',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
'© Blender Foundation — CC BY 3.0. Filme de demonstração.',false,true),
('elephants-dream','Elephants Dream','Dois viajantes percorrem uma misteriosa máquina surrealista no primeiro filme aberto da Blender Foundation.','movie','Ficção científica',2006,11,'12',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
'© Blender Foundation — CC BY 2.5. Filme de demonstração.',false,true),
('colecao-cinema-aberto','Sessões de Cinema Aberto','Uma coleção especial de quatro curtas de animação, fantasia e ficção científica. Selecione uma sessão para assistir.','series','Antologia',2026,45,'12',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg',
null,'Curtas de Blender Foundation, licenças Creative Commons. Créditos nos episódios.',false,true)
on conflict (slug) do nothing;

insert into public.episodes (title_id,season_number,episode_number,name,description,duration_minutes,video_url)
select t.id,1,v.n,v.name,v.description,v.duration,v.url
from public.titles t
join (values
('colecao-cinema-aberto',1,'Sintel','Fantasia e dragões — © Blender Foundation, CC BY 3.0',15,'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4'),
('colecao-cinema-aberto',2,'Big Buck Bunny','Aventura animada — © Blender Foundation, CC BY 3.0',10,'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
('colecao-cinema-aberto',3,'Tears of Steel','Ficção científica — © Blender Foundation, CC BY 3.0',12,'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4'),
('colecao-cinema-aberto',4,'Elephants Dream','Cinema experimental — © Blender Foundation, CC BY 2.5',11,'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4')
) as v(slug,n,name,description,duration,url) on t.slug=v.slug
on conflict (title_id,season_number,episode_number) do nothing;

comment on table public.admin_users is 'Cadastre manualmente o UUID do administrador após criar seu usuário no Supabase Auth. Não há cadastro administrativo público.';
