-- Policy: Allow anyone to insert into reservas (solo para pruebas/desarrollo)
-- ¡No usar en producción sin ajustes!

-- Activa RLS si no está activa
ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;

-- Borra la policy anterior si existe (opcional, para evitar duplicados)
DROP POLICY IF EXISTS "Allow insert for anyone" ON reservas;

-- Crea la policy correcta SOLO con WITH CHECK
CREATE POLICY "Allow insert for anyone"
  ON reservas
  FOR INSERT
  WITH CHECK (true);
