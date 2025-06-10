-- Script SQL inicial para Amazon Camp (Supabase)
-- Crea las tablas principales en español, incluyendo perfiles con rol

-- Tabla de perfiles de usuario (relacionada con auth.users)
create table perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nombre text,
  apellido text,
  telefono text,
  foto_url text,
  rol text default 'cliente', -- Puede ser 'administrador' o 'cliente'
  creado_en timestamp with time zone default timezone('utc'::text, now())
);

-- Tabla de paquetes turísticos
create table paquetes (
  id uuid primary key default uuid_generate_v4(),
  slug text unique,
  titulo text,
  descripcion text,
  beneficios text[],
  incluye text[],
  ventajas text[],
  imagen_principal text,
  galeria text[],
  precio_desde numeric,
  duracion text,
  ubicacion text,
  destacado boolean,
  creado_en timestamp with time zone default timezone('utc'::text, now())
);

-- Tabla de reservas
create table reservas (
  id uuid primary key default uuid_generate_v4(),
  usuario_id uuid references auth.users(id),
  paquete_id uuid references paquetes(id),
  nombre_cliente text,
  email_cliente text,
  telefono_cliente text,
  fecha_reserva timestamp with time zone default timezone('utc'::text, now()),
  estado text default 'pendiente'
);

-- Tabla de visitas (para estadísticas)
create table visitas (
  id uuid primary key default uuid_generate_v4(),
  usuario_id uuid references auth.users(id),
  paquete_id uuid references paquetes(id),
  fecha timestamp with time zone default timezone('utc'::text, now()),
  origen text -- ejemplo: "landing", "admin", "externo"
);

-- Tabla de pagos (para registrar pagos de reservas)
create table pagos (
  id uuid primary key default uuid_generate_v4(),
  reserva_id uuid references reservas(id),
  usuario_id uuid references auth.users(id),
  paquete_id uuid references paquetes(id),
  monto numeric,
  moneda text default 'PEN',
  metodo text, -- ejemplo: "Yape", "Plin", "Stripe", "PayPal", "MercadoPago"
  estado text default 'pendiente', -- "pendiente", "exitoso", "fallido"
  referencia text, -- ID de la transacción en el proveedor externo
  fecha timestamp with time zone default timezone('utc'::text, now())
);

