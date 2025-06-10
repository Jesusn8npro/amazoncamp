<script>
import { onMount } from 'svelte';
import { supabase } from '../../../supabaseClient.js';

let reservas = [];
let loading = true;
let error = '';
let editandoId = null;
let reservaEdit = {};
let mensaje = '';

const estadoOpciones = ['pendiente', 'confirmada', 'cancelada'];

let paquetesDisponibles = [];

async function cargarReservas() {
  loading = true;
  mensaje = '';
  // Trae todas las reservas
  const { data: reservasData, error: err } = await supabase.from('reservas').select('*').order('fecha_reserva', { ascending: false });
  console.log('CARGAR RESERVAS - DATA:', reservasData, 'ERROR:', err);
  if (err) {
    error = 'Error al cargar reservas';
    reservas = [];
    loading = false;
    return;
  }
  // Trae todos los paquetes (para el select y join manual)
  const { data: paquetesData, error: errPaquetes } = await supabase.from('paquetes').select('id, titulo');
  console.log('CARGAR PAQUETES - DATA:', paquetesData, 'ERROR:', errPaquetes);
  if (errPaquetes) {
    error = 'Error al cargar paquetes';
    reservas = [];
    loading = false;
    return;
  }
  paquetesDisponibles = paquetesData || [];
  // Une reservas con info de paquete
  reservas = (reservasData || []).map(r => {
    const paquete = paquetesDisponibles.find(p => p.id === r.paquete_id) || {};
    return {
      ...r,
      paquete_titulo: paquete.titulo || 'Sin título',
    };
  });
  console.log('RESERVAS FINALES:', reservas);
  error = '';
  loading = false;
}

function editarReserva(reserva) {
  editandoId = reserva.id;
  // Copia profunda para evitar referencias
  reservaEdit = JSON.parse(JSON.stringify({
    ...reserva,
    fecha_reserva: reserva.fecha_reserva ? reserva.fecha_reserva.slice(0, 10) : ''
  }));
  mensaje = '';
}

function cancelarEdicion() {
  editandoId = null;
  reservaEdit = {};
  mensaje = '';
}

async function guardarReserva(id) {
  loading = true;
  mensaje = '';
  // Solo envía los campos válidos
  const campos = {
    paquete_id: reservaEdit.paquete_id,
    nombre_cliente: reservaEdit.nombre_cliente,
    email_cliente: reservaEdit.email_cliente,
    telefono_cliente: reservaEdit.telefono_cliente,
    fecha_reserva: reservaEdit.fecha_reserva,
    estado: reservaEdit.estado,
    precio_total: Number(reservaEdit.precio_total),
    monto_anticipo: Number(reservaEdit.monto_anticipo),
    monto_pendiente: Number(reservaEdit.monto_pendiente),
    porcentaje_anticipo: Number(reservaEdit.porcentaje_anticipo),
    cantidad_adultos: Number(reservaEdit.cantidad_adultos),
    cantidad_ninos: Number(reservaEdit.cantidad_ninos),
    cantidad_parejas: Number(reservaEdit.cantidad_parejas)
  };
  console.log('INTENTO UPDATE SUPABASE', { id, campos });
  const { error: err, data, status, statusText } = await supabase.from('reservas').update(campos).eq('id', id);
  console.log('RESPUESTA UPDATE SUPABASE', { error: err, data, status, statusText });
  if (err) {
    error = 'Error al guardar cambios: ' + err.message + (err.details ? (' | Detalle: ' + err.details) : '') + (err.hint ? (' | Hint: ' + err.hint) : '');
    mensaje = error;
    console.error('Error al guardar reserva:', err);
  } else if (status && status !== 204) {
    error = 'Supabase devolvió un estado inesperado: ' + status + ' - ' + (statusText || '');
    mensaje = error;
    console.error('Estado inesperado al guardar:', status, statusText, data);
  } else {
    await cargarReservas();
    mensaje = '✅ Reserva actualizada correctamente';
    cancelarEdicion();
  }
  loading = false;
}

async function eliminarReserva(id) {
  if (confirm('¿Seguro que deseas eliminar esta reserva?')) {
    loading = true;
    mensaje = '';
    const { error: err } = await supabase.from('reservas').delete().eq('id', id);
    if (err) {
      error = 'Error al eliminar reserva';
    } else {
      mensaje = 'Reserva eliminada correctamente';
      await cargarReservas();
    }
    loading = false;
  }
}

onMount(() => {
  cargarReservas();
});
</script>

<div class="header-tabla">
  <h2>Reservas activas</h2>
  {#if loading}
    <span class="cargando">Cargando...</span>
  {/if}
</div>
{#if error}
  <div class="error">{error}</div>
{/if}
{#if mensaje}
  <div class="mensaje mensaje-exito">{mensaje}</div>
{/if}
{#if !loading && reservas.length === 0}
  <div class="no-registros">No hay reservas registradas.</div>
{:else}
  <table class="tabla-admin">
    <thead>
      <tr>
        <th>Paquete</th>
        <th>Cliente</th>
        <th>Email</th>
        <th>Teléfono</th>
        <th>Fecha</th>
        <th>Estado</th>
        <th>Composición</th>
        <th>Precio Total</th>
        <th>Anticipo</th>
        <th>Pendiente</th>
        <th>% Anticipo</th>
        <th>Acciones</th>
      </tr>
    </thead>
    <tbody>
      {#each reservas as reserva}
        <tr>
          {#if editandoId === reserva.id}
            <td colspan="13" class="form-edicion">
              <form on:submit|preventDefault={() => guardarReserva(reserva.id)} style="display: flex; flex-wrap: wrap; gap: 1rem; align-items: center; justify-content: flex-start;">
                <select bind:value={reservaEdit.paquete_id}>
                  {#each paquetesDisponibles as paquete}
                    <option value={paquete.id}>{paquete.titulo}</option>
                  {/each}
                </select>
                <input type="text" placeholder="Cliente" bind:value={reservaEdit.nombre_cliente} />
                <input type="email" placeholder="Email" bind:value={reservaEdit.email_cliente} />
                <input type="text" placeholder="Teléfono" bind:value={reservaEdit.telefono_cliente} />
                <input type="date" placeholder="Fecha" bind:value={reservaEdit.fecha_reserva} />
                <select bind:value={reservaEdit.estado}>
                  {#each estadoOpciones as estado}
                    <option value={estado}>{estado}</option>
                  {/each}
                </select>
                <input type="number" min="1" placeholder="Adultos" bind:value={reservaEdit.cantidad_adultos} style="width: 80px;" />
                <input type="number" min="0" placeholder="Niños" bind:value={reservaEdit.cantidad_ninos} style="width: 80px;" />
                <input type="number" min="0" placeholder="Parejas" bind:value={reservaEdit.cantidad_parejas} style="width: 80px;" />
                <input type="number" step="0.01" placeholder="Precio Total" bind:value={reservaEdit.precio_total} />
                <input type="number" step="0.01" placeholder="Anticipo" bind:value={reservaEdit.monto_anticipo} />
                <input type="number" step="0.01" placeholder="Pendiente" bind:value={reservaEdit.monto_pendiente} />
                <input type="number" placeholder="% Anticipo" bind:value={reservaEdit.porcentaje_anticipo} />
                <button class="guardar" type="submit">💾 Guardar</button>
                <button class="cancelar" type="button" on:click={cancelarEdicion}>✖ Cancelar</button>
              </form>
            </td>
          {:else}
            <td>{reserva.paquete_titulo}</td>
            <td>{reserva.nombre_cliente}</td>
            <td>{reserva.email_cliente}</td>
            <td>{reserva.telefono_cliente}</td>
            <td>{reserva.fecha_reserva ? reserva.fecha_reserva.slice(0,10) : '-'}</td>
            <td><span class="badge-estado {reserva.estado}">{reserva.estado}</span></td>
            <td>
              <span class="composicion">
                <span class="badge-huesped adultos" title="Adultos">👤 {reserva.cantidad_adultos ?? '-'}</span>
                <span class="badge-huesped ninos" title="Niños">🧒 {reserva.cantidad_ninos ?? '-'}</span>
                <span class="badge-huesped parejas" title="Parejas">💑 {reserva.cantidad_parejas ?? '-'}</span>
              </span>
            </td>
            <td>$ {Number(reserva.precio_total).toFixed(2)}</td>
            <td>$ {Number(reserva.monto_anticipo).toFixed(2)}</td>
            <td>$ {Number(reserva.monto_pendiente).toFixed(2)}</td>
            <td>{Number(reserva.porcentaje_anticipo).toFixed(2)}%</td> 
            <td>
              <button class="editar" title="Editar" on:click={() => editarReserva(reserva)}>✏️</button>
              <button class="eliminar" title="Eliminar" on:click={() => eliminarReserva(reserva.id)}>🗑️</button>
            </td>
          {/if}
        </tr>
      {/each}
    </tbody>
  </table>
{/if}

<style>
.header-tabla {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}
.header-tabla h2 {
  color: #0d5c63;
}
.cargando {
  color: #888;
  font-size: 1rem;
}
.error {
  color: #f44336;
  margin: 1rem 0;
}
.mensaje {
  color: #18e0e9;
  margin: 1rem 0;
}
.mensaje-exito {
  color: #fff;
  background: #18e0e9;
  padding: 0.7rem 1.5rem;
  border-radius: 6px;
  font-weight: bold;
  display: inline-block;
  margin-bottom: 1rem;
}
.no-registros {
  margin: 2rem 0;
  color: #888;
  text-align: center;
}
.tabla-admin {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #fff;
  margin-top: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 18px rgba(24,224,233,0.10);
  overflow: hidden;
  font-size: 1em;
}
.tabla-admin th, .tabla-admin td {
  padding: 1.1rem 0.8rem;
  border-bottom: 1px solid #e0f3f8;
  text-align: left;
}
.tabla-admin th {
  background: #e8fafd;
  color: #0d5c63;
  font-weight: 700;
  position: sticky;
  top: 0;
  z-index: 1;
}
.tabla-admin tr:nth-child(even) {
  background: #f7fcfd;
}
.tabla-admin tr:hover {
  background: #e0f7fa;
  transition: background 0.15s;
}
.composicion {
  display: flex;
  gap: 0.5em;
  align-items: center;
}
.badge-huesped {
  background: #e0f7fa;
  color: #0d5c63;
  border-radius: 1em;
  padding: 0.25em 0.7em;
  font-size: 0.97em;
  font-weight: 600;
  display: inline-block;
}
.badge-huesped.adultos { background: #e3f2fd; color: #1976d2; }
.badge-huesped.ninos { background: #fffde7; color: #fbc02d; }
.badge-huesped.parejas { background: #fce4ec; color: #ad1457; }
.badge-estado {
  padding: 0.3em 0.8em;
  border-radius: 0.9em;
  font-weight: 700;
  text-transform: capitalize;
  background: #e0f7fa;
  color: #0d5c63;
  font-size: 0.98em;
}
.badge-estado.confirmada { background: #c8e6c9; color: #388e3c; }
.badge-estado.pendiente { background: #fff9c4; color: #fbc02d; }
.badge-estado.cancelada { background: #ffcdd2; color: #d32f2f; }
.editar, .eliminar {
  background: none;
  border: none;
  font-size: 1.25em;
  cursor: pointer;
  border-radius: 6px;
  padding: 0.3em 0.7em;
  margin-right: 0.2em;
  transition: background 0.17s;
}
.editar:hover { background: #e0f7fa; }
.eliminar:hover { background: #ffebee; }
@media (max-width: 900px) {
  .tabla-admin th, .tabla-admin td {
    padding: 0.7rem 0.3rem;
    font-size: 0.97em;
  }
  .composicion { flex-direction: column; gap: 0.1em; }
}

.form-edicion {
  background: #e6f7fa !important;
  border: 2px solid #18e0e9;
  padding: 1.2rem 0.5rem !important;
  box-shadow: 0 2px 8px rgba(24,224,233,0.12);
  font-size: 1.1rem;
}
.form-edicion input, .form-edicion select {
  margin-right: 0.5rem;
  min-width: 120px;
  max-width: 180px;
  background: #fff;
  border: 1px solid #b8e3e6;
}
.form-edicion button {
  margin-right: 0.5rem;
}
.guardar {
  background: #18e0e9;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.4rem 1.1rem;
  cursor: pointer;
  margin-right: 0.5rem;
}
.guardar:hover {
  background: #0d5c63;
}
.cancelar {
  background: #e0e0e0;
  color: #222;
  border: none;
  border-radius: 4px;
  padding: 0.4rem 1.1rem;
  cursor: pointer;
}
.cancelar:hover {
  background: #bdbdbd;
}
.editar {
  background: #18e0e9;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.4rem 1.1rem;
  cursor: pointer;
  margin-right: 0.5rem;
}
.editar:hover {
  background: #0d5c63;
}
.eliminar {
  background: #f44336;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 0.4rem 1.1rem;
  cursor: pointer;
}
.eliminar:hover {
  background: #b71c1c;
}
input, select {
  padding: 0.3rem 0.5rem;
  font-size: 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
}
</style>
