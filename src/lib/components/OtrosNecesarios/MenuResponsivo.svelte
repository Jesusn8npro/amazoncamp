<script>
  import BannerVendedorMenu from './BannerVendedorMenu.svelte';
  import { supabase } from '../../../supabaseClient.js';
  export let open = false;
  export let navLinks = [];
  export let onClose = () => {};

  let submenuOpen = {};
  let articulos = [];
  let loadingArticulos = false;

  // Permite abrir/cerrar submenús
  function toggleSubmenu(idx) {
    submenuOpen = { ...submenuOpen, [idx]: !submenuOpen[idx] };
  }

  // Cerrar al hacer clic fuera del menú
  function handleOverlayClick(e) {
    if (e.target.classList.contains('menu-responsivo-overlay')) {
      onClose();
    }
  }


</script>

{#if open}
  <div class="menu-responsivo-overlay fixed inset-0 z-50 bg-black/40 flex justify-end" on:click={handleOverlayClick}>
    <aside class="menu-responsivo-drawer w-80 max-w-full h-full bg-white shadow-xl flex flex-col animate-slide-in-right relative">
      <!-- Cerrar -->
      <button class="absolute top-5 right-5 text-2xl text-orange-500 hover:text-orange-600" on:click={onClose} aria-label="Cerrar menú lateral">
        <i class="fas fa-times"></i>
      </button>
      <!-- Logo -->
      <a href="/" class="flex items-center gap-2 px-8 pt-8 pb-4">
        <img src="https://www.amazoncamp.net/images/logo.png" alt="Amazon Camp Logo" class="h-12 w-auto" />
      </a>
      <!-- Navegación -->
      <nav class="flex-1 overflow-y-auto px-6 pb-8">
        <ul class="space-y-2">
          {#each navLinks as link, idx}
            <li>
              {#if link.submenu}
                <button type="button" class="w-full flex justify-between items-center py-2 px-2 rounded hover:bg-orange-50 font-semibold text-gray-700" on:click={() => toggleSubmenu(idx)}>
                  <span>{link.nombre}</span>
                  <i class={`fas ${submenuOpen[idx] ? 'fa-chevron-up' : 'fa-chevron-down'} text-xs`}></i>
                </button>
                {#if submenuOpen[idx]}
                  <ul class="pl-4 py-1 space-y-1">
                    {#each link.submenu as sub}
                      <li>
                        <a href={sub.href} class="block py-1 px-2 rounded hover:bg-orange-100 text-gray-600">{sub.nombre}</a>
                      </li>
                    {/each}
                  </ul>
                {/if}
              {:else}
                <a href={link.href} class="block py-2 px-2 rounded hover:bg-orange-50 font-semibold text-gray-700">{link.nombre}</a>
              {/if}
            </li>
          {/each}
        </ul>
      </nav>
    <!-- Banner vendedor moderno en la parte inferior del menú -->
    <BannerVendedorMenu minutos={15} />
    </aside>
  </div>
{/if}

<style>
.menu-responsivo-overlay {
  transition: background 0.2s;
}
.menu-responsivo-drawer {
  animation: slide-in-right 0.35s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  min-width: 260px;
  max-width: 100vw;
}
@keyframes slide-in-right {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}
</style>
