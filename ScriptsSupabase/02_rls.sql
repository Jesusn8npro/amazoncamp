-- Políticas de Row Level Security (RLS) para Amazon Camp
-- Habilita y define reglas para todas las tablas creadas

-- 1. Habilitar RLS para cada tabla
alter table perfiles enable row level security;
alter table paquetes enable row level security;
alter table reservas enable row level security;
alter table visitas enable row level security;
alter table pagos enable row level security;

-- 2. Políticas básicas para cada tabla

-- Tabla perfiles: Solo el usuario puede ver o editar su perfil
create policy "Solo mi perfil" on perfiles
  for select using (auth.uid() = id);
create policy "Actualizar solo mi perfil" on perfiles
  for update using (auth.uid() = id);

-- Tabla paquetes: Solo administradores pueden insertar, actualizar o borrar
create policy "Ver paquetes" on paquetes
  for select using (true);
create policy "Solo admin puede crear paquetes" on paquetes
  for insert with check (exists (select 1 from perfiles where id = auth.uid() and rol = 'administrador'));
create policy "Solo admin puede actualizar paquetes" on paquetes
  for update using (exists (select 1 from perfiles where id = auth.uid() and rol = 'administrador'));
create policy "Solo admin puede borrar paquetes" on paquetes
  for delete using (exists (select 1 from perfiles where id = auth.uid() and rol = 'administrador'));

-- Tabla reservas: Solo el usuario dueño puede verlas o crearlas
create policy "Ver mis reservas" on reservas
  for select using (auth.uid() = usuario_id);
create policy "Crear reserva como usuario" on reservas
  for insert with check (auth.uid() = usuario_id);

-- Tabla visitas: Solo el usuario puede insertar/ver sus visitas
create policy "Ver mis visitas" on visitas
  for select using (auth.uid() = usuario_id);
create policy "Insertar mi visita" on visitas
  for insert with check (auth.uid() = usuario_id);

-- Tabla pagos: Solo el usuario dueño puede ver y crear sus pagos
create policy "Ver mis pagos" on pagos
  for select using (auth.uid() = usuario_id);
create policy "Crear mi pago" on pagos
  for insert with check (auth.uid() = usuario_id);

-- Puedes agregar políticas más avanzadas para administradores, reportes, etc.
