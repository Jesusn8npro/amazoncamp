-- Políticas de seguridad (RLS) para buckets de imágenes en Supabase Storage
-- Permite controlar quién puede subir, leer y borrar archivos en los buckets de paquetes

-- Habilitar RLS en los buckets
update storage.buckets set file_public = false where name in ('paquetes-fotos-principales', 'paquetes-galeria');

-- Permitir lectura pública (acceso anónimo) a las imágenes de los paquetes
insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Lectura pública fotos principales', 'paquetes-fotos-principales', 'allow', 'select', 'true')
  on conflict do nothing;
insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Lectura pública galería', 'paquetes-galeria', 'allow', 'select', 'true')
  on conflict do nothing;

-- Permitir solo a administradores subir, actualizar y borrar archivos
insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Solo admin puede subir fotos principales', 'paquetes-fotos-principales', 'allow', 'insert', 'exists (select 1 from perfiles where id = auth.uid() and rol = ''administrador'')')
  on conflict do nothing;
insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Solo admin puede borrar fotos principales', 'paquetes-fotos-principales', 'allow', 'delete', 'exists (select 1 from perfiles where id = auth.uid() and rol = ''administrador'')')
  on conflict do nothing;

insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Solo admin puede subir galería', 'paquetes-galeria', 'allow', 'insert', 'exists (select 1 from perfiles where id = auth.uid() and rol = ''administrador'')')
  on conflict do nothing;
insert into storage.policies (name, bucket_id, effect, action, definition)
values ('Solo admin puede borrar galería', 'paquetes-galeria', 'allow', 'delete', 'exists (select 1 from perfiles where id = auth.uid() and rol = ''administrador'')')
  on conflict do nothing;

-- Puedes agregar más reglas según tus necesidades (por ejemplo, solo el dueño del paquete puede borrar su imagen, etc.)
