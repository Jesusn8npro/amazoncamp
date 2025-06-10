<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  // DESTINO fijo
  const destino = 'IQUITOS';

  // Paquetes desde Supabase
  let paquetes = [];
  let paqueteSeleccionado = '';
  let loadingPaquetes = true;
  let errorPaquetes = '';

  // Fecha de inicio
  let fechaInicio = '';
  // Pasajeros detallados (mapeados a la tabla reservas)
  let adultos = 1;
  let ninos = 0;
  let parejas = 0;
  let showPasajerosPopover = false;

  function totalPasajeros() {
    return adultos + ninos + (parejas * 2);
  }

  function resumenPasajeros() {
    let partes = [];
    if (adultos > 0) partes.push(`${adultos} adulto${adultos > 1 ? 's' : ''}`);
    if (ninos > 0) partes.push(`${ninos} niño${ninos > 1 ? 's' : ''}`);
    if (parejas > 0) partes.push(`${parejas} pareja${parejas > 1 ? 's' : ''}`);
    return partes.length ? partes.join(', ') : 'Selecciona pasajeros';
  }

  // Cargar paquetes reales
  onMount(async () => {
    loadingPaquetes = true;
    const { data, error } = await supabase.from('paquetes').select('id, slug, titulo, duracion');
    if (error) {
      errorPaquetes = 'No se pudieron cargar los paquetes';
      paquetes = [];
    } else {
      paquetes = data;
      paqueteSeleccionado = paquetes[0]?.slug || '';
    }
    loadingPaquetes = false;
  });

  function irADetalle() {
    if (!paqueteSeleccionado || !fechaInicio || totalPasajeros() < 1) return;
    // Redirigir a detalles con query params
    window.location.href = `/paquetes/${paqueteSeleccionado}?fecha=${fechaInicio}` +
      `&adultos=${adultos}&ninos=${ninos}&parejas=${parejas}`;
  }
</script>

<div class="form-reserva-home">
  <form class="form-grid" autocomplete="off" on:submit|preventDefault={irADetalle}>
    <!-- Destino -->
    <div class="form-col">
      <label>Destino</label>
      <div class="input-fijo">{destino}</div>
    </div>
    <!-- Experiencias -->
    <div class="form-col">
      <label>Experiencias</label>
      {#if loadingPaquetes}
        <div class="input-fijo">Cargando...</div>
      {:else if errorPaquetes}
        <div class="input-fijo error">{errorPaquetes}</div>
      {:else}
        <select bind:value={paqueteSeleccionado} required>
          {#each paquetes as p}
            <option value={p.slug}>{p.titulo}</option>
          {/each}
        </select>
      {/if}
    </div>
    <!-- Fecha de inicio -->
    <div class="form-col">
      <label>Fecha de inicio</label>
      <input type="date" bind:value={fechaInicio} min={new Date().toISOString().split('T')[0]} required />
    </div>
    <!-- Pasajeros estilo Airbnb -->
    <div class="form-col relative">
      <label>Personas</label>
      <button type="button" class="pasajeros-selector" on:click={() => showPasajerosPopover = !showPasajerosPopover}>
        <span>{resumenPasajeros()}</span>
        <svg width="18" height="18" viewBox="0 0 24 24"><path d="M7 10l5 5 5-5z"/></svg>
      </button>
      {#if showPasajerosPopover}
        <div class="popover-pasajeros" on:click|stopPropagation>
          <div class="fila-popover">
            <div>
              <strong>Adultos</strong>
              <div class="desc">13 años o más</div>
            </div>
            <div class="controles">
              <button type="button" on:click={() => adultos = Math.max(1, adultos-1)} disabled={adultos <= 1}>-</button>
              <span>{adultos}</span>
              <button type="button" on:click={() => adultos = adultos+1}>+</button>
            </div>
          </div>
          <div class="fila-popover">
            <div>
              <strong>Niños</strong>
              <div class="desc">2 a 12 años</div>
            </div>
            <div class="controles">
              <button type="button" on:click={() => ninos = Math.max(0, ninos-1)} disabled={ninos <= 0}>-</button>
              <span>{ninos}</span>
              <button type="button" on:click={() => ninos = ninos+1}>+</button>
            </div>
          </div>
          <div class="fila-popover">
            <div>
              <strong>Parejas</strong>
              <div class="desc">2 adultos</div>
            </div>
            <div class="controles">
              <button type="button" on:click={() => parejas = Math.max(0, parejas-1)} disabled={parejas <= 0}>-</button>
              <span>{parejas}</span>
              <button type="button" on:click={() => parejas = parejas+1}>+</button>
            </div>
          </div>
          <button type="button" class="cerrar-popover" on:click={() => showPasajerosPopover = false}>Listo</button>
        </div>
      {/if}
    </div>
    <!-- Botón -->
    <div class="form-col boton-col">
      <button type="submit" class="btn-reserva">Precios y Disponibilidad</button>
    </div>
  </form>
</div>

<style>
.form-reserva-home {
  width: 100%;
  max-width: 1500px;
  background: #fff;
  border-radius: 1.5rem;
  box-shadow: 0 2px 24px #0002;
  padding: 2rem 2.5rem 1.5rem 2.5rem;
  position: relative;
  backdrop-filter: blur(8px);
  top: 50px;
  right: -200px;
}
.form-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1.2rem 1.7rem;
  align-items: flex-end;
}
.form-col { display: flex; flex-direction: column; gap: 0.35rem; }
label {
  font-size: 0.97em;
  font-weight: 600;
  color: #ff7043;
  margin-bottom: 0.25rem;
  letter-spacing: 0.01em;
}
.input-fijo {
  background: #f5f5f5;
  color: #0a3b4e;
  border-radius: 0.7rem;
  padding: 0.95rem 1.2rem;
  font-size: 1.05em;
  font-weight: 500;
}
input, select {
  border: 1.5px solid #ffe0b2;
  border-radius: 0.7rem;
  padding: 0.95rem 1.2rem;
  font-size: 1.05em;
  background: #fafbfc;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
  color: #0a3b4e;
}
select {
  max-width: 260px;
  min-width: 120px;
  width: 100%;
  box-sizing: border-box;
}
@media (max-width: 600px) {
  select {
    max-width: 100%;
    min-width: 100px;
  }
}
input:focus, select:focus {
  border: 1.5px solid #ff7043;
  box-shadow: 0 0 0 2px #ff704355;
}
.pasajeros-selector {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafbfc;
  border: 1.5px solid #ffe0b2;
  border-radius: 0.7rem;
  padding: 0.95rem 1.2rem;
  font-size: 1.05em;
  color: #0a3b4e;
  cursor: pointer;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
  position: relative;
}
.pasajeros-selector:focus, .pasajeros-selector.active {
  border: 1.5px solid #ff7043;
  box-shadow: 0 0 0 2px #ff704355;
}
.pasajeros-selector svg {
  margin-left: 0.7em;
  fill: #ff7043;
}
.relative { position: relative; }
.popover-pasajeros {
  position: absolute;
  top: 110%;
  left: 0;
  background: #fff;
  border-radius: 1.1rem;
  box-shadow: 0 6px 32px #0003;
  padding: 1.2rem 1.3rem 1rem 1.3rem;
  z-index: 100;
  min-width: 270px;
  width: max-content;
  min-width: 260px;
  max-width: 320px;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
  animation: popin 0.18s;
}
@keyframes popin {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: none; }
}
.fila-popover {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.2rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #f5f5f5;
}
.fila-popover:last-child { border-bottom: none; }
.fila-popover .desc {
  font-size: 0.98em;
  color: #888;
  font-weight: 400;
}
.controles {
  display: flex;
  align-items: center;
  gap: 0.7rem;
}
.controles button {
  background: #ff7043;
  color: #fff;
  border: none;
  width: 2.1rem;
  height: 2.1rem;
  border-radius: 50%;
  font-size: 1.12em;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.18s;
}
.controles button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
.controles span {
  min-width: 1.7em;
  text-align: center;
  font-size: 1.08em;
  font-weight: 600;
}
.cerrar-popover {
  margin-top: 0.9rem;
  background: #ff7043;
  color: #fff;
  border: none;
  border-radius: 0.7rem;
  padding: 0.7rem 1.2rem;
  font-size: 1em;
  font-weight: 600;
  align-self: flex-end;
  cursor: pointer;
  transition: background 0.18s;
}
.cerrar-popover:hover {
  background: #ff5722;
}

.boton-col {
  display: flex;
  align-items: flex-end;
}
.btn-reserva {
  width: 100%;
  background: #ff7043;
  color: #fff;
  font-weight: bold;
  font-size: 1.13em;
  border: none;
  border-radius: 0.8rem;
  padding: 1.1rem 0.5rem;
  box-shadow: 0 2px 12px #ff704344;
  cursor: pointer;
  transition: background 0.18s;
}
.btn-reserva:hover {
  background: #ff5722;
}
.error {
  color: #e01818;
  font-size: 0.97em;
  background: #ffeaea;
  border-radius: 0.5rem;
  padding: 0.5rem 1rem;
}


</style>
