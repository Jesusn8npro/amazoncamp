<script>
  import { onMount } from 'svelte';
  import TablaPaquetesModerna from '$lib/components/Admin/Paquetes/TablaPaquetesModerna.svelte';
  import FormularioPaqueteWizard from '$lib/components/Admin/Paquetes/FormularioPaqueteWizard.svelte';
  import { supabase } from '$lib/../supabaseClient.js';
  

  let paquetes = [];
  let mostrandoFormulario = false;
  let paqueteEditar = null;
  let loading = true;
  let errorPaquetes = '';

  async function cargarPaquetes() {
    loading = true;
    errorPaquetes = '';
    const { data, error } = await supabase.from('paquetes').select('*').order('creado_en', { ascending: false });
    if (error) {
      errorPaquetes = 'Error al cargar paquetes: ' + error.message;
      console.error('Error al cargar paquetes:', error);
    } else if (!data || data.length === 0) {
      console.warn('No se encontraron paquetes. Data:', data);
    } else {
      console.log('Paquetes cargados:', data);
    }
    paquetes = data || [];
    loading = false;
  }

  function nuevoPaquete() {
    paqueteEditar = null;
    mostrandoFormulario = true;
  }

  function cerrarFormulario() {
    mostrandoFormulario = false;
    paqueteEditar = null;
  }

  function eliminarLocalmente(id) {
    paquetes = paquetes.filter(p => p.id !== id);
  }

  onMount(() => {
    cargarPaquetes();
  });
</script>

<section>
  <div class="header-paquetes">
    <h1 class="titulo-animado animate-gradient"> 
      <span class="icono-titulo-fix">🌎</span>
      <span class="titulo-gradiente">Gestión de Paquetes Turísticos</span>
    </h1>
    <button class="nuevo-btn boton-animado" on:click={nuevoPaquete}>
      <span class="icono-btn">➕</span> Nuevo Paquete
    </button>
  </div>

  {#if mostrandoFormulario}
    <FormularioPaqueteWizard
      {paqueteEditar}
      on:guardado={() => { cargarPaquetes(); cerrarFormulario(); }}
      on:cerrar={cerrarFormulario}
    />
  {/if}

  {#if errorPaquetes}
    <div class="error-paquetes">{errorPaquetes}</div>
  {/if}
  {#if loading}
    <p>Cargando paquetes...</p>
  {:else}
    <TablaPaquetesModerna
      paquetes={paquetes}
      on:editar={(e) => { paqueteEditar = e.detail; mostrandoFormulario = true; }}
      on:eliminado={(event) => eliminarLocalmente(event.detail)}
    />
  {/if}
</section>

<style>
.header-paquetes {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  gap: 1.2rem;
  flex-wrap: wrap;
}
.titulo-animado {
  font-size: 2.4em;
  font-weight: 900;
  display: flex;
  align-items: center;
  gap: 0.6em;
  letter-spacing: 0.5px;
  animation: fadeInUp 0.8s cubic-bezier(.4,0,.2,1);
}
.titulo-gradiente {
  background: linear-gradient(90deg, #18e0e9 0%, #13b67a 40%, #fbbf24 100%);
  background-size: 200% 200%;
  background-clip: text;
  -webkit-background-clip: text;
  color: transparent;
  -webkit-text-fill-color: transparent;
  animation: gradientMove 3s ease-in-out infinite;
  text-shadow: 0 2px 16px #18e0e955, 0 1px 0 #fff8;
  display: inline-block;
}
.icono-titulo-fix {
  font-size: 1.2em;
  filter: drop-shadow(0 2px 8px #18e0e955);
  animation: popIn 0.7s cubic-bezier(.4,0,.2,1);
  color: #18e0e9;
  background: none !important;
  -webkit-background-clip: initial !important;
  -webkit-text-fill-color: initial !important;
  text-shadow: 0 2px 8px #18e0e955, 0 1px 0 #fff8;
}

@keyframes gradientMove {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px) scale(0.98); }
  to { opacity: 1; transform: none; }
}
.boton-animado {
  background: linear-gradient(90deg, #18e0e9 0%, #13b67a 100%);
  color: #fff;
  border: none;
  padding: 1.1rem 2.3rem;
  border-radius: 1.1rem;
  font-weight: 900;
  font-size: 1.18em;
  box-shadow: 0 4px 18px #18e0e933, 0 1.5px 0 #fff8;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.7em;
  transition: background 0.2s, transform 0.18s, box-shadow 0.18s, filter 0.18s;
  position: relative;
  overflow: hidden;
  outline: none;
  animation: popIn 0.7s cubic-bezier(.4,0,.2,1);
}
.boton-animado:hover {
  background: linear-gradient(90deg, #13b67a 0%, #18e0e9 100%);
  filter: brightness(1.09) drop-shadow(0 0 16px #18e0e955);
  transform: scale(1.045) translateY(-2px);
  box-shadow: 0 8px 32px #18e0e955, 0 2px 0 #fff8;
}
.icono-btn {
  font-size: 1.25em;
  filter: drop-shadow(0 1px 4px #fff8);
  animation: popIn 0.5s cubic-bezier(.4,0,.2,1);
}
@keyframes popIn {
  0% { transform: scale(0.92); opacity: 0; }
  70% { transform: scale(1.08); opacity: 1; }
  100% { transform: scale(1); opacity: 1; }
}
section {
  padding: 2rem;
  background: #f8fcfd;
  min-height: 80vh;
  border-radius: 1.2rem;
  box-shadow: 0 2px 16px #0001;
}
</style>
