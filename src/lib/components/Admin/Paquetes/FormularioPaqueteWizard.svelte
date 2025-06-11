<script>
  import { createEventDispatcher, onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  const dispatch = createEventDispatcher();

  // Estado de los pasos
  let paso = 1;
  let totalPasos = 3;

  // Estado del formulario (campos reales)
  let titulo = '';
  let descripcion = '';
  let descripcion_corta = '';
  let beneficios = '';
  let incluye = '';
  let ventajas = '';
  let imagen_principal = '';
  let imagen_principal_url = '';
  let galeria = '';
  let galeriaFiles = [];
  let precio_desde = '';
  let precio_adulto = '';
  let precio_nino = '';
  let precio_pareja = '';
  let duracion = '';
  let ubicacion = '';
  let destacado = false;
  let imagenFile = null;
  let loading = false;
  let error = '';
  let success = '';
  let exito = false;
  let debugData = null;
  let debugResponse = null;
  $: debug = { dataPaquete: debugData, respuesta: debugResponse };

  // Si recibes datos para editar
  export let paqueteEditar = null;

  onMount(() => {
    if (paqueteEditar) {
      titulo = paqueteEditar.titulo || '';
      descripcion = paqueteEditar.descripcion || '';
      descripcion_corta = paqueteEditar.descripcion_corta || '';
      beneficios = (paqueteEditar.beneficios || []).join(', ');
      incluye = (paqueteEditar.incluye || []).join(', ');
      ventajas = (paqueteEditar.ventajas || []).join(', ');
      imagen_principal = paqueteEditar.imagen_principal || '';
      galeria = (paqueteEditar.galeria || []).join(', ');
      precio_desde = paqueteEditar.precio_desde || '';
      precio_adulto = paqueteEditar.precio_adulto || '';
      precio_nino = paqueteEditar.precio_nino || '';
      precio_pareja = paqueteEditar.precio_pareja || '';
      duracion = paqueteEditar.duracion || '';
      ubicacion = paqueteEditar.ubicacion || '';
      destacado = !!paqueteEditar.destacado;
    }
  });

  // Galería URLs
  let galeriaUrls = [];
  $: galeriaUrls = galeria ? galeria.split(',').map(x => x.trim()).filter(Boolean) : [];

  function handleGaleriaFiles(e) {
    const nuevos = Array.from(e.target.files).filter(newFile =>
      !galeriaFiles.some(f => f.name === newFile.name && f.size === newFile.size)
    ).map(file => {
      file.previewUrl = URL.createObjectURL(file);
      return file;
    });
    galeriaFiles = [...galeriaFiles, ...nuevos];
  }
  function removeGaleriaUrl(idx) {
    galeriaUrls = galeriaUrls.filter((_, i) => i !== idx);
    galeria = galeriaUrls.join(', ');
  }
  function removeGaleriaImg(idx) {
    galeriaFiles = galeriaFiles.filter((_, i) => i !== idx);
  }
  async function handleImageUpload(e) {
    imagenFile = e.target.files[0];
    if (imagenFile) {
      const filePath = `paquetes/${Date.now()}_${imagenFile.name}`;
      const { data, error: uploadError } = await supabase.storage.from('paquetes-fotos-principales').upload(filePath, imagenFile);
      if (uploadError) {
        error = 'Error al subir imagen: ' + (uploadError.message || uploadError.error_description || 'Error desconocido');
        debugData = { archivo: imagenFile, filePath, respuesta: uploadError };
        return;
      }
      imagen_principal = supabase.storage.from('paquetes-fotos-principales').getPublicUrl(filePath).data.publicUrl;
    }
  }

  function siguientePaso() {
    if (validarPaso(paso)) {
      paso = Math.min(paso + 1, totalPasos);
    }
  }
  function pasoAnterior() {
    paso = Math.max(paso - 1, 1);
  }

  function validarPaso(p) {
    error = '';
    if (p === 1) {
      if (!titulo) error = 'El título es obligatorio';
      else if (!descripcion_corta) error = 'La descripción corta es obligatoria';
      else if (!ubicacion) error = 'La ubicación es obligatoria';
      else if (!duracion) error = 'La duración es obligatoria';
    }
    if (p === 2) {
      if (!descripcion) error = 'La descripción es obligatoria';
      else if (!beneficios) error = 'Beneficios es obligatorio';
      else if (!incluye) error = 'Incluye es obligatorio';
      else if (!ventajas) error = 'Ventajas es obligatorio';
    }
    if (p === 3) {
      if (!precio_desde) error = 'El precio desde es obligatorio';
      else if (!precio_adulto) error = 'El precio por adulto es obligatorio';
      else if (!precio_nino) error = 'El precio por niño es obligatorio';
      else if (!precio_pareja) error = 'El precio por pareja es obligatorio';
      else if (!imagen_principal && !imagen_principal_url) error = 'Debes subir o pegar una URL de imagen principal';
    }
    return !error;
  }

  function slugify(text) {
    return text
      .toString()
      .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  async function submitFormulario() {
    if (!validarPaso(3)) {
      paso = 3;
      return;
    }
    loading = true;
    error = '';
    debugData = null;
    debugResponse = null;
    try {
      // Procesar arrays desde input string
      const beneficiosArr = beneficios ? beneficios.split(',').map(x => x.trim()).filter(Boolean) : [];
      const incluyeArr = incluye ? incluye.split(',').map(x => x.trim()).filter(Boolean) : [];
      const ventajasArr = ventajas ? ventajas.split(',').map(x => x.trim()).filter(Boolean) : [];
      // Galería: combinar URLs y archivos
      let galeriaArr = [...galeriaUrls];
      if (galeriaFiles && galeriaFiles.length > 0) {
        try {
          const uploads = galeriaFiles.map(file => {
            const filePath = `galeria/${Date.now()}_${file.name}`;
            return supabase.storage.from('paquetes-galeria').upload(filePath, file)
              .then(({ data, error: uploadError }) => {
                if (uploadError) {
                  throw {file, filePath, uploadError};
                }
                return supabase.storage.from('paquetes-galeria').getPublicUrl(filePath).data.publicUrl;
              });
          });
          const urls = await Promise.all(uploads);
          galeriaArr = [...galeriaArr, ...urls];
        } catch (err) {
          error = 'Error al subir imagen de galería: ' + (err?.uploadError?.message || err?.uploadError?.error_description || err?.message || 'Error desconocido');
          debugData = { archivo: err?.file, filePath: err?.filePath, respuesta: err?.uploadError };
          loading = false;
          return;
        }
      }
      // Imagen principal: usar archivo o URL
      let imagenPrincipalFinal = imagen_principal;
      if (imagen_principal_url && imagen_principal_url.trim() !== '') {
        imagenPrincipalFinal = imagen_principal_url.trim();
      }
      // Armar objeto para Supabase
      const slug = slugify(titulo);
      const dataPaquete = {
        slug,
        titulo,
        descripcion,
        descripcion_corta,
        beneficios: beneficiosArr,
        incluye: incluyeArr,
        ventajas: ventajasArr,
        imagen_principal: imagenPrincipalFinal,
        galeria: galeriaArr,
        precio_desde,
        precio_adulto: precio_adulto !== '' ? Number(precio_adulto) : 0,
        precio_nino: precio_nino !== '' ? Number(precio_nino) : 0,
        precio_pareja: precio_pareja !== '' ? Number(precio_pareja) : 0,
        duracion,
        ubicacion,
        destacado
      };
      debugData = JSON.parse(JSON.stringify(dataPaquete));
      let res;
      if (paqueteEditar && paqueteEditar.id) {
        res = await supabase.from('paquetes').update(dataPaquete).eq('id', paqueteEditar.id);
      } else {
        res = await supabase.from('paquetes').insert([dataPaquete]);
      }
      debugResponse = res;
      if (res.error) {
        error = 'Error al guardar paquete: ' + res.error.message;
        success = '';
      } else {
        success = '¡Paquete guardado exitosamente!';
        setTimeout(() => success = '', 3500);
        exito = true;
        dispatch('guardado');
      }
    } catch (e) {
      error = 'Error inesperado al guardar: ' + (e?.message || JSON.stringify(e));
    } finally {
      loading = false;
    }
  }
</script>


<style>
  .wizard-container {
    max-width: 700px;
    margin: 0 auto;
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 4px 32px rgba(24, 224, 233, 0.10), 0 2px 16px #0001;
    padding: 1.2rem 1.1rem 1.2rem 1.1rem;
    position: relative;
    min-height: 0;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    width: 100%;
  }
  .wizard-close {
    position: absolute;
    top: 18px;
    right: 18px;
    background: none;
    border: none;
    font-size: 1.6em;
    color: #18e0e9;
    cursor: pointer;
    z-index: 2;
    transition: color 0.2s;
  }
  .wizard-close:hover {
    color: #13b67a;
  }
  .wizard-steps {
    display: flex;
    justify-content: space-between;
    margin-bottom: 2.2rem;
    gap: 0.7rem;
  }
  .wizard-step {
    flex: 1;
    text-align: center;
    font-weight: 700;
    color: #bbb;
    border-bottom: 2.5px solid #eee;
    padding-bottom: 0.7rem;
    font-size: 1.06em;
    letter-spacing: 0.5px;
    transition: color 0.2s, border-color 0.2s;
  }
  .wizard-step.active {
    color: #18e0e9;
    border-bottom: 2.5px solid #18e0e9;
    background: none;
  }
  .wizard-fields {
    padding-left: 1.2rem;
    padding-right: 1.2rem;
  }
  .wizard-fields label {
    display: flex;
    flex-direction: column;
    font-weight: 600;
    color: #222;
    margin-bottom: 1.2rem;
    font-size: 1.04em;
  }

  @media (max-width: 600px) {
  .wizard-container {
    padding: 18px 3vw 18px 3vw;
    border-radius: 0.9rem;
    max-width: 100vw;
    margin: 0px;
    min-width: 0;
    box-sizing: border-box;
    font-size: 1.13em;
  }
  .wizard-steps {
    font-size: 1.12em;
    margin-bottom: 2.2rem;
  }
  .wizard-fields,
  .wizard-fields label {
    font-size: 1.09em;
  }
  .wizard-fields label {
    margin-bottom: 1.5rem;
    display: block;
  }
  .wizard-fields input,
  .wizard-fields textarea {
    font-size: 1.11em;
    padding: 1.18em 1em;
    border-radius: 13px;
    width: 100%;
    min-height: 2.8em;
    margin-top: 0.22em;
  }
  .wizard-actions button {
    font-size: 1.09em;
    padding: 1.13em 2.6em;
    border-radius: 13px;
  }
}

  .wizard-fields input,
  .wizard-fields textarea {
    margin-top: 0.45rem;
    padding: 20px;
    border-radius: 10px;
    border: 1.5px solid #e0e0e0;
    font-size: 1em;
    background: #f8fcfd;
    transition: border-color 0.2s;
    outline: none;
  }
  .wizard-fields input:focus,
  .wizard-fields textarea:focus {
    border-color: #18e0e9;
    background: #f0fcff;
  }
  .wizard-fields .text-red-500 {
    margin-top: 0.3rem;
    font-size: 0.93em;
    color: #e53e3e;
    font-weight: 500;
  }
  .wizard-actions {
    display: flex;
    justify-content: flex-end;
    gap: 1rem;
    margin-top: 1.5rem;
  }
  .wizard-actions button {
    padding: 0.9rem 2.2rem;
    border-radius: 10px;
    border: none;
    font-size: 1.08em;
    font-weight: 700;
    background: linear-gradient(90deg, #18e0e9 0%, #13b67a 100%);
    color: #fff;
    box-shadow: 0 2px 10px #18e0e922;
    cursor: pointer;
    transition: background 0.2s, transform 0.15s;
  }
  .wizard-actions button:active {
    transform: scale(0.97);
  }
  .wizard-actions .btn {
    background: #e0e0e0;
    color: #555;
    font-weight: 600;
  }
  .wizard-actions .btn.btn-primary {
    background: linear-gradient(90deg, #18e0e9 0%, #13b67a 100%);
    color: #fff;
  }
  .wizard-actions .btn.btn-success {
    background: linear-gradient(90deg, #13b67a 0%, #18e0e9 100%);
    color: #fff;
  }
  .wizard-fields img {
    margin: 1rem 0 0.5rem 0;
    border-radius: 10px;
    max-width: 240px;
    box-shadow: 0 2px 10px #18e0e922;
    display: block;
  }
  .wizard-fields ul {
    margin-bottom: 1.2rem;
  }
  .wizard-fields li {
    margin-bottom: 0.5rem;
  }
  .text-center {
    text-align: center;
  }
  @media (max-width: 900px) {
    .wizard-container {
      max-width: 95vw;
  }
  .wizard-fields input:focus,
  .wizard-fields textarea:focus {
    border-color: #18e0e9;
    background: #f0fcff;
  }
  .wizard-fields .text-red-500 {
    margin-top: 0.3rem;
    font-size: 0.93em;
    color: #e53e3e;
    font-weight: 500;
  }
</style>

<div class="wizard-container">
  <!-- Pasos visuales -->
  <div class="wizard-steps">
    <div class="wizard-step {paso === 1 ? 'active' : ''}">1. Básicos</div>
    <div class="wizard-step {paso === 2 ? 'active' : ''}">2. Detalles</div>
    <div class="wizard-step {paso === 3 ? 'active' : ''}">3. Imagen</div>
    <div class="wizard-step {paso === 4 ? 'active' : ''}">4. Confirmar</div>
  </div>

  {#if !exito}
    <!-- Paso 1: Básicos -->
    {#if paso === 1}
      <div class="wizard-fields paso-1">
        <label>Título del paquete
          <input type="text" bind:value={titulo} placeholder="Título..." />
          {#if error && paso === 1 && error.includes('título')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Descripción corta
          <input type="text" bind:value={descripcion_corta} placeholder="Descripción corta..." />
          {#if error && paso === 1 && error.includes('corta')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Ubicación
          <input type="text" bind:value={ubicacion} placeholder="Ubicación..." />
          {#if error && paso === 1 && error.includes('ubicación')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Duración
          <input type="text" bind:value={duracion} placeholder="Duración..." />
          {#if error && paso === 1 && error.includes('duración')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label class="flex items-center gap-2 mt-2">
          <input type="checkbox" bind:checked={destacado} />
          Destacado
        </label>
      </div>
    {/if}
    <!-- Paso 2: Detalles -->
    {#if paso === 2}
      <div class="wizard-fields paso-2">
        <label>Descripción
          <textarea bind:value={descripcion} placeholder="Descripción..." rows="2"></textarea>
          {#if error && paso === 2 && error.includes('descripción')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Beneficios (separados por coma)
          <input type="text" bind:value={beneficios} placeholder="Beneficios..." />
        </label>
        <label>Incluye (separados por coma)
          <input type="text" bind:value={incluye} placeholder="Incluye..." />
        </label>
        <label>Ventajas (separados por coma)
          <input type="text" bind:value={ventajas} placeholder="Ventajas..." />
        </label>
      </div>
    {/if}
    <!-- Paso 3: Imagen -->
    {#if paso === 3}
      <div class="wizard-fields paso-3">
        <label>Precio desde (USD)
          <input type="number" bind:value={precio_desde} min="0" step="0.01" placeholder="Precio desde..." />
          {#if error && paso === 3 && error.includes('precio')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Precio por adulto (USD)
          <input type="number" bind:value={precio_adulto} min="0" step="0.01" placeholder="Precio por adulto..." />
          {#if error && paso === 3 && error.includes('adulto')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Precio por niño (USD)
          <input type="number" bind:value={precio_nino} min="0" step="0.01" placeholder="Precio por niño..." />
          {#if error && paso === 3 && error.includes('niño')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Precio por pareja (USD)
          <input type="number" bind:value={precio_pareja} min="0" step="0.01" placeholder="Precio por pareja..." />
          {#if error && paso === 3 && error.includes('pareja')}<span class="text-red-500 text-xs">{error}</span>{/if}
        </label>
        <label>Imagen principal
          <input type="file" accept="image/*" on:change={handleImageUpload} />
        </label>
        <label class="mt-2">O pega una URL de imagen principal
          <input type="text" bind:value={imagen_principal_url} placeholder="URL de imagen principal..." />
        </label>
        {#if imagen_principal}
          <img src={imagen_principal} alt="Imagen principal" style="max-width: 180px; margin: 1rem 0; border-radius: 8px;" />
        {/if}
        <label class="mt-4">Galería de imágenes
          <input type="file" accept="image/*" multiple on:change={handleGaleriaFiles} />
        </label>
        {#if galeriaUrls.length > 0}
          <div class="galeria-preview">
            {#each galeriaUrls as url, idx}
              <div style="position:relative;display:inline-block;">
                <img src={url} alt="Galería" style="max-width:80px;max-height:80px;border-radius:6px;margin:4px;" />
                <button type="button" class="btn btn-xs btn-danger" style="position:absolute;top:0;right:0;" on:click={() => removeGaleriaUrl(idx)}>x</button>
              </div>
            {/each}
          </div>
        {/if}
        {#if galeriaFiles.length > 0}
          <div class="galeria-preview">
            {#each galeriaFiles as file, idx}
              <div style="position:relative;display:inline-block;">
                <img src={file.previewUrl} alt="Nueva galería" style="max-width:80px;max-height:80px;border-radius:6px;margin:4px;" />
                <button type="button" class="btn btn-xs btn-danger" style="position:absolute;top:0;right:0;" on:click={() => removeGaleriaImg(idx)}>x</button>
              </div>
            {/each}
          </div>
        {/if}
        {#if error && paso === 3}<span class="text-red-500 text-xs">{error}</span>{/if}
      </div>
    {/if}
    <!-- Paso 4: Confirmar -->
    {#if paso === 4}
      <div class="wizard-fields">
        <h3 class="font-semibold mb-2">Revisa tus datos:</h3>
        <ul class="mb-3 text-sm">
          <li><b>Título:</b> {titulo}</li>
          <li><b>Descripción:</b> {descripcion}</li>
          <li><b>Descripción corta:</b> {descripcion_corta}</li>
          <li><b>Beneficios:</b> {beneficios}</li>
          <li><b>Incluye:</b> {incluye}</li>
          <li><b>Ventajas:</b> {ventajas}</li>
          <li><b>Precio desde:</b> {precio_desde} USD</li>
          <li><b>Precio adulto:</b> {precio_adulto} USD</li>
          <li><b>Precio niño:</b> {precio_nino} USD</li>
          <li><b>Precio pareja:</b> {precio_pareja} USD</li>
          <li><b>Duración:</b> {duracion}</li>
          <li><b>Ubicación:</b> {ubicacion}</li>
          <li><b>Destacado:</b> {destacado ? 'Sí' : 'No'}</li>
        </ul>
        {#if imagen_principal}
          <div class="mb-2"><b>Imagen principal:</b><br><img src={imagen_principal} alt="Imagen principal" style="max-width:120px;border-radius:8px;" /></div>
        {/if}
        {#if galeriaUrls.length > 0 || galeriaFiles.length > 0}
          <div class="mb-2"><b>Galería:</b><br>
            {#each galeriaUrls as url}
              <img src={url} alt="Galería" style="max-width:60px;max-height:60px;border-radius:5px;margin:2px;" />
            {/each}
            {#each galeriaFiles as file}
              <img src={file.previewUrl} alt="Nueva galería" style="max-width:60px;max-height:60px;border-radius:5px;margin:2px;" />
            {/each}
          </div>
        {/if}
        {#if error && paso === 4}<span class="text-red-500 text-xs">{error}</span>{/if}
      </div>
    {/if}
    <!-- Botones de navegación -->
    <div class="wizard-actions mt-4">
      {#if paso > 1 && paso <= totalPasos}
        <button type="button" on:click={pasoAnterior} class="btn">Anterior</button>
      {/if}
      {#if paso < totalPasos}
        <button type="button" on:click={siguientePaso} class="btn btn-primary">Siguiente</button>
      {:else}
        <button type="button" on:click={submitFormulario} class="btn btn-success" disabled={loading}>
          {loading ? 'Guardando...' : 'Guardar'}
        </button>
      {/if}
    </div>
  {/if}
  {#if exito}
    <div class="text-center py-10">
      <svg width="64" height="64" fill="none" viewBox="0 0 24 24" class="mx-auto mb-4"><path d="M5 13l4 4L19 7" stroke="#6c3dff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
      <h2 class="text-lg font-semibold mb-2">¡Paquete guardado exitosamente!</h2>
      <p class="text-gray-600">Puedes cerrar este formulario o crear otro paquete.</p>
    </div>
  {/if}
</div>
