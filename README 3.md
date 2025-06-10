# Amazon Camp – Landing Page de Paquetes Turísticos

## Descripción general
Landing page moderna y persuasiva para la promoción y reserva de paquetes turísticos en la selva amazónica, desarrollada con **SvelteKit** y **Supabase**. El objetivo es maximizar la conversión y el engagement, mostrando beneficios, testimonios, itinerarios y un flujo de reserva optimizado.

---

## ¿Qué incluye este proyecto?
- **Página principal de paquetes** con galería, descripción, testimonios y beneficios exclusivos.
- **Componentes reutilizables**: HeroPaquete, GaleriaPaquete, IncluyePaquete, TestimoniosClientes, BeneficiosExclusivos.
- **Animaciones modernas**: fade-in, stagger, botones glowing, partículas flotantes.
- **Diseño responsive** y visualmente atractivo, con secciones diferenciadas por color y fondo.
- **Integración dinámica con Supabase** para cargar datos reales de cada paquete.

---

## Estructura de la landing `/paquetes/[slug]`
- **HeroPaquete**: Presenta el título, resumen y formulario de reserva.
- **GaleriaPaquete**: Muestra imágenes del paquete en grid con lightbox.
- **IncluyePaquete**: Lista de servicios incluidos, con íconos y animaciones.
- **TestimoniosClientes**: Social proof real de viajeros.
- **BeneficiosExclusivos**: Beneficios únicos del paquete, fondo oscuro y CTA.

---

## Funcionamiento y conexión de datos
- **Datos de cada paquete** se obtienen desde Supabase usando el slug de la URL.
- **Props dinámicos**: Los componentes reciben datos reales (beneficios, incluye, galería, etc) o muestran valores por defecto si no hay datos.
- **Hasta 6 beneficios** se muestran en la sección de exclusivos, con fallback si no hay datos.
- **Todo el contenido está en español** y optimizado para conversión.

---

## Flujo de reserva y conexión entre Home y Paquete
- En la **home** hay un formulario de reserva rápida.
- Al seleccionar un paquete y reservar, el usuario es redirigido a `/paquetes/[slug]` con el paquete seleccionado.
- El formulario en la página del paquete permite completar la reserva, mostrando el nombre del paquete y calculando el precio según adultos, niños y parejas.
- El formulario ahora guarda correctamente la reserva en Supabase usando el mapeo exacto de campos requeridos por la tabla `reservas`.

---

## Registro de reservas y Supabase

### Cambios realizados para un flujo funcional
- El formulario `FormularioLanding.svelte` envía ÚNICAMENTE los campos que existen en la tabla `reservas` de Supabase:
  - `paquete_id`, `nombre_cliente`, `email_cliente`, `telefono_cliente`, `fecha_reserva`, `estado`, `precio_adulto`, `precio_nino`, `precio_pareja`, `precio_total`, `monto_anticipo`, `monto_pendiente`, `porcentaje_anticipo`.
- Se eliminó el envío de campos extra como `adultos`, `ninos`, `parejas`, `paquete_slug`, `paquete_titulo`, etc.
- Los valores numéricos se envían como `Number` y se limpian los campos vacíos o nulos antes de enviar.

### Configuración de Row Level Security (RLS) y Policy en Supabase
- Se activó RLS en la tabla `reservas`:
  ```sql
  ALTER TABLE reservas ENABLE ROW LEVEL SECURITY;
  ```
- Se creó una policy para permitir inserts a cualquiera (solo pruebas/desarrollo):
  ```sql
  DROP POLICY IF EXISTS "Allow insert for anyone" ON reservas;
  CREATE POLICY "Allow insert for anyone"
    ON reservas
    FOR INSERT
    WITH CHECK (true);
  ```
- Se agregó script de policy segura para producción (solo usuarios autenticados):
  ```sql
  CREATE POLICY "Allow insert for authenticated"
    ON reservas
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');
  ```
- Ambos scripts están guardados en la carpeta `ScriptsSupabase`.

### Pruebas y resultados
- El flujo de reserva desde el landing fue probado exitosamente.
- Las reservas aparecen correctamente en Supabase y cumplen el esquema de la tabla.
- El error de "row-level security policy" desapareció tras aplicar la policy.

### Recomendaciones para producción
- Cuando el proyecto pase a producción, **elimina la policy de desarrollo** y usa la de usuarios autenticados.
- Si necesitas policies para SELECT/UPDATE/DELETE, crea reglas similares según tu lógica de negocio.
- Revisa periódicamente la seguridad de tus tablas.

---

## ¿Cómo agregar nuevos paquetes?
1. Añade el paquete en la tabla `paquetes` de Supabase, con los campos:
   - `titulo`, `slug`, `descripcion_corta`, `galeria` (array de imágenes), `incluye` (array de strings), `beneficios` (array de objetos `{icono, titulo, descripcion}`), etc.
2. ¡Listo! El sistema es 100% dinámico y mostrará los nuevos paquetes automáticamente.

---

## Personalización y mejoras
- Cambia imágenes de fondo en los componentes para adaptarlo a tu branding.
- Ajusta animaciones, colores y textos fácilmente desde los archivos Svelte.
- Puedes agregar más bloques como itinerario, mapa, FAQ, etc.

---

## Créditos y soporte
Desarrollado por y para Amazon Camp con ❤️, optimizado para conversión y experiencia de usuario.

¿Dudas o quieres seguir mejorando la landing? ¡Escríbeme y seguimos creciendo!
