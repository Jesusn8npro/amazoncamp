-- Policy: Allow insert only for authenticated users (producción segura)
-- Requiere que el usuario esté autenticado en Supabase Auth

CREATE POLICY "Allow insert for authenticated"
  ON reservas
  FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');
