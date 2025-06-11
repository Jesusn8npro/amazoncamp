<script>
  import { goto } from '$app/navigation';
  // Opciones de navegación inferior
  const opciones = [
    {
      nombre: 'Paquetes',
      icono: '📦',
      ruta: '/administrador/paquetes'
    },
    {
      nombre: 'Reservas',
      icono: '📅',
      ruta: '/administrador/reservas'
    },
    {
      nombre: 'Blog',
      icono: '📝',
      ruta: '/administrador/blog'
    },
    {
      nombre: 'Pagos',
      icono: '💳',
      ruta: '/administrador/pagos'
    }
  ];

  function irARuta(ruta) {
    goto(ruta);
  }
  function nuevoPaquete() {
    // Redirige a crear nuevo paquete
    goto('/administrador/paquetes/nuevo');
  }
</script>

<nav class="bottom-nav-admin">
  {#each opciones as opcion, idx}
    {#if idx === 2}
      <!-- Botón central -->
      <button class="btn-central" aria-label="Nuevo paquete" on:click={nuevoPaquete}>
        <span class="icono-central">+</span>
      </button>
    {/if}
    <button class="nav-item" aria-label={opcion.nombre} on:click={() => irARuta(opcion.ruta)}>
      <span class="icono-nav">{opcion.icono}</span>
      <span class="nombre-nav">{opcion.nombre}</span>
    </button>
  {/each}
</nav>

<style>
.bottom-nav-admin {
  position: fixed;
  left: 0;
  bottom: 0;
  width: 100vw;
  height: 70px;
  background: #fff;
  box-shadow: 0 -2px 16px #0002;
  display: flex;
  justify-content: space-around;
  align-items: center;
  z-index: 100;
  border-top-left-radius: 18px;
  border-top-right-radius: 18px;
}
.nav-item {
  background: none;
  border: none;
  outline: none;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: 1.12rem;
  color: #444;
  flex: 1;
  height: 100%;
  transition: color 0.2s;
}
.nav-item:active, .nav-item:focus {
  color: #1976d2;
}
.icono-nav {
  font-size: 1.45rem;
  margin-bottom: 2px;
}
.nombre-nav {
  font-size: 0.78rem;
  font-weight: 500;
}
.btn-central {
  position: absolute;
  left: 50%;
  transform: translateX(-50%) translateY(-25%);
  background: linear-gradient(90deg, #1976d2, #00bfae);
  border: none;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  box-shadow: 0 4px 18px #1976d255;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 2.15rem;
  z-index: 101;
  transition: background 0.2s, transform 0.2s;
}
.btn-central:active, .btn-central:focus {
  background: linear-gradient(90deg, #1565c0, #00a896);
  transform: translateX(-50%) scale(1.08) translateY(-25%);
}
.icono-central {
  font-size: 2.1rem;
  font-weight: bold;
  line-height: 1;
}

@media (min-width: 1024px) {
  .bottom-nav-admin {
    display: none;
  }
}
</style>
