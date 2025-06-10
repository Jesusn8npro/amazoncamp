-- Script para crear buckets de almacenamiento en Supabase Storage
-- Permite subir foto principal y galería de imágenes para los paquetes

-- Crea un bucket para las imágenes de los paquetes
do $$
begin
  if not exists (
    select 1 from storage.buckets where name = 'paquetes-fotos-principales'
  ) then
    insert into storage.buckets (id, name, public) values ('paquetes-fotos-principales', 'paquetes-fotos-principales', true);
  end if;
  if not exists (
    select 1 from storage.buckets where name = 'paquetes-galeria'
  ) then
    insert into storage.buckets (id, name, public) values ('paquetes-galeria', 'paquetes-galeria', true);
  end if;
end $$;

-- Opcional: puedes crear buckets adicionales para otros recursos si lo necesitas
