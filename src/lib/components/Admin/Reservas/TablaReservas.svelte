<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';
  import { createEventDispatcher } from 'svelte';

  let reservas = [];
let editandoId = null;
let reservaEdit = {};
let cargando = false;
let error = '';
let exito = '';

const coloresCards = ['#e0f7fa', '#ffe0b2', '#e1bee7', '#c8e6c9', '#fff9c4', '#f8bbd0'];
const dispatch = createEventDispatcher();

async function cargarReservas() {
  cargando = true;
  error = '';
  let { data, error: err } = await supabase.from('reservas').select('*');
  if (err) error = 'Error al cargar reservas';
  else reservas = data || [];
  cargando = false;
}

function editarReserva(reserva) {
  editandoId = reserva.id;
  reservaEdit = { ...reserva };
}

function cancelarEdicion() {
  editandoId = null;
  reservaEdit = {};
  exito = '';
  error = '';
}

async function guardarReserva() {
  cargando = true;
  error = '';
  exito = '';
  // Solo enviar los campos definidos en la tabla
  const campos = [
    'nombre_cliente', 'email_cliente', 'telefono_cliente', 'fecha_reserva', 'estado',
    'precio_adulto', 'precio_nino', 'precio_pareja', 'precio_total', 'monto_anticipo',
    'monto_pendiente', 'porcentaje_anticipo', 'cantidad_adultos', 'cantidad_ninos',
    'cantidad_parejas', 'cantidad_dias'
  ];
  let datos = {};
  campos.forEach(c => datos[c] = reservaEdit[c]);
  const { error: err } = await supabase.from('reservas').update(datos).eq('id', reservaEdit.id);
  if (err) error = 'Error al guardar cambios';
  else {
    exito = '¡Reserva actualizada!';
    await cargarReservas();
    cancelarEdicion();
  }
  cargando = false;
}

onMount(cargarReservas);
</script>

<div class="admin-reservas-wrapper">
  <h1 class="titulo-admin">Administración de reservas</h1>
  <p class="descripcion-admin">
    Visualiza, edita y gestiona fácilmente todas las reservas de tus clientes. Haz click en el lápiz para editar cualquier campo. Cambios en tiempo real y diseño responsivo.
  </p>

  {#if error}
    <div class="error-admin">{error}</div>
  {/if}
  {#if exito}
    <div class="exito-admin">{exito}</div>
  {/if}

  {#if cargando}
    <div class="cargando-admin">Cargando reservas...</div>
  {:else}
    <!-- Vista de escritorio: tabla -->
    <table class="tabla-admin-reservas">
      <thead>
        <tr>
          <th><span>👤 Nombre</span></th>
          <th><span>✉️ Email</span></th>
          <th><span>📞 Teléfono</span></th>
          <th><span>📅 Fecha reserva</span></th>
          <th><span>🔖 Estado</span></th>
          <th><span>💵 Precio total</span></th>
          <th><span>🧑🧒👫 Personas</span></th>
          <th><span>⚙️ Acciones</span></th>
        </tr>
      </thead>
      <tbody>
        {#each reservas as r}
          {#if editandoId === r.id}
            <tr class="editing-row-full">
              <td colspan="8">
                <div class="edit-panel-grid">
                  <div class="edit-field"><label class="edit-label">👤 Nombre</label><input type="text" class="input-edit" bind:value={reservaEdit.nombre_cliente} placeholder="Nombre cliente" /></div>
                  <div class="edit-field"><label class="edit-label">✉️ Email</label><input type="email" class="input-edit" bind:value={reservaEdit.email_cliente} placeholder="Email" /></div>
                  <div class="edit-field"><label class="edit-label">📞 Teléfono</label><input type="text" class="input-edit" bind:value={reservaEdit.telefono_cliente} placeholder="Teléfono" /></div>
                  <div class="edit-field"><label class="edit-label">📅 Fecha reserva</label><input type="date" class="input-edit" bind:value={reservaEdit.fecha_reserva} /></div>
                  <div class="edit-field"><label class="edit-label">🔖 Estado</label><select class="input-edit" bind:value={reservaEdit.estado}><option value="pendiente">Pendiente</option><option value="confirmada">Confirmada</option><option value="cancelada">Cancelada</option></select></div>
                  <div class="edit-field"><label class="edit-label">💵 Precio total</label><input type="number" class="input-edit" bind:value={reservaEdit.precio_total} step="0.01" placeholder="Total" /></div>
                  <div class="edit-field"><label class="edit-label">🧑 Adultos</label><input type="number" class="input-edit mini" bind:value={reservaEdit.cantidad_adultos} min="0" placeholder="Adultos" /></div>
                  <div class="edit-field"><label class="edit-label">🧒 Niños</label><input type="number" class="input-edit mini" bind:value={reservaEdit.cantidad_ninos} min="0" placeholder="Niños" /></div>
                  <div class="edit-field"><label class="edit-label">👫 Parejas</label><input type="number" class="input-edit mini" bind:value={reservaEdit.cantidad_parejas} min="0" placeholder="Parejas" /></div>
                  <div class="edit-field"><label class="edit-label">💲 Precio adulto</label><input type="number" class="input-edit mini" bind:value={reservaEdit.precio_adulto} step="0.01" /></div>
                  <div class="edit-field"><label class="edit-label">💲 Precio niño</label><input type="number" class="input-edit mini" bind:value={reservaEdit.precio_nino} step="0.01" /></div>
                  <div class="edit-field"><label class="edit-label">💲 Precio pareja</label><input type="number" class="input-edit mini" bind:value={reservaEdit.precio_pareja} step="0.01" /></div>
                  <div class="edit-field"><label class="edit-label">💲 Anticipo</label><input type="number" class="input-edit mini" bind:value={reservaEdit.monto_anticipo} step="0.01" /></div>
                  <div class="edit-field"><label class="edit-label">💲 Pendiente</label><input type="number" class="input-edit mini" bind:value={reservaEdit.monto_pendiente} step="0.01" /></div>
                  <div class="edit-field"><label class="edit-label">% Anticipo</label><input type="number" class="input-edit mini" bind:value={reservaEdit.porcentaje_anticipo} min="0" max="100" /></div>
                  <div class="edit-field"><label class="edit-label">🗓️ Días</label><input type="number" class="input-edit mini" bind:value={reservaEdit.cantidad_dias} min="1" /></div>
                  <div class="edit-actions-full">
                    <button class="btn-guardar" on:click={guardarReserva} disabled={cargando}>{cargando ? '...':'💾 Guardar'}</button>
                    <button class="btn-cancelar" on:click={cancelarEdicion}>✖️ Cancelar</button>
                  </div>
                </div>
              </td>
            </tr>
          {:else}
            <tr>
              <td><span title="Nombre cliente">👤</span> {r.nombre_cliente}</td>
              <td><span title="Email">✉️</span> {r.email_cliente}</td>
              <td><span title="Teléfono">📞</span> {r.telefono_cliente}</td>
              <td><span title="Fecha">📅</span> {r.fecha_reserva ? r.fecha_reserva.slice(0,10) : ''}</td>
              <td><span title="Estado">🔖</span> {r.estado}</td>
              <td><span title="Precio total">💵</span> {r.precio_total} USD</td>
              <td>
                <span title="Adultos">🧑</span> {r.cantidad_adultos}
                <span title="Niños">🧒</span> {r.cantidad_ninos}
                <span title="Parejas">👫</span> {r.cantidad_parejas}
              </td>
              <td>
                <button class="btn-editar" title="Editar" on:click={() => editarReserva(r)}>✏️</button>
              </td>
            </tr>
          {/if}
        {/each}
      </tbody>
    </table>

    <!-- Vista móvil: tarjetas -->
    <div class="cards-mobile-reservas">
      {#each reservas as r, i}
        <div class="reserva-card" style="background:{coloresCards[i % coloresCards.length]}">
          {#if editandoId === r.id}
            <form class="edit-card-grid" on:submit|preventDefault={guardarReserva}>
              <div class="edit-grid">
                <div class="edit-field">
                  <label for="nombreEdit">👤 Nombre cliente</label>
                  <input id="nombreEdit" class="edit-input" type="text" bind:value={reservaEdit.nombre_cliente} placeholder="Nombre cliente" />
                </div>
                <div class="edit-field">
                  <label for="emailEdit">✉️ Email</label>
                  <input id="emailEdit" class="edit-input" type="email" bind:value={reservaEdit.email_cliente} placeholder="Email" />
                </div>
                <div class="edit-field">
                  <label for="telEdit">📞 Teléfono</label>
                  <input id="telEdit" class="edit-input" type="text" bind:value={reservaEdit.telefono_cliente} placeholder="Teléfono" />
                </div>
                <div class="edit-field">
                  <label for="fechaEdit">📅 Fecha reserva</label>
                  <input id="fechaEdit" class="edit-input" type="date" bind:value={reservaEdit.fecha_reserva} />
                </div>
                <div class="edit-field">
                  <label for="estadoEdit">🔖 Estado</label>
                  <select id="estadoEdit" class="edit-input" bind:value={reservaEdit.estado}>
                    <option value="pendiente">Pendiente</option>
                    <option value="confirmada">Confirmada</option>
                    <option value="cancelada">Cancelada</option>
                  </select>
                </div>
                <div class="edit-field">
                  <label for="totalEdit">💵 Precio total</label>
                  <input id="totalEdit" class="edit-input" type="number" bind:value={reservaEdit.precio_total} step="0.01" placeholder="Total" />
                </div>
                <div class="edit-field">
                  <label for="adultosEdit">🧑 Adultos</label>
                  <input id="adultosEdit" class="edit-input" type="number" bind:value={reservaEdit.cantidad_adultos} min="0" placeholder="Adultos" />
                </div>
                <div class="edit-field">
                  <label for="ninosEdit">🧒 Niños</label>
                  <input id="ninosEdit" class="edit-input" type="number" bind:value={reservaEdit.cantidad_ninos} min="0" placeholder="Niños" />
                </div>
                <div class="edit-field">
                  <label for="parejasEdit">👫 Parejas</label>
                  <input id="parejasEdit" class="edit-input" type="number" bind:value={reservaEdit.cantidad_parejas} min="0" placeholder="Parejas" />
                </div>
                <div class="edit-field">
                  <label for="padultoEdit">💲 Precio adulto</label>
                  <input id="padultoEdit" class="edit-input" type="number" bind:value={reservaEdit.precio_adulto} step="0.01" placeholder="Adulto" />
                </div>
                <div class="edit-field">
                  <label for="pninoEdit">💲 Precio niño</label>
                  <input id="pninoEdit" class="edit-input" type="number" bind:value={reservaEdit.precio_nino} step="0.01" placeholder="Niño" />
                </div>
                <div class="edit-field">
                  <label for="pparejaEdit">💲 Precio pareja</label>
                  <input id="pparejaEdit" class="edit-input" type="number" bind:value={reservaEdit.precio_pareja} step="0.01" placeholder="Pareja" />
                </div>
                <div class="edit-field">
                  <label for="anticipoEdit">💲 Anticipo</label>
                  <input id="anticipoEdit" class="edit-input" type="number" bind:value={reservaEdit.monto_anticipo} step="0.01" placeholder="Anticipo" />
                </div>
                <div class="edit-field">
                  <label for="pendienteEdit">💲 Pendiente</label>
                  <input id="pendienteEdit" class="edit-input" type="number" bind:value={reservaEdit.monto_pendiente} step="0.01" placeholder="Pendiente" />
                </div>
                <div class="edit-field">
                  <label for="porcentajeEdit">% Anticipo</label>
                  <input id="porcentajeEdit" class="edit-input" type="number" bind:value={reservaEdit.porcentaje_anticipo} min="0" max="100" placeholder="% Anticipo" />
                </div>
                <div class="edit-field">
                  <label for="diasEdit">🗓️ Días</label>
                  <input id="diasEdit" class="edit-input" type="number" bind:value={reservaEdit.cantidad_dias} min="1" placeholder="Días" />
                </div>
              </div>
              <div class="edit-actions">
                <button class="btn-guardar" type="submit" disabled={cargando}>{cargando ? '...':'💾 Guardar'}</button>
                <button class="btn-cancelar" type="button" on:click={cancelarEdicion}>✖️ Cancelar</button>
              </div>
            </form>
          {:else}
            <div class="card-label"><span>👤</span> {r.nombre_cliente}</div>
            <div class="card-label"><span>✉️</span> {r.email_cliente}</div>
            <div class="card-label"><span>📞</span> {r.telefono_cliente}</div>
            <div class="card-label"><span>📅</span> {r.fecha_reserva?.slice(0, 10)}</div>
            <div class="card-label"><span>🔖</span> {r.estado}</div>
            <div class="card-label"><span>💵</span> {r.precio_total} USD</div>
            <div class="card-label"><span>🧑🧒👫</span> {r.cantidad_adultos + r.cantidad_ninos + r.cantidad_parejas}</div>
            <div class="acciones-cards">
              <button class="btn-editar" title="Editar" on:click={() => editarReserva(r)}>✏️ Editar</button>
            </div>
          {/if}
        </div>
      {/each}
    </div>
  {/if}


</div>

<style>
.admin-reservas-wrapper {
  width: 100%;
  margin: 0 auto;
  padding: 2.5rem 1rem 2rem 1rem;
}
.titulo-admin {
  font-size: 2.2em;
  font-weight: bold;
  color: #18e0e9;
  margin-bottom: 0.3em;
  text-align: center;
}
.descripcion-admin {
  color: #444;
}

/* --- MOBILE EDIT FORM --- */
.edit-panel-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.2rem;
  background: #f4fcff;
  border-radius: 14px;
  box-shadow: 0 2px 12px #0001;
  padding: 2rem 1.5rem 1.5rem 1.5rem;
  margin: 0.5rem 0;
}

@media (min-width: 900px) {
  .edit-panel-grid {
    grid-template-columns: 1fr 1fr 1fr;
    gap: 2rem 2.5rem;
    padding: 2.5rem 3rem 2rem 3rem;
  }
}

.edit-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 0.8rem 1.5rem;
}
.edit-field {
  display: flex;
  flex-direction: column;
  margin-bottom: 0.3rem;
}
.edit-field label {
  font-size: 1.07em;
  font-weight: 600;
  color: #057b9a;
  margin-bottom: 0.25em;
  letter-spacing: 0.01em;
}
.edit-input {
  border: 1.5px solid #b2e6f7;
  border-radius: 9px;
  padding: 0.55em 0.9em;
  font-size: 1em;
  background: #fff;
  margin-bottom: 0.1em;
  transition: border 0.2s;
}
.edit-input:focus {
  outline: none;
  border: 1.5px solid #18e0e9;
}
.edit-actions {
  display: flex;
  gap: 1.2em;
  margin-top: 1.2em;
  justify-content: flex-start;
}
.btn-guardar, .btn-cancelar {
  font-size: 1.08em;
  font-weight: 600;
  padding: 0.65em 1.5em;
  border-radius: 8px;
  border: none;
  margin-right: 0.5em;
  cursor: pointer;
  box-shadow: 0 1px 6px 0 #0001;
}
.btn-guardar {
  background: #18e0e9;
  color: #fff;
}
.btn-cancelar {
  background: #fff;
  color: #18e0e9;
  border: 1.5px solid #18e0e9;
}

/* --- RESPONSIVE --- */
@media (min-width: 420px) {
  .edit-grid {
    grid-template-columns: 1fr 1fr;
  }
}
@media (min-width: 900px) {
  .edit-card-grid {
    max-width: 800px;
    padding: 2.5rem 2.5rem 2rem 2.5rem;
  }
  .edit-grid {
    gap: 1.1rem 2.5rem;
  }
}

/* --- ESCRITORIO TABLA --- */
.editing-row, .editing-row-extra {
  background: #e3f9ff;
}
.editing-row input, .editing-row select {
  border-radius: 7px;
  border: 1.5px solid #b2e6f7;
  padding: 0.45em 0.8em;
  font-size: 1em;
  background: #fff;
  margin-bottom: 0.1em;
}
.editing-row input:focus, .editing-row select:focus {
  outline: none;
  border: 1.5px solid #18e0e9;
}
.extra-fields {
  display: flex;
  flex-wrap: wrap;
  gap: 1.2em;
  padding: 0.7em 0.5em 0.7em 0.5em;
}
.extra-fields span {
  display: flex;
  flex-direction: column;
  font-size: 0.98em;
  margin-bottom: 0.2em;
}

/* --- GENERAL --- */
.reserva-card {
  margin-bottom: 1.3em;
}

.error-admin {
  background: #ffe0e0;
  color: #c62828;
  padding: 0.7em 1em;
  border-radius: 7px;
  margin-bottom: 1em;
  text-align: center;
}
.exito-admin {
  background: #e0ffe0;
  color: #2e7d32;
  padding: 0.7em 1em;
  border-radius: 7px;
  margin-bottom: 1em;
  text-align: center;
}
.cargando-admin {
  color: #18e0e9;
  font-weight: 600;
  text-align: center;
  margin-top: 2em;
}
.tabla-admin-reservas {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px #0001;
  overflow: hidden;
  font-size: 1em;
  margin-bottom: 2em;
}
.tabla-admin-reservas th, .tabla-admin-reservas td {
  padding: 1rem 0.7rem;
  text-align: left;
}
.tabla-admin-reservas thead {
  background: #18e0e9;
}
.tabla-admin-reservas th {
  color: #fff;
  font-weight: 600;
  letter-spacing: 0.5px;
  border-bottom: 2px solid #e0f7fa;
}
.tabla-admin-reservas tr {
  transition: background 0.15s;
}
.tabla-admin-reservas tbody tr:hover {
  background: #e0f7fa44;
}
.btn-editar {
  background: none;
  border: none;
  font-size: 1.2em;
  cursor: pointer;
  padding: 0.35em 0.5em;
  border-radius: 6px;
  color: #18e0e9;
  transition: background 0.18s;
}
.btn-editar:hover {
  background: #e0f7fa;
}
.cards-mobile-reservas {
  display: none;
}
@media (max-width: 900px) {
  .tabla-admin-reservas {
    display: none;
  }
  .cards-mobile-reservas {
    display: flex;
    flex-direction: column;
    gap: 1.2em;
    margin-top: 1em;
  }
  .reserva-card {
    border-radius: 15px;
    box-shadow: 0 2px 14px #0001;
    padding: 1.1em 1.2em 1.2em 1.2em;
    display: flex;
    flex-direction: column;
    gap: 0.5em;
    position: relative;
    border-left: 7px solid #18e0e9;
    animation: aparecerCard 0.5s cubic-bezier(.6,-0.28,.74,.05);
  }
  @keyframes aparecerCard {
    from { opacity: 0; transform: translateY(20px) scale(0.98); }
    to { opacity: 1; transform: translateY(0) scale(1); }
  }
  .card-label {
    font-size: 0.97em;
    color: #0097a7;
    font-weight: bold;
    margin-bottom: 0.1em;
  }
  .card-value {
    font-size: 1.07em;
    color: #222;
    margin-bottom: 0.3em;
  }
  .acciones-cards {
    display: flex;
    gap: 8px;
    margin-top: 6px;
  }
  .acciones-cards .btn-editar {
    background: #fff;
    color: #18e0e9;
    border: 1px solid #18e0e9;
    font-size: 1em;
    padding: 0.4em 0.7em;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.18s, color 0.18s;
  }
  .acciones-cards .btn-editar:hover {
    background: #18e0e9;
    color: #fff;
  }
}
/* Modal de edición */
.modal-overlay {
  position: fixed;
  top: 0; left: 0; width: 100vw; height: 100vh;
  background: rgba(0,0,0,0.25);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
}
.modal-editar {
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 24px #0002;
  padding: 2.2em 2em 1.5em 2em;
  min-width: 320px;
  max-width: 95vw;
  width: 100%;
  max-width: 420px;
}
.modal-editar h2 {
  margin-top: 0;
  color: #18e0e9;
  font-size: 1.3em;
  margin-bottom: 1em;
  text-align: center;
}
.form-group {
  margin-bottom: 1em;
  display: flex;
  flex-direction: column;
}
.form-group label {
  font-size: 1em;
  color: #0097a7;
  margin-bottom: 0.2em;
  font-weight: 600;
}
.form-group input, .form-group select {
  padding: 0.5em 0.6em;
  border: 1px solid #e0f7fa;
  border-radius: 7px;
  font-size: 1em;
  outline: none;
  transition: border 0.18s;
}
.form-group input:focus, .form-group select:focus {
  border: 1.5px solid #18e0e9;
}
.acciones-modal {
  display: flex;
  gap: 1em;
  justify-content: flex-end;
  margin-top: 1.2em;
}
.btn-guardar {
  background: #18e0e9;
  color: #fff;
  border: none;
  padding: 0.6em 1.2em;
  border-radius: 7px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.18s;
}
.btn-guardar:disabled {
  background: #b2ebf2;
  color: #fff;
  cursor: not-allowed;
}
.btn-cancelar {
  background: #fff;
  color: #18e0e9;
  border: 1px solid #18e0e9;
  padding: 0.6em 1.2em;
  border-radius: 7px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.18s, color 0.18s;
}
.btn-cancelar:hover {
  background: #18e0e9;
  color: #fff;
}
</style>
