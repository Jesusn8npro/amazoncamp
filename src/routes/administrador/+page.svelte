<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  let loading = true;
  let error = '';
  let reservas = [];
  let paquetes = [];
  let totalReservas = 0;
  let totalIngresos = 0;
  let clientesUnicos = 0;

  async function cargarDatos() {
    loading = true;
    error = '';
    try {
      // Reservas
      let { data: reservasData, error: errReservas } = await supabase
        .from('reservas')
        .select('*');
      if (errReservas) throw errReservas;
      reservas = reservasData || [];
      totalReservas = reservas.length;
      totalIngresos = reservas.reduce((sum, r) => sum + (r.precio_total || 0), 0);
      clientesUnicos = new Set(reservas.map(r => r.email_cliente)).size;

      // Paquetes
      let { data: paquetesData, error: errPaquetes } = await supabase
        .from('paquetes')
        .select('*')
        .eq('destacado', true);
      if (errPaquetes) throw errPaquetes;
      paquetes = paquetesData || [];
    } catch (e) {
      error = e.message || 'Error al cargar datos';
    }
    loading = false;
  }

  onMount(cargarDatos);

  function formatoMoneda(n) {
    return n?.toLocaleString('es-PE', { style: 'currency', currency: 'PEN', maximumFractionDigits: 0 }) || 'S/ 0';
  }
</script>

<div class="dashboard-admin">
  <h1 class="titulo-admin">Panel de Administración</h1>
  {#if loading}
    <div class="loading-admin">Cargando datos...</div>
  {:else if error}
    <div class="error-admin">{error}</div>
  {:else}
    <section class="dashboard-sections">
      <!-- Tarjetas resumen principales -->
      <div class="tarjetas-admin">
        <div class="tarjeta-admin fadein" title="Cantidad total de reservas registradas">
          <div class="tarjeta-titulo">Reservas</div>
          <div class="tarjeta-valor">{totalReservas}</div>
          <div class="tarjeta-desc">Total acumulado</div>
        </div>
        <div class="tarjeta-admin fadein" style="animation-delay:0.08s;" title="Clientes únicos por email">
          <div class="tarjeta-titulo">Clientes únicos</div>
          <div class="tarjeta-valor">{clientesUnicos}</div>
          <div class="tarjeta-desc">Identificados por email</div>
        </div>
        <div class="tarjeta-admin fadein" style="animation-delay:0.16s;" title="Suma de ingresos por reservas">
          <div class="tarjeta-titulo">Ingresos</div>
          <div class="tarjeta-valor ingreso">{formatoMoneda(totalIngresos)}</div>
          <div class="tarjeta-desc">Monto total</div>
        </div>
        <div class="tarjeta-admin fadein tarjeta-futura" style="animation-delay:0.22s;" title="Métrica futura">
          <div class="tarjeta-titulo">Reservas pendientes</div>
          <div class="tarjeta-valor">—</div>
          <div class="tarjeta-desc">Próximamente</div>
        </div>
        <div class="tarjeta-admin fadein tarjeta-futura" style="animation-delay:0.28s;" title="Métrica futura">
          <div class="tarjeta-titulo">Ocupación promedio</div>
          <div class="tarjeta-valor">—</div>
          <div class="tarjeta-desc">Próximamente</div>
        </div>
      </div>

      <!-- Métricas adicionales -->
      <div class="extra-metricas">
        <div class="metrica-box">
          <span class="metrica-label">Última reserva:</span>
          <span class="metrica-valor">{reservas.length > 0 ? new Date(Math.max(...reservas.map(r => new Date(r.fecha_reserva).getTime()))).toLocaleDateString('es-PE') : '—'}</span>
        </div>
        <div class="metrica-box">
          <span class="metrica-label">Próxima métrica</span>
          <span class="metrica-valor">—</span>
        </div>
      </div>

      <!-- Paquetes destacados -->
      <h2 class="subtitulo-admin">Paquetes destacados</h2>
      <div class="paquetes-lista">
        {#each paquetes as p}
          <div class="paquete-card fadein">
            <div class="paquete-img">
              {#if p.imagen_principal}
                <img src={p.imagen_principal} alt={p.titulo} />
              {:else}
                <div class="img-placeholder">🌄</div>
              {/if}
            </div>
            <div class="paquete-info">
              <div class="paquete-titulo">{p.titulo}</div>
              <div class="paquete-desc">{p.descripcion_corta || p.descripcion?.slice(0, 90) + '...'}</div>
              <div class="paquete-precio">Desde {formatoMoneda(p.precio_desde || p.precio_adulto)}</div>
              <div class="paquete-duracion">{p.duracion}</div>
              <div class="paquete-extra">
                <span class="paquete-label">Ubicación:</span> <span>{p.ubicacion || '—'}</span>
              </div>
              <div class="paquete-extra">
                <span class="paquete-label">Creado:</span> <span>{p.creado_en ? new Date(p.creado_en).toLocaleDateString('es-PE') : '—'}</span>
              </div>
            </div>
          </div>
        {/each}
        {#if paquetes.length === 0}
          <div class="no-paquetes">No hay paquetes destacados.</div>
        {/if}
      </div>
    </section>
  {/if}
</div>

<style>
.dashboard-admin {
  padding: 2.2rem 2.2rem 1rem 2.2rem;
  animation: fadeInDash 0.8s cubic-bezier(.6,.1,.2,1);
}
.titulo-admin {
  font-size: 2.1em;
  font-weight: 900;
  margin-bottom: 1.2rem;
  color: #1a1333;
  letter-spacing: 0.5px;
}
.loading-admin, .error-admin {
  padding: 1.6rem;
  text-align: center;
  font-size: 1.2em;
  color: #a36be6;
}
.error-admin { color: #d32f2f; }
.tarjetas-admin {
  display: flex;
  gap: 2.2rem;
  margin-bottom: 2.3rem;
  flex-wrap: wrap;
}
.tarjeta-admin {
  background: linear-gradient(120deg, #fff 70%, #a36be6 100%);
  box-shadow: 0 4px 24px #a36be622;
  border-radius: 1.2rem;
  padding: 1.7rem 2.2rem 1.3rem 2.2rem;
  min-width: 170px;
  min-height: 110px;
  flex: 1 1 180px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  animation: fadeInCard 0.8s cubic-bezier(.6,.1,.2,1);
  opacity: 0;
  transform: translateY(22px) scale(0.97);
  animation-fill-mode: forwards;
}
.fadein { opacity: 0; animation: fadeInCard 0.8s cubic-bezier(.6,.1,.2,1) forwards; }
.fadein:nth-child(1) { animation-delay: 0.02s; }
.fadein:nth-child(2) { animation-delay: 0.08s; }
.fadein:nth-child(3) { animation-delay: 0.16s; }
.tarjeta-titulo {
  font-size: 1.13em;
  font-weight: 700;
  color: #a36be6;
  margin-bottom: 0.4em;
}
.tarjeta-valor {
  font-size: 2.2em;
  font-weight: 800;
  color: #1a1333;
}
.tarjeta-valor.ingreso {
  color: #29d407;
}
.subtitulo-admin {
  font-size: 1.3em;
  font-weight: 700;
  margin: 1.8rem 0 1.2rem 0;
  color: #1a1333;
}
.paquetes-lista {
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
}
.paquete-card {
  background: #fff;
  border-radius: 1.1rem;
  box-shadow: 0 2px 16px #a36be622;
  overflow: hidden;
  min-width: 250px;
  max-width: 340px;
  flex: 1 1 260px;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  margin-bottom: 1.4rem;
  opacity: 0;
  transform: translateY(18px) scale(0.99);
  animation: fadeInCard 0.8s cubic-bezier(.6,.1,.2,1) forwards;
}
.paquete-img {
  width: 105px;
  height: 105px;
  background: linear-gradient(120deg, #a36be6 40%, #fff 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.paquete-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.img-placeholder {
  font-size: 2.6em;
  color: #a36be6;
  background: #fff8;
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.paquete-info {
  flex: 1 1 140px;
  padding: 1rem 1.2rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
}
.paquete-titulo {
  font-size: 1.13em;
  font-weight: 800;
  color: #1a1333;
  margin-bottom: 0.3em;
}
.paquete-desc {
  font-size: 0.98em;
  color: #5c4d7d;
  margin-bottom: 0.5em;
}
.paquete-precio {
  font-size: 1.08em;
  font-weight: 700;
  color: #29d407;
}
.paquete-duracion {
  font-size: 0.95em;
  color: #a36be6;
  margin-top: 0.2em;
}
.no-paquetes {
  color: #b5b5b5;
  font-size: 1.13em;
  margin: 1.5rem 0;
}
@media (max-width: 900px) {
  .dashboard-admin { padding: 1.2rem 0.5rem 0.5rem 0.5rem; }
  .tarjetas-admin { gap: 1.2rem; }
  .paquetes-lista { gap: 1.1rem; }
  .paquete-card { min-width: 180px; max-width: 100%; }
  .paquete-img { width: 80px; height: 80px; }
}
@keyframes fadeInDash {
  from { opacity: 0; transform: translateY(30px) scale(0.98); }
  to { opacity: 1; transform: none; }
}
@keyframes fadeInCard {
  from { opacity: 0; transform: translateY(18px) scale(0.99); }
  to { opacity: 1; transform: none; }
}
</style>
