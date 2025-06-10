# Amazon Camp - Plataforma de Reservas y Landings Dinámicas

## 🏕️ ¿Qué es Amazon Camp?
Amazon Camp es una empresa de turismo experiencial enfocada en la Amazonía peruana. Ofrece paquetes turísticos únicos, conectando viajeros con la naturaleza, comunidades nativas y aventuras inolvidables. El objetivo es vender experiencias auténticas y cerrar reservas de manera persuasiva, rápida y profesional, principalmente a través de WhatsApp y pagos digitales.

---

## 🚀 Objetivo del Proyecto
Crear una plataforma web moderna, visual y ultra persuasiva que:
- Permita listar y vender paquetes turísticos de forma automática y escalable.
- Genere una landing page visual y vendedora por cada paquete, **sin necesidad de programar**.
- Facilite la gestión de paquetes y reservas desde un panel administrador.
- Optimice el cierre de ventas por WhatsApp y pagos online.

---

## 🗂️ Estructura del Proyecto

```
src/
  rutas/
    Inicio/                # Home principal y secciones generales
    Paquetes/              # Listado de todos los paquetes
      [slug]/              # Carpeta dinámica para cada paquete (ej: /paquetes/amazonas-aventura)
        +page.svelte       # Landing autogenerada para ese paquete
        data.ts            # (opcional) Datos estáticos si no viene de la BD
  componentes/             # Componentes reutilizables (cards, banners, etc)
  admin/                   # Panel administrador (opcional, si lo haces en la misma app)
  utils/                   # Utilidades para formatear, cargar datos, etc
```

---

## 🧩 Modelo de Datos de Paquete (Supabase)
```ts
{
  id: string, // único
  slug: string, // para la URL amigable
  titulo: string,
  descripcion: string,
  beneficios: string[], // lista de bullets
  incluye: string[],    // lista de bullets
  ventajas: string[],   // lista de bullets
  imagenPrincipal: string, // URL o ruta local
  galeria: string[],       // array de imágenes
  precioDesde: number,
  duracion: string,
  ubicacion: string,
  destacado: boolean,
  // ...otros campos que quieras mostrar en la landing
}
```

---

## 🛒 Flujo de Venta y Persuasión
1. **El usuario entra al home:** Ve testimonios, beneficios y un proceso de reserva animado y vendedor.
2. **Explora paquetes:** En `/paquetes` ve cards con info clave y botón de reserva.
3. **Landing autogenerada:** Cada paquete tiene su propia landing visual y persuasiva (`/paquetes/[slug]`), con toda la info, galería, CTA de WhatsApp y botón de pago.
4. **Cierre de reserva:**
   - Formulario rápido (captura datos y/o redirige a WhatsApp con mensaje prellenado).
   - Opción de pago online (Wompi, PayU, MercadoPago, Stripe, etc).
   - Confirmación manual o automática.

---

## 🛠️ Panel Administrador (Admin)
- El cliente accede al modo admin.
- Crea/edita paquetes llenando campos: título, descripción, beneficios, qué incluye, imágenes, precio, etc.
- Los datos se guardan en Supabase.
- El sistema genera automáticamente la landing page del paquete usando esos datos.
- **No requiere programación**: solo llenar el formulario y listo.

---

## 🏗️ Jerarquía y Componentización
- **Home:** Presentación, beneficios diferenciales, testimonios, proceso de reserva.
- **Listado de Paquetes:** Cards persuasivas, filtro, búsqueda.
- **Landing de Paquete:**
  - Hero visual
  - Beneficios
  - Qué incluye
  - Galería
  - CTA WhatsApp y botón de pago
  - Testimonios específicos (opcional)
- **Componentes reutilizables:**
  - PaqueteCard, BeneficiosList, IncluyeList, GaleriaImagenes, CtaWhatsapp, HeroPaquete, etc.

---

## 🏁 Entrega Final y Escalabilidad
- El sistema queda listo para que el cliente/admin cree paquetes y la web genere landings automáticamente.
- 100% escalable: agregar un paquete = nueva landing lista para vender.
- El panel admin puede evolucionar a futuro (estadísticas, gestión de reservas, etc).
- El cierre de ventas es ágil: WhatsApp, pagos digitales, atención personalizada.

---

## 💡 Mejoras y Siguientes Pasos (Sugeridos)
- Agregar panel de reservas para ver y gestionar leads.
- Automatizar mensajes de WhatsApp y confirmaciones.
- Integrar reviews de plataformas externas (Tripadvisor, Airbnb).
- Mejorar SEO dinámico para cada landing.
- Agregar FAQ y sección de seguridad/confianza en cada paquete.
- Optimizar para dispositivos móviles y velocidad de carga.

---

## 📚 Contexto para futuros desarrolladores
Este README sirve como guía y contexto para cualquier persona que se una al proyecto. Aquí está todo lo necesario para entender la lógica, el objetivo, la arquitectura y cómo seguir escalando la plataforma de Amazon Camp.

---

**¿Dudas, mejoras o nuevas ideas? ¡Sigue este README y el sistema crecerá ordenado y vendedor!**
