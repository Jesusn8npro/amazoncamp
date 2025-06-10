-- Script para crear la tabla de artículos del blog en Supabase
-- Incluye RLS para permitir insertar, actualizar y seleccionar artículos de forma segura

-- 1. Crear la tabla
create table if not exists public.blog_articulos (
    id bigserial primary key,
    titulo text not null,
    slug text generated always as (replace(lower(regexp_replace(titulo, '[^a-zA-Z0-9\s]', '', 'g')), ' ', '-')) stored,
    resumen text,
    contenido text,
    imagen_url text,
    autor text default 'admin',
    estado text default 'borrador', -- 'borrador' o 'publicado'
    creado_en timestamptz default now(),
    actualizado_en timestamptz default now()
);

-- 2. Trigger para actualizar 'actualizado_en' automáticamente
create or replace function public.set_actualizado_en_blog()
returns trigger as $$
begin
  new.actualizado_en = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists blog_articulos_set_actualizado_en on public.blog_articulos;
create trigger blog_articulos_set_actualizado_en
before update on public.blog_articulos
for each row execute procedure public.set_actualizado_en_blog();

-- 3. Habilitar RLS
alter table public.blog_articulos enable row level security;

-- 4. Políticas RLS básicas (solo para usuarios autenticados, puedes ajustar luego)
-- Permitir SELECT para todos
create policy "Permitir leer articulos" on public.blog_articulos
  for select using (true);
-- Permitir INSERT solo para usuarios autenticados
create policy "Permitir crear articulos" on public.blog_articulos
  for insert with check (auth.role() = 'authenticated');
-- Permitir UPDATE solo para usuarios autenticados
create policy "Permitir editar articulos" on public.blog_articulos
  for update using (auth.role() = 'authenticated');
-- Permitir DELETE solo para usuarios autenticados (opcional)
create policy "Permitir borrar articulos" on public.blog_articulos
  for delete using (auth.role() = 'authenticated');

-- 5. Índices útiles
create index if not exists idx_blog_articulos_estado on public.blog_articulos(estado);
create index if not exists idx_blog_articulos_slug on public.blog_articulos(slug);

-- Script listo para usar en Supabase SQL editor o psql
-- Puedes crear, leer y actualizar artículos de blog de forma manual y segura.
