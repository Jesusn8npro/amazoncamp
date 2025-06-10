<script>
  export let tituloPaquete = '';
  export let precioBase = 100;
  export let fechaInicial = '';
  export let adultos = 1;
  export let ninos = 0;
  export let parejas = 0;

  // Detectar si viene del formulario del HOME
  $: desdeHome = (
    (fechaInicial && fechaInicial !== '') ||
    (adultos && adultos !== 1) ||
    (ninos && ninos !== 0) ||
    (parejas && parejas !== 0)
  );

  import { createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';

  // ESTADO PARA MULTI-STEP
  let paso = 1;
  let cargando = false;
  let exito = '';
  let error = '';

  // Paso 1: Reserva
  let fecha = fechaInicial;
  let cantidadAdultos = adultos;
  let cantidadNinos = ninos;
  let cantidadParejas = parejas;

  // Selector de paquete
  let mostrarSelectorPaquete = false;
  export let slug = '';
let paqueteSeleccionado = slug;
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';
  let paquetesDisponibles = [];
  let loadingPaquetes = true;
  let errorPaquetes = '';

  onMount(async () => {
    loadingPaquetes = true;
    // Traer todos los campos necesarios para el cálculo de precios
    const { data, error } = await supabase.from('paquetes').select('id, slug, titulo, precio_adulto, precio_nino, precio_pareja');
    if (error) {
      errorPaquetes = 'No se pudieron cargar los paquetes';
      paquetesDisponibles = [];
    } else {
      paquetesDisponibles = data;
      // Si ya hay un paquete seleccionado, cargar sus precios
      let slug = paqueteSeleccionado || (data[0] && data[0].slug);
      if (slug) cargarPreciosPaquete(slug);
    }
    loadingPaquetes = false;
  });

  // Precios unitarios reactivos
  let precioAdulto = 0;
  let precioNino = 0;
  let precioPareja = 0;

  // Función para cargar los precios del paquete seleccionado
  async function cargarPreciosPaquete(slug) {
    if (!slug) return;
    const { data, error } = await supabase.from('paquetes').select('precio_adulto, precio_nino, precio_pareja').eq('slug', slug).single();
    if (!error && data) {
      precioAdulto = Number(data.precio_adulto) || 0;
      precioNino = Number(data.precio_nino) || 0;
      precioPareja = Number(data.precio_pareja) || 0;
      // LOG para depuración
      console.log('Precios desde Supabase:', {precioAdulto, precioNino, precioPareja, slug});
    } else {
      precioAdulto = precioNino = precioPareja = 0;
      console.error('Error cargando precios:', error, data, slug);
    }
  }

  // Cuando el usuario cambie el selector de paquete
  $: if (paqueteSeleccionado) cargarPreciosPaquete(paqueteSeleccionado);

  function redirigirPaquete() {
    if (paqueteSeleccionado) {
      window.location.href = `/paquetes/${paqueteSeleccionado}`;
    }
  }

  // Paso 2: Cliente
  let nombreCliente = '';
  let emailCliente = '';
  let telefonoCliente = '';

  // Paso 3: Resumen
  $: precioTotal = (cantidadAdultos * precioAdulto) + (cantidadNinos * precioNino) + (cantidadParejas * precioPareja);
$: console.log('Cálculo precio total:', {cantidadAdultos, cantidadNinos, cantidadParejas, precioAdulto, precioNino, precioPareja, precioTotal});

  // Validación de precios
  $: preciosInvalidos = (precioAdulto === 0 && precioNino === 0 && precioPareja === 0);

  const dispatch = createEventDispatcher();

  function siguientePaso() {
    if (paso === 1 && (!fecha || cantidadAdultos < 1)) {
      error = 'Por favor completa la fecha y al menos 1 adulto';
      return;
    }
    if (paso === 2 && (!nombreCliente || !emailCliente || !telefonoCliente)) {
      error = 'Por favor completa todos los datos personales';
      return;
    }
    error = '';
    paso++;
  }
  function pasoAnterior() {
    error = '';
    paso--;
  }

  async function handleSubmit() {
    cargando = true;
    error = '';
    exito = '';
    try {
      // Buscar el paquete seleccionado en la lista de paquetes disponibles
      const paqueteObj = paquetesDisponibles.find(p => p.slug === paqueteSeleccionado);
      const paquete_id = paqueteObj ? paqueteObj.id : null;
      const paquete_titulo = paqueteObj ? paqueteObj.titulo : tituloPaquete;
      // Cálculo de anticipos (20% y 80%)
      const total = Number(precioTotal) || 0;
      const monto_anticipo = Math.round(total * 0.2);
      const monto_pendiente = total - monto_anticipo;
      const porcentaje_anticipo = 20;
      // Prepara los datos de la reserva según la tabla Supabase
      const reserva = {
        paquete_id,
        fecha_reserva: fecha,
        cantidad_adultos: Number(cantidadAdultos) || 0,
        cantidad_ninos: Number(cantidadNinos) || 0,
        cantidad_parejas: Number(cantidadParejas) || 0,
        nombre_cliente: nombreCliente,
        email_cliente: emailCliente,
        telefono_cliente: telefonoCliente,
        estado: 'pendiente',
        precio_adulto: Number(precioAdulto) || 0,
        precio_nino: Number(precioNino) || 0,
        precio_pareja: Number(precioPareja) || 0,
        precio_total: total,
        monto_anticipo,
        monto_pendiente,
        porcentaje_anticipo
      };
      // Limpia los campos undefined o nulos
      Object.keys(reserva).forEach(key => {
        if (reserva[key] === undefined || reserva[key] === null || reserva[key] === '') delete reserva[key];
      });
      console.log('Reserva a enviar (mapeo exacto tabla reservas):', reserva);
      // Limpia los campos undefined
      Object.keys(reserva).forEach(key => {
        if (reserva[key] === undefined) delete reserva[key];
      });
      console.log('Reserva a enviar:', reserva);
      const { data, error: errorSupabase } = await supabase.from('reservas').insert([reserva]);
      if (errorSupabase) {
        error = 'No se pudo registrar la reserva. Intenta nuevamente.';
        console.error('Error al registrar reserva:', errorSupabase);
      } else {
        exito = '¡Reserva registrada con éxito! Pronto nos pondremos en contacto.';
        dispatch('success');
      }
    } catch (e) {
      error = 'Ocurrió un error inesperado.';
      console.error('Excepción al registrar reserva:', e);
    }
    cargando = false;
  }

  function reservarWhatsapp() {
    const mensaje = encodeURIComponent(`Hola, quiero reservar el paquete ${tituloPaquete} para la fecha ${fecha} con ${cantidadAdultos} adulto(s), ${cantidadNinos} niño(s), ${cantidadParejas} pareja(s). Mis datos: ${nombreCliente}, ${emailCliente}, ${telefonoCliente}`);
    window.open(`https://wa.me/51999999999?text=${mensaje}`,'_blank');
  }

  
</script>

<div class="barra-pasos">
  {#if paso === 1}
    <form class="formulario-reserva" on:submit|preventDefault={siguientePaso} transition:fade>
      <div class="barra-pasos">
        <h2>Paso 1: Detalles de la reserva</h2>
        <span class="paso" class:activo={paso === 1}>1</span>
        <span class="paso" class:activo={paso === 2}>2</span>
        <span class="paso" class:activo={paso === 3}>3</span>
      </div>
      <div class="form-titulo">Detalles de la reserva</div>
      {#if desdeHome}
        <div class="mensaje-continua-reserva">¡Continúa tu reserva iniciada!</div>
      {/if}
      <label>Experiencia</label>
      <input type="text" value={tituloPaquete} readonly />
      {#if !mostrarSelectorPaquete}
        <button type="button" class="btn-cambiar-paquete" on:click={() => mostrarSelectorPaquete = true}>¿Quieres elegir otra experiencia?</button>
      {/if}
      <label>Fecha de inicio</label>
      <input type="date" bind:value={fecha} required />
      <label>Personas</label>
      <!-- Aquí va el selector de personas (adultos, niños, parejas) -->
      <div class="precio-total">
        <span>Precio aproximado:</span>
        <span style="color: #13b67a; font-weight: bold;">{precioTotal.toLocaleString('en-US', { style: 'currency', currency: 'USD' })}</span>
      </div>
      {#if preciosInvalidos}
        <div class="mensaje-error" style="margin-bottom: 10px;">
          Este paquete no tiene precios configurados. Por favor, contacta a Amazon Camp o selecciona otra experiencia.
        </div>
      {/if}
      {#if mostrarSelectorPaquete}
        {#if loadingPaquetes}
          <div class="input-fijo">Cargando experiencias...</div>
        {:else if errorPaquetes}
          <div class="input-fijo error">{errorPaquetes}</div>
        {:else}
          <select bind:value={paqueteSeleccionado} class="selector-paquete">
            <option value="" disabled selected>Selecciona otra experiencia</option>
            {#each paquetesDisponibles as p}
              <option value={p.slug}>{p.titulo}</option>
            {/each}
          </select>
          <button type="button" class="btn-ir-paquete" on:click={redirigirPaquete}>Ir a experiencia seleccionada</button>
        {/if}
      {/if}
      <label>Fecha de inicio</label>
      <input type="date" bind:value={fecha} required />
      <label>Personas</label>
      <div class="fila-numeros">
        <div>
          <label>Adultos <span style="color:#888;font-weight:400">(13+ años)</span></label>
          <div class="controles">
            <button type="button" on:click={() => cantidadAdultos = Math.max(1, cantidadAdultos - 1)} disabled={cantidadAdultos <= 1}>-</button>
            <span>{cantidadAdultos}</span>
            <button type="button" on:click={() => cantidadAdultos++}>+</button>
          </div>
        </div>
        <div>
          <label>Niños <span style="color:#888;font-weight:400">(2-12 años)</span></label>
          <div class="controles">
            <button type="button" on:click={() => cantidadNinos = Math.max(0, cantidadNinos - 1)} disabled={cantidadNinos <= 0}>-</button>
            <span>{cantidadNinos}</span>
            <button type="button" on:click={() => cantidadNinos++}>+</button>
          </div>
        </div>
        <div>
          <label>Parejas <span style="color:#888;font-weight:400">(2 adultos)</span></label>
          <div class="controles">
            <button type="button" on:click={() => cantidadParejas = Math.max(0, cantidadParejas - 1)} disabled={cantidadParejas <= 0}>-</button>
            <span>{cantidadParejas}</span>
            <button type="button" on:click={() => cantidadParejas++}>+</button>
          </div>
        </div>
      </div>
      {#if error}
        <div class="mensaje-error">{error}</div>
      {/if}
      <div class="botones-multistep">
        <button type="submit" class="btn-siguiente">Siguiente</button>
      </div>
    </form>
  {/if}
  {#if paso === 2}
    <form class="formulario-reserva" on:submit|preventDefault={siguientePaso} transition:fade>
      <div class="barra-pasos">
        <h2>Paso 2: Datos personales</h2>
        <span class="paso" class:activo={paso === 1}>1</span>
        <span class="paso" class:activo={paso === 2}>2</span>
        <span class="paso" class:activo={paso === 3}>3</span>
      </div>
      <div class="form-titulo">Datos personales</div>
      <label>Nombre completo</label>
      <input type="text" bind:value={nombreCliente} required />
      <label>Correo electrónico</label>
      <input type="email" bind:value={emailCliente} required />
      <label>Teléfono</label>
      <input type="tel" bind:value={telefonoCliente} required />
      {#if error}
        <div class="mensaje-error">{error}</div>
      {/if}
      <div class="botones-multistep">
        <button type="button" class="btn-anterior" on:click={pasoAnterior}>Anterior</button>
        <button type="submit" class="btn-siguiente">Siguiente</button>
      </div>
    </form>
  {/if}
  {#if paso === 3}
    <form class="formulario-reserva" on:submit|preventDefault={handleSubmit} transition:fade>
      <div class="barra-pasos">
        <h2>Paso 3: Confirmar reserva</h2>
        <span class="paso" class:activo={paso === 1}>1</span>
        <span class="paso" class:activo={paso === 2}>2</span>
        <span class="paso" class:activo={paso === 3}>3</span>
      </div>
      <div class="form-titulo">Confirmar reserva</div>
      <div class="resumen">
        <b>Paquete:</b> {tituloPaquete}<br />
        <b>Fecha:</b> {fecha}<br />
        <b>Adultos:</b> {cantidadAdultos} | <b>Niños:</b> {cantidadNinos} | <b>Parejas:</b> {cantidadParejas}<br />
        <b>Nombre:</b> {nombreCliente}<br />
        <b>Email:</b> {emailCliente}<br />
        <b>Teléfono:</b> {telefonoCliente}<br />
        <b>Total estimado:</b> S/ {precioTotal.toFixed(2)}
      </div>
      <div class="opciones-finales">
        <button type="button" class="btn-pago" disabled>Anticipar 20% (Próximamente)</button>
        <button type="button" class="btn-wa" on:click={reservarWhatsapp}>Reservar por WhatsApp</button>
      </div>
      <div class="botones-multistep">
        <button type="button" class="btn-anterior" on:click={pasoAnterior}>Anterior</button>
        <button type="submit" class="btn-siguiente" disabled={cargando}>{cargando ? 'Enviando...' : 'Confirmar reserva'}</button>
      </div>
      {#if exito}
        <div class="mensaje-exito">{exito}</div>
      {/if}
      {#if error}
        <div class="mensaje-error">{error}</div>
      {/if}
    </form>
  {/if}
</div>

<style>
.formulario-multistep {
  width: 100%;
  max-width: 420px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 6px 32px rgba(0,0,0,0.15);
  padding: 40px 32px 32px 32px;
  z-index: 2;
  animation: fadeInForm 0.6s;
}

@keyframes fadeInForm {
  from { opacity: 0; transform: translateY(30px); }
  to { opacity: 1; transform: none; }
}

.barra-pasos {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-bottom: 28px;
}
.paso {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  background: #f3f4f6;
  color: #ea580c;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  font-size: 1.22em;
  border: 2.5px solid #ea580c44;
  transition: background 0.25s, color 0.25s, border 0.25s;
  box-shadow: 0 2px 8px rgba(234,88,12,0.07);
  position: relative;
  z-index: 1;
}
.paso.activo {
  background: #ea580c;
  color: #fff;
  border: 2.5px solid #ea580c;
  box-shadow: 0 4px 16px #ea580c22;
}
.barra-pasos .paso:not(:last-child)::after {
  content: '';
  position: absolute;
  right: -28px;
  top: 50%;
  transform: translateY(-50%);
  width: 32px;
  height: 4px;
  background: linear-gradient(90deg, #ea580c44 0%, #ea580c 100%);
  border-radius: 2px;
  z-index: 0;
}
.formulario-reserva {
  display: flex;
  flex-direction: column;
  gap: 19px;
  width: 100%;
  animation: fadeInStep 0.5s;
}
@keyframes fadeInStep {
  from { opacity: 0; transform: translateY(18px); }
  to { opacity: 1; transform: none; }
}
.form-titulo {
  font-size: 1.35rem;
  font-weight: 700;
  color: #ea580c;
  margin-bottom: 10px;
  letter-spacing: 0.5px;
}

.btn-cambiar-paquete {
  background: none;
  color: #ea580c;
  border: none;
  cursor: pointer;
  font-size: 1em;
  margin-bottom: 7px;
  text-decoration: underline;
  padding: 0;
}
.selector-paquete {
  margin-bottom: 7px;
  padding: 8px 12px;
  border-radius: 8px;
  border: 1.5px solid #ea580c88;
  font-size: 1em;
}
.btn-ir-paquete {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  color: #fff;
  border: none;
  border-radius: 8px;
  padding: 8px 16px;
  font-size: 1em;
  cursor: pointer;
  margin-bottom: 10px;
  margin-left: 6px;
}
.btn-ir-paquete:hover {
  background: linear-gradient(90deg, #fbbf24 0%, #ea580c 100%);
}
.fila-numeros {
  display: flex;
  gap: 13px;
}
.fila-numeros > div {
  flex: 1;
}
.input-fijo {
  background: #f9fafb;
  border-radius: 8px;
  padding: 10px 14px;
  font-weight: 500;
  color: #0a3b4e;
  margin-bottom: 6px;
}
label {
  font-weight: 600;
  color: #222;
  font-size: 1rem;
  margin-bottom: 2px;
}
input[type="date"],
input[type="number"],
input[type="text"],
input[type="email"],
input[type="tel"] {
  border: 1.8px solid #e5e7eb;
  border-radius: 8px;
  padding: 12px 15px;
  font-size: 1.04rem;
  margin-top: 3px;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
  background: #f8fafc;
}
input:focus {
  border: 2px solid #ea580c;
  box-shadow: 0 0 0 2px #ea580c33;
}
.precio-total {
  font-size: 1.08em;
  color: #13b67a;
  font-weight: bold;
  margin-top: 8px;
  background: #ebfaf4;
  border-radius: 7px;
  padding: 8px 13px;
}
.botones-multistep {
  display: flex;
  gap: 14px;
  margin-top: 10px;
  justify-content: flex-end;
}
.btn-siguiente, .btn-anterior, .btn-pago, .btn-wa {
  padding: 11px 20px;
  border: none;
  border-radius: 8px;
  font-size: 1.07em;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.18s, box-shadow 0.18s, color 0.18s;
  box-shadow: 0 2px 10px rgba(234,88,12,0.07);
}
.btn-siguiente {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  color: #fff;
}
.btn-siguiente:hover {
  background: linear-gradient(90deg, #fbbf24 0%, #ea580c 100%);
}
.btn-anterior {
  background: #f3f4f6;
  color: #ea580c;
  border: 1.3px solid #ea580c44;
}
.btn-anterior:hover {
  background: #ffe8d7;
}
.btn-pago {
  background: #13b67a;
  color: #fff;
  opacity: 0.7;
  cursor: not-allowed;
}
.btn-wa {
  background: #25d366;
  color: #fff;
}
.btn-wa:hover {
  background: #128c7e;
}
.resumen {
  background: #f9fafb;
  border-radius: 10px;
  padding: 17px 15px;
  margin-bottom: 14px;
  font-size: 1.08em;
  box-shadow: 0 2px 10px #ea580c11;
  color: #0a3b4e;
}
.opciones-finales {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 10px;
}
.mensaje-error {
  color: #e01818;
  background: #ffeaea;
  border-radius: 6px;
  padding: 8px 12px;
  margin-top: 6px;
  font-size: 0.97em;
  font-weight: 600;
}
.mensaje-exito {
  color: #13b67a;
  background: #e0f7fa;
  border-radius: 6px;
  padding: 8px 12px;
  margin-top: 6px;
  font-size: 0.97em;
  font-weight: 600;
}
@media (max-width: 600px) {
  .formulario-multistep {
    padding: 20px 7px 18px 7px;
    max-width: 100vw;
  }
  .resumen {
    font-size: 0.98em;
    padding: 10px 5px;
  }
}


.precio-total {
  font-size: 1.1rem;
  color: #14532d;
  background: #e0f2fe;
  border-radius: 8px;
  padding: 9px 13px;
  margin: 7px 0 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.btn-reservar {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  color: #fff;
  font-weight: 800;
  font-size: 1.07rem;
  border: none;
  border-radius: 9px;
  padding: 13px 0;
  margin-top: 10px;
  cursor: pointer;
  box-shadow: 0 2px 10px rgba(234,88,12,0.10);
  transition: background 0.2s;
}
.btn-reservar:hover {
  background: linear-gradient(90deg, #fbbf24 0%, #ea580c 100%);
}
.mensaje-error {
  color: #dc2626;
  font-weight: 700;
  margin-top: 7px;
}
.mensaje-exito {
  color: #16a34a;
  font-weight: 700;
  margin-top: 7px;
}
</style>
