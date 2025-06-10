<script>
  import { browser } from '$app/environment';
  import EditorQuill from './EditorQuill.svelte';
  import { supabase } from '../../../../supabaseClient.js';
  import { onMount } from 'svelte';

  // Estado para artículos y formulario
  let articulos = [];
  let cargando = false;
  let error = '';
  let exito = '';

  // Formulario nuevo artículo
  let nuevo = {
    titulo: '',
    resumen: '',
    contenido: '',
    imagen_url: '',
    estado: 'borrador',
  };
  let mostrandoFormulario = false;
  let editandoId = null;

  // Cargar artículos al montar
  onMount(() => {
    cargarArticulos();
  });

  async function cargarArticulos() {
    cargando = true;
    error = '';
    const { data, error: err } = await supabase.from('blog_articulos').select('*').order('creado_en', { ascending: false });
    if (err) {
      error = 'No se pudieron cargar los artículos.';
      articulos = [];
    } else {
      articulos = (data || []).map(a => ({
        ...a,
        imagen_destacada: a.imagen_url || 'https://placehold.co/80x80',
        fecha_publicacion: a.creado_en ? a.creado_en.slice(0, 10) : '',
        resumen: a.resumen || '',
        autor: a.autor || 'Admin',
      }));
    }
    cargando = false;
  }

  async function guardarArticulo() {
    cargando = true;
    error = '';
    exito = '';
    if (!nuevo.titulo || !nuevo.contenido) {
      error = 'El título y el contenido son obligatorios.';
      cargando = false;
      return;
    }
    const articulo = {
      titulo: nuevo.titulo,
      resumen: nuevo.resumen,
      contenido: nuevo.contenido,
      imagen_url: nuevo.imagen_url,
      estado: nuevo.estado,
    };
    let err;
    if (editandoId) {
      ({ error: err } = await supabase.from('blog_articulos').update(articulo).eq('id', editandoId));
    } else {
      ({ error: err } = await supabase.from('blog_articulos').insert([articulo]));
    }
    if (err) {
      error = 'Error al guardar artículo: ' + err.message;
    } else {
      exito = editandoId ? '¡Artículo actualizado!' : '¡Artículo creado exitosamente!';
      Object.keys(nuevo).forEach(k => nuevo[k] = k === 'estado' ? 'borrador' : '');
      await cargarArticulos();
      cerrarFormulario();
    }
    cargando = false;
  }

  function crearArticuloConIA() {
    alert('Crear artículo con IA (próximamente)');
  }

  function nuevoArticulo() {
    editandoId = null;
    nuevo = { titulo: '', resumen: '', contenido: '', imagen_url: '', estado: 'borrador' };
    mostrandoFormulario = true;
  }

  function editarArticulo(id) {
    const art = articulos.find(a => a.id === id);
    if (art) {
      editandoId = id;
      nuevo = {
        titulo: art.titulo,
        resumen: art.resumen,
        contenido: art.contenido,
        imagen_url: art.imagen_url,
        estado: art.estado
      };
      mostrandoFormulario = true;
    }
  }

  function cerrarFormulario() {
    mostrandoFormulario = false;
    editandoId = null;
  }

  async function eliminarArticulo(id) {
    if (!confirm('¿Seguro que deseas eliminar este artículo?')) return;
    cargando = true;
    error = '';
    exito = '';
    const { error: err } = await supabase.from('blog_articulos').delete().eq('id', id);
    if (err) {
      error = 'No se pudo eliminar el artículo: ' + err.message;
    } else {
      exito = '¡Artículo eliminado correctamente!';
      await cargarArticulos();
    }
    cargando = false;
  }
</script>

<!-- Formulario de creación/edición -->
{#if mostrandoFormulario}
  <div class="formulario-articulo">
  <div class="col-izq">
    <div style="display: flex; align-items: center; justify-content: space-between;">
      <h3>{editandoId ? 'Editar artículo' : 'Crear nuevo artículo'}</h3>
      <button class="cerrar-btn" on:click={cerrarFormulario}>✖</button>
    </div>
    {#if error}
      <div class="error">{error}</div>
    {/if}
    {#if exito}
      <div class="exito">{exito}</div>
    {/if}
    <input type="text" placeholder="Título" bind:value={nuevo.titulo} required />
    <textarea id="resumen" bind:value={nuevo.resumen} rows="3" maxlength="180" placeholder="Resumen del artículo (máximo 180 caracteres)"></textarea>
    <input type="text" placeholder="Imagen URL" bind:value={nuevo.imagen_url} />
    <select bind:value={nuevo.estado}>
      <option value="borrador">Borrador</option>
      <option value="publicado">Publicado</option>
    </select>
    <button type="submit" disabled={cargando} class="btn-guardar" on:click|preventDefault={guardarArticulo}>{cargando ? 'Guardando...' : (editandoId ? 'Actualizar' : 'Guardar artículo')}</button>
  </div>
  <div class="col-der">
    {#if browser}
      <EditorQuill bind:value={nuevo.contenido} placeholder="Contenido del artículo..." />
    {/if}
  </div>
</div>
{/if}


<div class="panel-blog plantilla-blog">
  <!-- Plantilla visual para mostrar artículos de manera "vacana" -->
  <div class="header-blog">
    <h2>Administrar Blog</h2>
    <div class="botones-header">
      <button class="btn-nuevo" on:click={nuevoArticulo}>+ Nuevo artículo</button>
      <button class="btn-ia" on:click={crearArticuloConIA}>Crear artículo con IA</button>
    </div>
  </div>
  <div class="grid-articulos">
    {#each articulos as articulo}
      <div class="tarjeta-articulo">
        <img src={articulo.imagen_destacada} alt="Imagen" class="imagen-articulo" />
        <div class="contenido-articulo">
          <h3 class="titulo-articulo">{articulo.titulo}</h3>
          <p class="resumen-articulo">{articulo.resumen && articulo.resumen.length > 220 ? articulo.resumen.slice(0, 220) + '…' : articulo.resumen}</p>
          <div class="estado-articulo">
            <span class={articulo.estado === 'publicado' ? 'estado-publicado' : 'estado-borrador'}>
              {articulo.estado}
            </span>
          </div>
          <div class="acciones-articulo">
            <button class="btn-editar" on:click={() => editarArticulo(articulo.id)}>✏️</button>
            <button class="btn-eliminar" on:click={() => eliminarArticulo(articulo.id)}>🗑️</button>
            <button class="btn-visualizar" title="Visualizar artículo" on:click={() => window.open(`/blog/${articulo.slug || articulo.id}`, '_blank')}>👁️</button>
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>

<style>
  .formulario-articulo {
  background: #f7f7f7;
  border-radius: 18px;
  padding: 2.5rem 2.5rem 2rem 2.5rem;
  margin-bottom: 2.8rem;
  box-shadow: 0 4px 24px #0002;
  max-width: 1100px;
  width: 100%;
  margin-left: auto;
  margin-right: auto;
  display: flex;
  flex-direction: column;
  gap: 2.2rem;
}
@media (min-width: 900px) {
  .formulario-articulo {
    flex-direction: row;
    gap: 2.5rem;
    align-items: flex-start;
  }
}
.formulario-articulo .col-izq {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}
.formulario-articulo .col-der {
  flex: 2;
  min-width: 340px;
}
.formulario-articulo h3 {
  margin-top: 0;
  color: #13b67a;
  font-size: 1.45em;
  margin-bottom: 1.1rem;
  font-weight: 900;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 1em;
}
.formulario-articulo .cerrar-btn {
  background: none;
  border: none;
  font-size: 1.7em;
  color: #aaa;
  cursor: pointer;
  margin-left: auto;
  transition: color 0.2s;
}
.formulario-articulo .cerrar-btn:hover {
  color: #13b67a;
}
.formulario-articulo input,
.formulario-articulo select {
  width: 100%;
  padding: 0.85rem 1rem;
  border: 1.5px solid #e0e0e0;
  border-radius: 7px;
  font-size: 1.08rem;
  background: #fff;
  transition: border 0.2s;
  box-shadow: 0 1px 4px #0001;
}
.formulario-articulo input:focus,
.formulario-articulo select:focus {
  border: 1.5px solid #13b67a;
  outline: none;
}
.formulario-articulo .btn-guardar {
  background: linear-gradient(90deg, #13b67a, #18e0e9);
  color: #fff;
  border: none;
  padding: 1rem 2.5rem;
  border-radius: 7px;
  font-size: 1.13rem;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 0 2px 12px #18e0e955, 0 1px 0 #fff8;
  transition: background 0.2s, transform 0.18s, box-shadow 0.18s, filter 0.18s;
}
.formulario-articulo .btn-guardar:disabled {
  background: #bbb;
  cursor: not-allowed;
}
.formulario-articulo .error {
  color: #b71c1c;
  font-weight: bold;
}
.formulario-articulo .exito {
  color: #13b67a;
  font-weight: bold;
}
@media (max-width: 900px) {
  .formulario-articulo {
    flex-direction: column;
    padding: 1.2rem 0.5rem 1.2rem 0.5rem;
    gap: 1.2rem;
  }
  .formulario-articulo .col-der {
    min-width: 0;
  }
}


  .formulario-articulo h3 {
    margin-top: 0;
    color: #28c76f;
    font-size: 1.2em;
    margin-bottom: 1rem;
  }
  .formulario-articulo input,
  .formulario-articulo textarea,
  .formulario-articulo select {
    width: 100%;
    margin-bottom: 1rem;
    padding: 0.7rem;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 1rem;
    background: #fff;
    transition: border 0.2s;
  }
  .formulario-articulo input:focus,
  .formulario-articulo textarea:focus,
  .formulario-articulo select:focus {
    border: 1.5px solid #28c76f;
    outline: none;
  }
  .formulario-articulo .btn-guardar {
    background: linear-gradient(90deg, #28c76f, #20b463);
    color: #fff;
    border: none;
    padding: 0.7rem 1.5rem;
    border-radius: 5px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s;
    font-weight: bold;
  }
  .formulario-articulo .btn-guardar:disabled {
    background: #bbb;
    cursor: not-allowed;
  }
  .formulario-articulo .error {
    color: #b71c1c;
    margin-bottom: 0.8rem;
    font-weight: bold;
  }
  .formulario-articulo .exito {
    color: #28c76f;
    margin-bottom: 0.8rem;
    font-weight: bold;
  }
  .plantilla-blog .grid-articulos {
    margin-top: 2rem;
  }

  .panel-blog {
    background: #fff;
    border-radius: 8px;
    padding: 2rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
  }
  .header-blog {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.5rem;
  }
  .botones-header {
    display: flex;
    align-items: center;
  }
  .btn-nuevo {
    background: #28c76f;
    color: #fff;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s;
    margin-right: 1rem;
  }
  .btn-nuevo:hover {
    background: #20b463;
  }
  .btn-ia {
    background: #2196f3;
    color: #fff;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background 0.2s;
  }
  .btn-ia:hover {
    background: #1a76d2;
  }
  .grid-articulos {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    grid-gap: 1rem;
  }
  .tarjeta-articulo {
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.04);
    padding: 1rem;
    display: flex;
    flex-direction: column;
  }
  .imagen-articulo {
    width: 100%;
    height: 150px;
    object-fit: cover;
    border-radius: 8px 8px 0 0;
  }
  .contenido-articulo {
    padding: 1rem;
  }
  .titulo-articulo {
    font-size: 1.2rem;
    margin-bottom: 0.5rem;
  }
  .resumen-articulo {
  word-break: break-word;
  overflow-wrap: anywhere;
  max-width: 100%;
  overflow: hidden;
    font-size: 0.9rem;
    margin-bottom: 1rem;
  }
  .estado-articulo {
    font-size: 0.8rem;
    color: #666;
    margin-bottom: 1rem;
  }
  .estado-publicado {
    background: #d4f9e5;
    color: #1b7e3c;
    padding: 0.2rem 0.6rem;
    border-radius: 12px;
  }
  .estado-borrador {
    background: #ffe5e5;
    color: #b71c1c;
    padding: 0.2rem 0.6rem;
    border-radius: 12px;
  }
  .acciones-articulo {
    display: flex;
    justify-content: flex-end;
    margin-top: 1rem;
  }
  .btn-editar, .btn-eliminar {
    background: none;
    border: none;
    font-size: 1.2em;
    cursor: pointer;
    margin-right: 0.4em;
  }
  .btn-eliminar { color: #d32f2f; }
  .btn-editar { color: #1976d2; }
  .btn-editar:hover { text-decoration: underline; }
  .btn-eliminar:hover { text-decoration: underline; }
</style>
