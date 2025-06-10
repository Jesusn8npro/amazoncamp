<script>
  import { createEventDispatcher } from 'svelte';
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';
  // Función slugify local
  function slugify(text) {
    return text
      .toString()
      .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .trim()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }

  export let paquete = null; // Si es edición, recibe el paquete

  const dispatch = createEventDispatcher();

  // CAMPOS REALES DE LA TABLA PAQUETES
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
  let debugData = null;
  let debugResponse = null;
  $: debug = {dataPaquete: debugData, respuesta: debugResponse};

  // Si es edición, precarga datos
  onMount(() => {
    if (paquete) {
      titulo = paquete.titulo;
      descripcion = paquete.descripcion;
      descripcion_corta = paquete.descripcion_corta || '';
      beneficios = (paquete.beneficios || []).join(', ');
      incluye = (paquete.incluye || []).join(', ');
      ventajas = (paquete.ventajas || []).join(', ');
      imagen_principal = paquete.imagen_principal;
      galeria = (paquete.galeria || []).join(', ');
      precio_desde = paquete.precio_desde;
      precio_adulto = paquete.precio_adulto || '';
      precio_nino = paquete.precio_nino || '';
      precio_pareja = paquete.precio_pareja || '';
      duracion = paquete.duracion;
      ubicacion = paquete.ubicacion;
      destacado = paquete.destacado;
    }
  });


  async function handleImageUpload(e) {
    imagenFile = e.target.files[0];
    if (imagenFile) {
      const filePath = `paquetes/${Date.now()}_${imagenFile.name}`;
      console.log('Archivo a subir:', imagenFile);
      console.log('Ruta destino:', filePath);
      // Usar el bucket correcto para imagen principal
      const { data, error: uploadError } = await supabase.storage.from('paquetes-fotos-principales').upload(filePath, imagenFile);
      console.log('Respuesta Supabase:', { data, uploadError });
      if (uploadError) {
        error = 'Error al subir imagen: ' + (uploadError.message || uploadError.error_description || 'Error desconocido');
        debugData = { archivo: imagenFile, filePath, respuesta: uploadError };
        return;
      }
      imagen_principal = supabase.storage.from('paquetes-fotos-principales').getPublicUrl(filePath).data.publicUrl;
    }
  }

  function handleGaleriaFiles(e) {
    const nuevos = Array.from(e.target.files).filter(newFile =>
      !galeriaFiles.some(f => f.name === newFile.name && f.size === newFile.size)
    ).map(file => {
      file.previewUrl = URL.createObjectURL(file);
      return file;
    });
    galeriaFiles = [...galeriaFiles, ...nuevos];
  }

  // Manejar URLs ya guardadas
  let galeriaUrls = [];
  $: galeriaUrls = galeria ? galeria.split(',').map(x => x.trim()).filter(Boolean) : [];

  function removeGaleriaUrl(idx) {
    galeriaUrls = galeriaUrls.filter((_, i) => i !== idx);
    galeria = galeriaUrls.join(', ');
  }

  function removeGaleriaImg(idx) {
    galeriaFiles = galeriaFiles.filter((_, i) => i !== idx);
  }

  async function guardarPaquete() {
    loading = true;
    error = '';
    debugData = null;
    debugResponse = null;
    try {
      // Validación de campos obligatorios
      if (!titulo || !descripcion || !descripcion_corta || (!imagen_principal && !imagen_principal_url) || !precio_desde || !duracion || !ubicacion) {
        error = 'Completa todos los campos obligatorios';
        return;
      }
      // Generar slug
      const slug = slugify(titulo);
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
          return;
        }
      }
      // Imagen principal: usar archivo o URL
      let imagenPrincipalFinal = imagen_principal;
      if (imagen_principal_url && imagen_principal_url.trim() !== '') {
        imagenPrincipalFinal = imagen_principal_url.trim();
      }
      // Armar objeto para Supabase
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
      if (paquete && paquete.id) {
        // Edición
        res = await supabase.from('paquetes').update(dataPaquete).eq('id', paquete.id);
      } else {
        // Nuevo
        res = await supabase.from('paquetes').insert([dataPaquete]);
      }
      debugResponse = res;
      if (res.error) {
        error = 'Error al guardar paquete: ' + res.error.message;
        success = '';
      } else {
        success = '¡Paquete guardado exitosamente!';
        setTimeout(() => success = '', 3500);
        dispatch('guardado');
      }
    } catch (e) {
      error = 'Error inesperado al guardar: ' + (e?.message || JSON.stringify(e));
    } finally {
      loading = false;
    }
  }
</script>

<div class="form-paquete">
  <h2>{paquete ? 'Editar Paquete' : 'Nuevo Paquete'}</h2>
  <form class="form-grid" autocomplete="off" on:submit|preventDefault={guardarPaquete}>
    <div class="form-col-span-2">
      <label>Título*</label>
      <input bind:value={titulo} placeholder="Título del paquete" required />
    </div>
    <div class="form-col-span-2">
      <label>Descripción*</label>
      <textarea bind:value={descripcion} placeholder="Descripción" required rows="3"></textarea>
    </div>
    <div class="form-col-span-2">
      <label>Descripción corta*</label>
      <textarea bind:value={descripcion_corta} placeholder="Resumen breve para la tarjeta" required rows="2"></textarea>
    </div>
    <div class="form-col">
      <label>Beneficios (coma)</label>
      <input bind:value={beneficios} placeholder="Ej: Todo incluido, Seguro, ..." />
    </div>
    <div class="form-col">
      <label>Incluye (coma)</label>
      <input bind:value={incluye} placeholder="Ej: Guía, comidas, tours..." />
    </div>
    <div class="form-col">
      <label>Ventajas (coma)</label>
      <input bind:value={ventajas} placeholder="Ej: Flexible, Cancelación gratis..." />
    </div>
    <div class="form-col">
      <label>Precio desde* (USD)</label>
      <input type="number" bind:value={precio_desde} min="0" step="0.01" placeholder="Ej: 180" required />
    </div>
    <div class="form-col">
      <label>Precio por adulto (USD)*</label>
      <input type="number" min="0" step="0.01" bind:value={precio_adulto} placeholder="Ej: 1200 USD" required />
    </div>
    <div class="form-col">
      <label>Precio por niño (USD)*</label>
      <input type="number" min="0" step="0.01" bind:value={precio_nino} placeholder="Ej: 800 USD" required />
    </div>
    <div class="form-col">
      <label>Precio por pareja (USD)*</label>
      <input type="number" min="0" step="0.01" bind:value={precio_pareja} placeholder="Ej: 2000 USD" required />
    </div>
    <div class="form-col">
      <label>Duración*</label>
      <input bind:value={duracion} placeholder="Ej: 3 días, 2 noches" required />
    </div>
    <div class="form-col">
      <label>Ubicación*</label>
      <input bind:value={ubicacion} placeholder="Ej: Iquitos, Amazonía..." required />
    </div>
    <div class="form-col destacado-col">
      <label for="destacado" class="destacado-label">
        <input type="checkbox" id="destacado" bind:checked={destacado} class="check-destacado" />
        <span class="check-custom">
          {#if destacado}
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="11" fill="#13b67a"/><path d="M6.5 12.5L10 16L15.5 9.5" stroke="#fff" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"/></svg>
          {:else}
            <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="11" fill="#e0f7fa"/><circle cx="11" cy="11" r="8.5" stroke="#13b67a" stroke-width="1.5"/></svg>
          {/if}
        </span>
        <span class="check-text">Paquete destacado</span>
      </label>
    </div>
    <div class="form-col-span-2">
      <label>Galería (URLs separadas por coma o subir imágenes)</label>
      <input bind:value={galeria} placeholder="Ej: url1.jpg, url2.jpg, ..." />
      <input type="file" accept="image/*" multiple on:change={handleGaleriaFiles} />
      <div class="galeria-preview">
        {#each galeriaUrls as url, i}
          <div class="galeria-img-preview">
            <button type="button" class="remove-img" title="Quitar imagen" on:click={() => removeGaleriaUrl(i)}>×</button>
            <img src={url} alt="img galería" />
            <span>URL</span>
          </div>
        {/each}
        {#each galeriaFiles as file, i}
          <div class="galeria-img-preview">
            <button type="button" class="remove-img" title="Quitar imagen" on:click={() => removeGaleriaImg(i)}>×</button>
            <img src={file.previewUrl} alt={file.name} />
            <span>{file.name}</span>
          </div>
        {/each}
      </div>
    </div>
    <div class="form-col-span-2">
      <label>Imagen principal*</label>
      <div class="img-main-row">
        {#if !imagenFile}
          <input type="file" accept="image/*" on:change={handleImageUpload} />
        {/if}
        {#if !imagenFile}
          <input type="text" placeholder="O pega una URL de imagen" bind:value={imagen_principal_url} />
        {/if}
        {#if imagen_principal}
          <img src={imagen_principal} alt="Imagen paquete" class="preview" />
        {/if}
      </div>
    </div>
    {#if error && (error.includes('401') || error.includes('403'))}
      <div class="error">No tienes permisos para subir imágenes. Verifica que tu usuario esté autenticado y tenga rol de administrador.</div>
    {/if}
    {#if error}
      <div class="error">{error}</div>
    {/if}

    {#if debugData || debugResponse}
      <div class="debug-block">
        <b>DEBUG DATA:</b>
        <pre>{JSON.stringify(debug, null, 2)}</pre>
      </div>
    {/if}
    <div class="acciones">
      <button type="submit" disabled={loading}>{loading ? 'Guardando...' : 'Guardar'}</button>
      <button class="cancelar" type="button" on:click={() => dispatch('cerrar')}>Cancelar</button>
    </div>
  </form>
</div>

<style>
.form-paquete {
  background: #fff;
  border-radius: 1.2rem;
  padding: 2rem 2.5rem;
  width: 94%;
  margin: 0 auto 2rem auto;
  box-shadow: 0 2px 16px #0001;
  animation: fadeIn 0.6s;
  width: 800px;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: none; }
}
.form-paquete h2 {
  font-size: 1.45em;
  color: #18e0e9;
  margin-bottom: 1.2rem;
  text-align: left;
}
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.4rem 2.2rem;
  align-items: flex-start;
}
.form-col { display: flex; flex-direction: column; gap: 0.3rem; }
.form-col-span-2 { grid-column: span 2; display: flex; flex-direction: column; gap: 0.3rem; }
label {
  font-weight: 600;
  color: #0a3b4e;
  margin-bottom: 0.2rem;
  letter-spacing: 0.01em;
}
input, textarea {
  border: 1.5px solid #e0f7fa;
  border-radius: 0.6rem;
  padding: 0.85rem 1.1rem;
  font-size: 1em;
  background: #fafbfc;
  transition: border 0.2s, box-shadow 0.2s;
  outline: none;
}
input:focus, textarea:focus {
  border: 1.5px solid #18e0e9;
  box-shadow: 0 0 0 2px #18e0e933;
}
input[type="file"] {
  padding: 0.2rem 0;
  background: none;
  border: none;
  margin-bottom: 0.2rem;
}
.galeria-preview {
  display: flex;
  flex-direction: row;
  gap: 14px;
  flex-wrap: wrap;
  margin-top: 8px;
  align-items: flex-end;
}
.galeria-img-preview {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 88px;
  margin-bottom: 2px;
}
.galeria-img-preview img {
  width: 74px;
  height: 74px;
  object-fit: cover;
  border-radius: 0.7rem;
  box-shadow: 0 2px 8px #18e0e922;
  border: 2px solid #e0f7fa;
  margin-bottom: 4px;
}
.galeria-img-preview span {
  font-size: 0.85em;
  color: #0097a7;
  text-align: center;
  word-break: break-all;
  max-width: 80px;
}
.img-main-row {
  display: flex;
  align-items: center;
  gap: 1.2rem;
  flex-wrap: wrap;
}
.preview {
  margin-top: 0.2rem;
  max-width: 110px;
  border-radius: 0.7rem;
  box-shadow: 0 2px 8px #18e0e922;
  border: 2px solid #e0f7fa;
}
.switch {
  display: flex;
  align-items: center;
  gap: 0.5em;
}
.switch input[type="checkbox"] {
  width: 1.3em;
  height: 1.3em;
  accent-color: #18e0e9;
}
.acciones {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  grid-column: span 2;
  margin-top: 0.8rem;
}
button {
  background: #18e0e9;
  color: #fff;
  border: none;
  padding: 0.8rem 1.7rem;
  border-radius: 0.7rem;
  font-weight: bold;
  font-size: 1em;
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
  box-shadow: 0 2px 8px #18e0e922;
}
button:hover:not(:disabled) {
  background: #13b67a;
}
button.cancelar {
  background: #eee;
  color: #222;
  box-shadow: none;
}
button:disabled {
  opacity: 0.7;
  cursor: wait;
}
.error {
  color: #e01818;
  background: #ffeaea;
  border-radius: 0.4rem;
  padding: 0.5rem 1rem;
  margin-top: 0.5rem;
  grid-column: span 2;
}
.debug-block {
  background: #f5f5f5;
  color: #222;
  font-size: 0.95em;
  border: 1px solid #eee;
  padding: 1em;
  margin-bottom: 1em;
  grid-column: span 2;
}
@media (max-width: 800px) {
  .form-grid {
    grid-template-columns: 1fr;
    gap: 1.1rem;
  }
  .acciones, .error, .debug-block { grid-column: span 1; }
}
</style>
