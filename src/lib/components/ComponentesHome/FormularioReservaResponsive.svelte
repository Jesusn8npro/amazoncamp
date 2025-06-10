<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  // Estado del formulario
  const destino = 'IQUITOS';
  let paquetes = [];
  let paqueteSeleccionado = '';
  let loadingPaquetes = true;
  let errorPaquetes = '';
  let fechaInicio = '';
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
    window.location.href = `/paquetes/${paqueteSeleccionado}?fecha=${fechaInicio}` +
      `&adultos=${adultos}&ninos=${ninos}&parejas=${parejas}`;
  }
</script>

<div class="formulario-flotante">
  <form class="formulario-grid" autocomplete="off" on:submit|preventDefault={irADetalle}>
    <!-- Destino -->
    <div class="grupo-form">
      <label>Destino</label>
      <div class="input-fijo">{destino}</div>
    </div>
    <!-- Experiencias -->
    <div class="grupo-form">
      <label>Experiencia</label>
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
    <div class="grupo-form">
      <label>Fecha de inicio</label>
      <input type="date" bind:value={fechaInicio} min={new Date().toISOString().split('T')[0]} required />
    </div>
    <!-- Pasajeros -->
    <div class="grupo-form relative">
      <label>Personas</label>
      <button type="button" class="selector-pasajeros" on:click={() => showPasajerosPopover = !showPasajerosPopover}>
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
    <div class="grupo-form boton-form">
      <button type="submit" class="btn-reserva">Precios y Disponibilidad</button>
    </div>
  </form>
</div>

<style>
.formulario-flotante {
  width: 100%;
  max-width: 1100px;
  margin: 0 auto;
  position: absolute;
  left: 50%;
  top: 100% ;
  transform: translateX(-50%);
  z-index: 20;
  background: #fff;
  border-radius: 1.2rem;
  box-shadow: 0 6px 32px #0003;
  padding: 1.2rem 1.5rem 1.2rem 1.5rem;
  display: flex;
  justify-content: center;
  animation: fadeInUp 0.7s cubic-bezier(.77,0,.18,1);
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: none; }
}
.formulario-grid {
  width: 100%;
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 1rem 1.2rem;
  align-items: flex-end;
}
.grupo-form {
  display: flex;
  flex-direction: column;
  gap: 0.22rem;
}
label {
  font-size: 1.02em;
  font-weight: 600;
  color: #0d4f3e;
  margin-bottom: 0.15rem;
}
.input-fijo {
  background: #f5f5f5;
  color: #0a3b4e;
  border-radius: 0.7rem;
  padding: 0.8rem 1.1rem;
  font-size: 1em;
  font-weight: 500;
}
input, select {
  border: 1.5px solid #e0eeda;
  border-radius: 0.7rem;
  padding: 0.8rem 1.1rem;
  font-size: 1em;
  background: #f7f9f7;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
  color: #2c5530;
  font-family: inherit;
}
input:focus, select:focus {
  border: 1.5px solid #4caf50;
  box-shadow: 0 0 0 2px #c8f7d1;
}
.relative { position: relative; }
.selector-pasajeros {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fafbfc;
  border: 1.5px solid #e0eeda;
  border-radius: 0.7rem;
  padding: 0.8rem 1.1rem;
  font-size: 1em;
  color: #0a3b4e;
  cursor: pointer;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
  position: relative;
}
.selector-pasajeros:focus, .selector-pasajeros.active {
  border: 1.5px solid #4caf50;
  box-shadow: 0 0 0 2px #4caf5044;
}
.selector-pasajeros svg {
  margin-left: 0.7em;
  fill: #4caf50;
}
.popover-pasajeros {
  position: absolute;
  top: 110%;
  left: 0;
  background: #fff;
  border-radius: 1.1rem;
  box-shadow: 0 6px 32px #0003;
  padding: 1.1rem 1.2rem 1rem 1.2rem;
  z-index: 100;
  min-width: 240px;
  width: max-content;
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
  gap: 1.1rem;
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
  background: #4caf50;
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
  margin-top: 0.8rem;
  background: #4caf50;
  color: #fff;
  border: none;
  border-radius: 0.7rem;
  padding: 0.6rem 1.1rem;
  font-size: 1em;
  font-weight: 600;
  align-self: flex-end;
  cursor: pointer;
  transition: background 0.18s;
}
.cerrar-popover:hover {
  background: #388e3c;
}
.boton-form {
  display: flex;
  align-items: flex-end;
}
.btn-reserva {
  width: 100%;
  background: linear-gradient(90deg, #4caf50 70%, #8bc34a 100%);
  color: #fff;
  font-weight: bold;
  font-size: 1.08em;
  border: none;
  border-radius: 0.8rem;
  padding: 1rem 0.5rem;
  box-shadow: 0 2px 12px #4caf5044;
  cursor: pointer;
  transition: background 0.18s;
}
.btn-reserva:hover {
  background: linear-gradient(90deg, #388e3c 70%, #689f38 100%);
}
.error {
  color: #e01818;
  font-size: 0.97em;
  background: #ffeaea;
  border-radius: 0.5rem;
  padding: 0.5rem 1rem;
}
@media (max-width: 900px) {
  .formulario-flotante {
    position: static;
    transform: none;
    top: unset;
    left: unset;
    max-width: 100%;
    padding: 0.7rem 0.1rem 0.7rem 0.1rem;
    border-radius: 0.7rem;
    box-shadow: 0 1px 8px #0001;
  }
  .formulario-grid {
    grid-template-columns: 1fr;
    gap: 0.7rem;
    padding: 30px;
  }
  .btn-reserva {
    font-size: 1em;
    padding: 0.8rem 0.2rem;
  }
}
</style>
