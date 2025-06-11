<script>
  import { page } from '$app/stores';
  $: current = $page.url.pathname;
  // Iconos SVG inline para cada sección
  const links = [
    { href: '/administrador', label: 'Dashboard', icon: `<svg width='22' height='22' fill='none'><rect x='3' y='9' width='5' height='10' rx='2' fill='#fff'/><rect x='9' y='3' width='4' height='16' rx='2' fill='#fff'/><rect x='15' y='12' width='4' height='7' rx='2' fill='#fff'/></svg>` },
    { href: '/administrador/reservas', label: 'Reservas', icon: `<svg width='22' height='22' fill='none'><rect x='4' y='5' width='14' height='12' rx='3' fill='#fff'/><rect x='7' y='8' width='8' height='2' rx='1' fill='#a36be6'/></svg>` },
    { href: '/administrador/usuarios', label: 'Usuarios', icon: `<svg width='22' height='22' fill='none'><circle cx='11' cy='8' r='4' fill='#fff'/><rect x='4' y='15' width='14' height='5' rx='2.5' fill='#a36be6'/></svg>` },
    { href: '/administrador/paquetes', label: 'Paquetes', icon: `<svg width='22' height='22' fill='none'><rect x='3' y='7' width='16' height='10' rx='3' fill='#fff'/><rect x='7' y='4' width='8' height='3' rx='1.5' fill='#a36be6'/></svg>` },
    { href: '/administrador/pagos', label: 'Pagos', icon: `<svg width='22' height='22' fill='none'><rect x='3' y='6' width='16' height='10' rx='3' fill='#fff'/><circle cx='11' cy='11' r='3' fill='#a36be6'/></svg>` },
    { href: '/administrador/blog', label: 'Blog', icon: `<svg width='22' height='22' fill='none'><rect x='4' y='5' width='14' height='12' rx='3' fill='#fff'/><rect x='7' y='8' width='8' height='2' rx='1' fill='#a36be6'/><rect x='7' y='12' width='8' height='2' rx='1' fill='#a36be6'/></svg>` },
    { href: '/administrador/mensajes', label: 'Mensajes', icon: `<svg width='22' height='22' fill='none'><rect x='3' y='5' width='16' height='10' rx='3' fill='#fff'/><path d='M7 10h8' stroke='#a36be6' stroke-width='2' stroke-linecap='round'/></svg>` },
    { href: '/administrador/configuracion', label: 'Configuración', icon: `<svg width='22' height='22' fill='none'><circle cx='11' cy='11' r='7' stroke='#fff' stroke-width='2'/><circle cx='11' cy='11' r='2.5' fill='#a36be6'/></svg>` },
  ];
</script>

<nav class="sidebar-admin">
  <div class="sidebar-brand">
    <svg width="36" height="36" fill="none"><circle cx="18" cy="18" r="16" fill="#a36be6"/><text x="50%" y="56%" text-anchor="middle" fill="#fff" font-size="15" font-family="Arial" dy=".3em">AC</text></svg>
    <span>Amazon Camp</span>
  </div>
  <ul>
    {#each links as link}
      <li>
        <a href={link.href}
          class:selected={
            link.href === '/administrador'
              ? current === '/administrador'
              : current.startsWith(link.href)
          }>
          <span class="icon" innerHTML={link.icon}></span>
          <span class="label">{link.label}</span>
        </a>
      </li>
    {/each}
  </ul>
</nav>

<style>
.sidebar-admin {
  width: 240px;
  background: linear-gradient(160deg, #1a1333 60%, #a36be6 100%);
  color: #fff;
  min-height: 100vh;
  height: 100vh;
  position: sticky;
  top: 0;
  padding: 2.1rem 1.1rem 1.1rem 1.1rem;
  border-radius: 0rem 0 1.3rem 0;
  box-shadow: 0 8px 40px #a36be655;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.sidebar-brand {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  margin-bottom: 2.3rem;
  font-weight: 800;
  font-size: 1.35rem;
  letter-spacing: 0.02em;
  color: #fff;
  text-shadow: 0 1px 10px #a36be655;
}
.sidebar-brand svg {
  box-shadow: 0 2px 8px #a36be655;
  border-radius: 50%;
}
.sidebar-admin ul {
  list-style: none;
  padding: 0;
  margin: 0;
  width: 100%;
}
.sidebar-admin li {
  margin-bottom: 1.2rem;
  width: 100%;
}
.sidebar-admin a {
  display: flex;
  align-items: center;
  gap: 1.14rem;
  padding: 0.82rem 1.1rem;
  border-radius: 0.8rem;
  color: #fff;
  text-decoration: none;
  font-weight: 600;
  font-size: 1.09em;
  letter-spacing: 0.01em;
  box-shadow: none;
  transition: background 0.19s, color 0.19s, box-shadow 0.19s;
  position: relative;
}
.sidebar-admin a .icon {
  width: 22px;
  height: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.sidebar-admin a .label {
  flex: 1;
}
.sidebar-admin a:hover,
.sidebar-admin a.selected {
  background: linear-gradient(90deg, #a36be6 60%, #6a47b3 100%);
  color: #fff;
  box-shadow: 0 2px 16px #a36be655;
}
.sidebar-admin a.selected::before {
  content: '';
  position: absolute;
  left: -10px;
  top: 50%;
  transform: translateY(-50%);
  width: 6px;
  height: 38px;
  border-radius: 6px;
  background: #fff;
  opacity: 0.85;
  box-shadow: 0 2px 8px #a36be655;
}
@media (max-width: 900px) {
  .sidebar-admin {
    width: 100vw;
    min-height: unset;
    border-radius: 0 0 1.3rem 1.3rem;
    flex-direction: row;
    padding: 1rem 0.2rem;
    align-items: center;
    justify-content: flex-start;
    box-shadow: 0 4px 24px #a36be655;
  }
  .sidebar-admin ul {
    display: flex;
    flex-direction: row;
    gap: 0.2rem;
    width: auto;
  }
  .sidebar-admin li {
    margin-bottom: 0;
    margin-right: 0.7rem;
    width: unset;
  }
  .sidebar-brand {
    margin-bottom: 0;
    margin-right: 1.4rem;
  }
}
</style>
