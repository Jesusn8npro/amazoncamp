<script>
  import LoginNuevo from '../OtrosNecesarios/LoginNuevo.svelte';
  import MenuResponsivo from '../OtrosNecesarios/MenuResponsivo.svelte';
  import { afterNavigate } from '$app/navigation';
  import { supabase } from '../../../supabaseClient.js';
let menuResponsivoAbierto = false;

// Cierra el menú responsivo automáticamente al navegar
afterNavigate(() => {
  menuResponsivoAbierto = false;
});
  let loginModalAbierto = false;
  import { onMount } from 'svelte';
  let menuLateral = false;
  let idiomaOpen = false;
  let buscarOverlay = false;
  let busqueda = '';

  let submenuOpen = null;
let submenuTimeout = null;

  let navLinks = [
  { nombre: 'Inicio', href: '/' },
  { nombre: 'Paquetes', submenu: [] }, // Se llenará dinámicamente
  { nombre: 'Experiencias', submenu: [
    { nombre: 'Avistamiento de Delfines', href: '/experiencias/delfines' },
    { nombre: 'Comunidad Nativa', href: '/experiencias/comunidad' },
    { nombre: 'Trekking en la Selva', href: '/experiencias/trekking' }
  ] },
  { nombre: 'Blog', href: '/blog' },
  { nombre: 'Contacto', href: '/contacto' }
];

async function cargarPaquetesMenu() {
  const { data, error } = await supabase
    .from('paquetes')
    .select('titulo, slug');
  if (data) {
    navLinks = navLinks.map(link => {
      if (link.nombre === 'Paquetes') {
        return {
          ...link,
          submenu: data.map(paquete => ({
            nombre: paquete.titulo,
            href: `/paquetes/${paquete.slug}`
          }))
        };
      }
      return link;
    });
  }
}

onMount(() => {
  cargarPaquetesMenu();
});

  const socialLinks = [
    { icon: 'fab fa-facebook-f', url: 'https://facebook.com/amazoncamp' },
    { icon: 'fab fa-instagram', url: 'https://instagram.com/amazoncamp' },
    { icon: 'fab fa-youtube', url: 'https://youtube.com/amazoncamp' },
    { icon: 'fab fa-whatsapp', url: 'https://wa.me/51987654321' }
  ];

  const articulos = [
    {
      titulo: '5 razones para visitar la Amazonía peruana',
      fecha: '1 Junio 2025',
      img: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
      href: '/blog/razones-amazonia'
    },
    {
      titulo: 'Cómo preparar tu viaje a la selva',
      fecha: '28 Mayo 2025',
      img: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
      href: '/blog/preparar-viaje-selva'
    },
    {
      titulo: 'Experiencias únicas con comunidades nativas',
      fecha: '20 Mayo 2025',
      img: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80',
      href: '/blog/comunidades-nativas'
    }
  ];
</script>

<!-- Menú responsivo lateral (drawer) -->
<MenuResponsivo open={menuResponsivoAbierto} navLinks={navLinks} onClose={() => menuResponsivoAbierto = false} />


<!-- Barra superior -->
<div class="barra-superior">
  <div class="barra-superior-inner">
    <div class="contacto">
      <span class="contact-item"><i class="far fa-envelope icono"></i> info@amazoncamp.net</span>
      <span class="contact-item"><i class="fas fa-phone-alt icono"></i> +51 987 654 321</span>
    </div>
    <div class="acciones">
      <a href="https://facebook.com/amazoncamp" target="_blank" class="icono-social" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
      <a href="https://instagram.com/amazoncamp" target="_blank" class="icono-social" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
      <a href="https://youtube.com/amazoncamp" target="_blank" class="icono-social" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
      <a href="https://wa.me/51987654321" target="_blank" class="icono-social" aria-label="WhatsApp"><i class="fab fa-whatsapp"></i></a>
      <!-- Idioma -->
      <div class="idioma-selector">

        <button class="bg-orange-500 hover:bg-orange-600 px-4 py-1 rounded text-white font-semibold flex items-center gap-1" on:click={() => idiomaOpen = !idiomaOpen}>
          Español
          <i class="fas fa-chevron-down text-xs"></i>
        </button>
        {#if idiomaOpen}
          <div class="absolute right-0 mt-2 bg-white text-gray-800 rounded shadow-md z-30 min-w-[120px]">
            <a href="#" class="block px-4 py-2 hover:bg-orange-100">Español</a>
            <a href="#" class="block px-4 py-2 hover:bg-orange-100">English</a>
          </div>
        {/if}
      </div>
      <!-- Usuario -->
      <button class="bg-cyan-400 hover:bg-cyan-500 px-3 py-1 rounded flex items-center justify-center text-white font-bold ml-2" aria-label="Usuario" on:click={() => loginModalAbierto = true}>
  <i class="fas fa-user text-lg"></i>
</button>
    </div>
  </div>
</div>

<!-- Barra principal -->
<nav class="w-full bg-white shadow">
  <div class="max-w-7xl mx-auto flex justify-between items-center px-4 py-3">
    <!-- Logo -->
    <a href="/" class="flex items-center gap-2">
      <img src="https://www.amazoncamp.net/images/logo.png" alt="Amazon Camp Logo" class="h-12 w-auto" />
    </a>
    <!-- Menú horizontal -->
    <div class="hidden lg:flex items-center gap-6">
      {#each navLinks as link, idx}
        {#if link.submenu}
          <div class="relative"
            on:mouseenter={() => {
              if (submenuTimeout) clearTimeout(submenuTimeout);
              submenuOpen = idx;
            }}
            on:mouseleave={() => {
              submenuTimeout = setTimeout(() => submenuOpen = null, 220);
            }}
          >
            <button class="flex items-center gap-1 font-semibold text-gray-700 hover:text-orange-500 focus:outline-none">
              {link.nombre}
              <i class="fas fa-chevron-down text-xs mt-1"></i>
            </button>
            <div class="absolute left-0 mt-2 bg-white shadow-lg rounded z-20 transition-all min-w-[180px]"
              style="opacity: {submenuOpen === idx ? 1 : 0}; pointer-events: {submenuOpen === idx ? 'auto' : 'none'};"
            >
              {#each link.submenu as sub}
                <a href={sub.href} class="block px-4 py-2 text-gray-700 hover:bg-orange-100 hover:text-orange-600">{sub.nombre}</a>
              {/each}
            </div>
          </div>
        {:else}
          <a href={link.href} class="font-semibold text-gray-700 hover:text-orange-500">{link.nombre}</a>
        {/if}
      {/each}
    </div>
    <!-- Buscador y menú lateral -->
    <div class="flex items-center gap-3">
      <button class="hidden lg:block p-2 rounded-full hover:bg-orange-100" aria-label="Buscar" on:click={() => buscarOverlay = true}>
        <i class="fas fa-search text-orange-500 text-lg"></i>
      </button>
      <!-- Botón hamburguesa solo visible en móvil/tablet -->
      <button class="block lg:hidden bg-orange-500 hover:bg-orange-600 p-2 rounded-full text-white text-xl ml-2" on:click={() => menuResponsivoAbierto = true} aria-label="Abrir menú responsivo">
        <i class="fas fa-bars text-white"></i>
      </button>
      <!-- Botón y menú lateral actual (no se elimina) -->
      <button class="hidden lg:block bg-orange-500 hover:bg-orange-600 p-2 rounded-full text-white text-xl ml-2" on:click={() => menuLateral = true} aria-label="Abrir menú lateral">
        <i class="fas fa-bars text-white"></i>
      </button>
    </div>
  </div>
</nav>

{#if loginModalAbierto}
  <LoginNuevo on:close={() => { loginModalAbierto = false; console.log('LoginNuevo close event received, modal closed'); }} />
{/if}

<!-- Menú lateral derecho -->
{#if menuLateral}
  <div class="fixed inset-0 z-50 bg-black/50 flex justify-end items-stretch">
    <div class="w-full max-w-md h-full bg-white shadow-xl flex flex-col relative animate-slide-in-right" style="right:0; position:fixed; top:0; bottom:0;">
      <button class="absolute top-5 right-5 text-2xl text-orange-500 hover:text-orange-600" on:click={() => menuLateral = false} aria-label="Cerrar menú lateral">
        <i class="fas fa-times"></i>
      </button>
      <div class="px-8 pt-10 pb-4 flex flex-col items-center">
        <img src="https://www.amazoncamp.net/images/logo.png" alt="Amazon Camp Logo" class="h-14 mb-2" />
        <p class="text-center text-gray-700 text-sm mb-4">Vive experiencias inolvidables en la Amazonía peruana. Conecta con la naturaleza, explora destinos únicos y disfruta de aventuras auténticas con Amazon Camp.</p>
        <div class="flex gap-4 mb-6">
          {#each socialLinks as s}
            <a href={s.url} target="_blank" class="text-orange-500 hover:text-orange-600 text-xl"><i class={s.icon}></i></a>
          {/each}
        </div>
        <h3 class="text-lg font-bold mb-2 text-gray-800">Artículos recientes</h3>
        <div class="w-full flex flex-col gap-3">
          {#each articulos as art}
            <a href={art.href} class="flex gap-3 items-center hover:bg-orange-50 rounded p-2">
              <img src={art.img} alt={art.titulo} class="w-14 h-14 rounded object-cover" />
              <div>
                <div class="text-xs text-gray-500">{art.fecha}</div>
                <div class="font-semibold text-gray-800 leading-tight text-sm">{art.titulo}</div>
              </div>
            </a>
          {/each}
        </div>
      </div>
    </div>
    <div class="flex-1" on:click={() => menuLateral = false}></div>
  </div>
{/if}

{#if buscarOverlay}
  <div class="busqueda-overlay">
    <button class="cerrar-busqueda" on:click={() => buscarOverlay = false} aria-label="Cerrar búsqueda">
      <i class="fas fa-times"></i>
    </button>
    <form class="busqueda-form" on:submit|preventDefault={() => buscarOverlay = false}>
      <input
        type="text"
        class="busqueda-input"
        placeholder="Buscar aquí..."
        bind:value={busqueda}
        autofocus
      />
      <button type="submit" class="busqueda-btn bg-transparent shadow-none border-none" aria-label="Buscar" style="background:transparent;box-shadow:none;border:none;padding:0;">
  <i class="fas fa-search text-white" style="color:#fff;"></i>
</button>
    </form>
  </div>
{/if}

<style>
/* Barra superior */
.barra-superior {
  width: 100%;
  height: 100%;
  background: #1a1a1a;
  color: #f3f3f3;
  font-size: 0.95rem;
}
.barra-superior-inner {
  max-width: 1320px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 2.5rem;
  padding: 0.5rem 2.5rem;
  box-sizing: border-box;
  text-align: center;
}

/* --- Versión móvil: barra superior compacta y horizontal --- */
@media (max-width: 640px) {
  .barra-superior-inner {
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 0.5rem;
    padding: 0.3rem 0.5rem;
    width: 100vw;
    background: #181818;
    box-shadow: 0 1px 8px #0002;
  }
  .contacto {
    display: none !important; /* Oculta email/teléfono en móvil */
  }
  .acciones {
    flex-direction: row;
    gap: 0.7rem;
    justify-content: center;
    align-items: center;
    width: 100vw;
    background: none;
    padding: 0;
  }
  .icono-social {
    font-size: 1.25em;
    color: #fff;
    background: none;
  }
  .idioma-selector {
    margin-left: 0.3rem;
  }
  .bg-orange-500, .bg-cyan-400 {
    padding: 0.4rem 0.8rem;
    font-size: 1em;
    border-radius: 0.5rem;
  }
  .bg-orange-500 {
    background: #ff7a1a;
  }
  .bg-cyan-400 {
    background: #18e0e9;
  }
}

.contacto, .acciones {
  display: flex;
  align-items: center;
  gap: 2rem;
}
@media (max-width: 1024px) {
  .barra-superior-inner {
    flex-direction: column;
    gap: 0.5rem;
    padding: 0.5rem 0;
    align-items: center;
    width: 100%;
  }
  .contacto, .acciones {
    justify-content: center;
    gap: 1rem;width: 100%;
  }
}

.contacto {
  display: flex;
  align-items: center;
  gap: 2rem;
}
.contact-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background: #232323;
  border-radius: 2rem;
  padding: 0.25rem 1.1rem 0.25rem 0.7rem;
  font-weight: 500;
  color: #fff;
}
.contact-item .icono {
  color: #ff7a1a;
  font-size: 1.1em;
}
.acciones {
  display: flex;
  align-items: center;
  gap: 1.3rem;
}
.icono-social {
  color: #fff;
  font-size: 1.1em;
  transition: color 0.2s;
}
.icono-social:hover {
  color: #ff7a1a;
}
.idioma-selector {
  display: inline-block;
  position: relative;
  margin-left: 0.7rem;
}
.idioma-selector > button {
  background: #ff7a1a;
  color: #fff;
  font-weight: 600;
  border: none;
  border-radius: 0.25rem 0 0 0.25rem;
  padding: 0.45rem 1.3rem 0.45rem 1.1rem;
  font-size: 1em;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: background 0.2s;
}
.idioma-selector > button:hover {
  background: #e05d00;
}
.idioma-selector > div {
  position: absolute;
  right: 0;
  top: 110%;
  background: #fff;
  color: #333;
  border-radius: 0.25rem;
  box-shadow: 0 2px 10px #0001;
  min-width: 120px;
  z-index: 30;
}
.idioma-selector a {
  display: block;
  color: #333;
  text-decoration: none;
  transition: background 0.2s, color 0.2s;
  font-size: 0.98em;
}
.idioma-selector a:hover {
  background: #ffe6d2;
  color: #ff7a1a;
}
.acciones > button {
  background: #18e0e9;
  color: #fff;
  border: none;
  border-radius: 0 0.25rem 0.25rem 0;
  padding: 0.45rem 1.1rem;
  font-weight: bold;
  font-size: 1em;
  margin-left: -0.2rem;
  cursor: pointer;
  transition: background 0.2s;
}
.acciones > button:hover {
  background: #13bfc3;
}

/* Responsive */
@media (max-width: 1024px) {
  .barra-superior-inner {
    flex-direction: column;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    align-items: stretch;
  }
  .contacto {
    justify-content: center;
    gap: 1rem;
  }
  .acciones {
    justify-content: center;
    gap: 1rem;
  }
}

.busqueda-overlay {
  position: fixed;
  inset: 0;
  z-index: 9999;
  background: rgba(15,15,15,0.93);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background 0.2s;
}
.cerrar-busqueda {
  position: absolute;
  top: 36px;
  right: 48px;
  background: #ff7a1a;
  color: #fff;
  border: none;
  border-radius: 50%;
  width: 48px;
  height: 48px;
  font-size: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 10000;
  box-shadow: 0 2px 12px #0002;
  transition: background 0.2s, color 0.2s;
}
.cerrar-busqueda:hover {
  background: #e05d00;
  color: #fff;
}
.busqueda-form {
  width: 100%;
  max-width: 540px;
  display: flex;
  align-items: center;
  background: rgba(34, 34, 34, 0.98);
  border-radius: 2.2rem;
  box-shadow: 0 6px 32px #0006;
  position: relative;
  border: 2.5px solid #ff7a1a;
  padding: 0.1rem 0.2rem 0.1rem 0.1rem;
  transition: box-shadow 0.2s;
}
.busqueda-form:focus-within {
  box-shadow: 0 8px 40px #ff7a1a55, 0 6px 32px #0006;
  border-color: #ff7a1a;
}
.busqueda-input {
  flex: 1;
  padding: 1.1rem 1.7rem;
  font-size: 1.09rem;
  border: none;
  border-radius: 2rem 0 0 2rem;
  outline: none;
  background: transparent;
  color: #fff;
  font-weight: 500;
  box-sizing: border-box;
  transition: background 0.2s, color 0.2s;
}
.busqueda-input::placeholder {
  color: #e2e2e2;
  opacity: 1;
  font-weight: 400;
}
.busqueda-btn {
  background: #18e0a8;
  border: none;
  border-radius: 0 2rem 2rem 0;
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.15rem;
  color: #222;
  /* Elimina el margen para que quede pegado al input */
  margin-left: 0;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  box-shadow: 0 2px 8px #0002;
}
.busqueda-btn:hover {
  background: #13bfa3;
  color: #fff;
}
.busqueda-btn i {
  color: #111;
}
@media (max-width: 600px) {
  .busqueda-form {
    max-width: 95vw;
    padding: 0.05rem 0.08rem 0.05rem 0.05rem;
  }
  .cerrar-busqueda {
    top: 14px;
    right: 14px;
    width: 38px;
    height: 38px;
    font-size: 1.3rem;
  }
  .busqueda-input {
    padding: 0.8rem 1.1rem;
    font-size: 1em;
  }
  .busqueda-btn {
    width: 36px;
    height: 36px;
    font-size: 1rem;
  }
}

@keyframes slide-in-right {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}
.animate-slide-in-right {
  animation: slide-in-right 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>

<!-- Incluye FontAwesome en tu index.html para los íconos:
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
-->
