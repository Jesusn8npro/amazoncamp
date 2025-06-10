-- Habilitar Row Level Security (RLS) en la tabla paquetes
ALTER TABLE paquetes ENABLE ROW LEVEL SECURITY;

-- Permitir INSERT a todos (solo para pruebas/desarrollo)
CREATE POLICY "Allow insert for all" ON paquetes FOR INSERT WITH CHECK (true);

-- Permitir UPDATE a todos (solo para pruebas/desarrollo)
CREATE POLICY "Allow update for all" ON paquetes FOR UPDATE USING (true);

-- Permitir DELETE a todos (solo para pruebas/desarrollo)
CREATE POLICY "Allow delete for all" ON paquetes FOR DELETE USING (true);
