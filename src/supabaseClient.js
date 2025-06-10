import { createClient } from '@supabase/supabase-js';

// URL de tu proyecto Supabase
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;

// Anon Public Key (clave pública)
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Inicializa el cliente de Supabase para usar en toda la app
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Puedes importar 'supabase' en cualquier componente para hacer login, registro, etc.
