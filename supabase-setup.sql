-- =================================================================
-- LECTURA Y OPINIÓN — Setup de Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- =================================================================

-- 1. TABLA PRINCIPAL DE LIBROS
-- =================================================================
create table if not exists public.libros (
  id               uuid default gen_random_uuid() primary key,
  created_at       timestamptz default now() not null,
  updated_at       timestamptz default now() not null,

  -- Datos del libro
  slug             text unique not null,
  titulo           text not null,
  autor            text not null,
  categoria        text not null
                   check (categoria in (
                     'negocios','productividad','marketing',
                     'ventas','autobiografia','gestion-del-tiempo'
                   )),

  -- Contenido
  resena           text,
  recomendado_para text,
  tapa_url         text,
  link_ml          text,

  -- Estado
  leido            boolean default true not null,
  rating           smallint check (rating between 1 and 5),
  destacado        boolean default false not null
);

-- 2. TRIGGER para updated_at automático
-- =================================================================
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger libros_updated_at
  before update on public.libros
  for each row execute function public.set_updated_at();

-- 3. ROW LEVEL SECURITY
-- =================================================================
alter table public.libros enable row level security;

-- Lectura pública: cualquiera puede ver los libros (para la biblioteca)
create policy "Lectura pública"
  on public.libros for select
  using (true);

-- Escritura solo para usuarios autenticados (el admin)
create policy "Admin puede insertar"
  on public.libros for insert
  to authenticated
  with check (true);

create policy "Admin puede actualizar"
  on public.libros for update
  to authenticated
  using (true);

create policy "Admin puede borrar"
  on public.libros for delete
  to authenticated
  using (true);

-- 4. DATOS DE EJEMPLO (opcionales, podés borrar si no los querés)
-- =================================================================
insert into public.libros
  (slug, titulo, autor, categoria, leido, rating, destacado, recomendado_para, resena)
values
  ('habitos-atomicos', 'Hábitos atómicos', 'James Clear', 'productividad',
   true, 5, true,
   'Todos los que sienten que saben qué deberían hacer pero no lo hacen.',
   'El mejor libro que leí sobre por qué cambiar de hábito es difícil y cómo hacerlo sin depender de la fuerza de voluntad. Subrayé medio libro.'),

  ('de-cero-a-uno', 'De cero a uno', 'Peter Thiel', 'negocios',
   true, 4, true,
   'Alguien que está pensando en emprender o que quiere entender cómo piensa Silicon Valley.',
   'Contraintuitivo, directo, con ideas que te obligan a pensar el mundo distinto. Algunas opiniones discutibles, pero vale cada página.'),

  ('shoe-dog', 'Nunca te detengas', 'Phil Knight', 'autobiografia',
   true, 5, true,
   'Cualquiera que alguna vez sintió que estaba a punto de tirar todo por la borda.',
   'La historia de Nike contada por su fundador. No esperaba que una autobiografía me enganchara así. Se lee como una novela.'),

  ('los-4-acuerdos', 'Los 4 acuerdos', 'Miguel Ruiz', 'productividad',
   true, 4, true,
   'Alguien que esté cansado de tomarse todo personal.',
   'Corto, simple, pero cada acuerdo te hace pensar bastante. Lo releo cada tanto.');
