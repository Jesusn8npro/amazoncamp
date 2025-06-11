<script>
  import { onMount } from 'svelte';
  import EditorQuill from './EditorQuill.svelte';
  import { supabase } from '../../../../supabaseClient.js';

  let articulos = [];
  let cargando = false;
  let error = '';
  let exito = '';
  let mostrandoFormulario = false;
  let editandoId = null;
  let expandirForm = false;

  let nuevo = {
    titulo: '',
    resumen: '',
    contenido: '',
    imagen_url: '',
    estado: 'borrador',
  };

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
        imagen_destacada: a.imagen_url || 'https://placehold.co/400x220?text=Sin+Imagen',
        fecha_publicacion: a.creado_en ? a.creado_en.slice(0, 10) : '',
        resumen: a.resumen || '',
        autor: a.autor || 'Admin',
      }));
    }
    cargando = false;
  }

  function nuevoArticulo() {
    editandoId = null;
    expandirForm = true;
    nuevo = { titulo: '', resumen: '', contenido: '', imagen_url: '', estado: 'borrador' };
    mostrandoFormulario = true;
  }

  function cancelarEdicion() {
    mostrandoFormulario = false;
    expandirForm = false;
    editandoId = null;
    error = '';
    exito = '';
  }

  function editarArticulo(id) {
    const art = articulos.find(a => a.id === id);
    if (art) {
      editandoId = id;
      expandirForm = true;
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
      cancelarEdicion();
    }
    cargando = false;
  }
</script>

<div class="blog-admin-manager">
  <div class="blog-header">
    <h1>Administración de Blog</h1>
    <button class="btn-nuevo" on:click={nuevoArticulo}>+ Nuevo artículo</button>
  </div>

  {#if expandirForm}
    <div class="formulario-desplegable animate-expand">
      <form on:submit|preventDefault={guardarArticulo}>
        <div class="form-grid">
          <div class="input-group">
            <label for="titulo">Título</label>
            <input id="titulo" type="text" bind:value={nuevo.titulo} placeholder="Título del artículo" required />
          </div>
          <div class="input-group">
            <label for="imagen">Imagen (URL)</label>
            <input id="imagen" type="text" bind:value={nuevo.imagen_url} placeholder="URL de la imagen" />
          </div>
          <div class="input-group">
            <label for="estado">Estado</label>
            <select id="estado" bind:value={nuevo.estado}>
              <option value="borrador">Borrador</option>
              <option value="publicado">Publicado</option>
            </select>
          </div>
          <div class="input-group full">
            <label for="resumen">Resumen</label>
            <textarea id="resumen" bind:value={nuevo.resumen} placeholder="Resumen breve..." rows="2"></textarea>
          </div>
          <div class="input-group full">
            <label>Contenido</label>
            <EditorQuill bind:value={nuevo.contenido} placeholder="Escribe el contenido del artículo..." />
          </div>
        </div>
        {#if error}
          <div class="msg error">{error}</div>
        {/if}
        {#if exito}
          <div class="msg exito">{exito}</div>
        {/if}
        <div class="form-actions">
          <button type="submit" class="btn-guardar" disabled={cargando}>{cargando ? 'Guardando...' : (editandoId ? 'Actualizar' : 'Guardar artículo')}</button>
          <button type="button" class="btn-cancelar" on:click={cancelarEdicion} disabled={cargando}>Cancelar</button>
        </div>
      </form>
    </div>
  {/if}

  <div class="articulos-grid">
    {#if cargando}
      <div class="loader">Cargando artículos...</div>
    {:else if articulos.length === 0}
      <div class="vacio">No hay artículos publicados aún.</div>
    {:else}
      {#each articulos as articulo}
        <div class="articulo-card">
          <div class="imagen-wrap">
            <img src={articulo.imagen_destacada} alt={articulo.titulo} />
          </div>
          <div class="contenido-wrap">
            <h2>{articulo.titulo}</h2>
            <span class="estado {articulo.estado}">{articulo.estado}</span>
            <p class="resumen">{articulo.resumen && articulo.resumen.length > 160 ? articulo.resumen.slice(0, 160) + '…' : articulo.resumen}</p>
            <div class="meta">
              <span>🗓️ {articulo.fecha_publicacion}</span>
              <span>✍️ {articulo.autor}</span>
            </div>
            <div class="acciones">
              <button class="edit" title="Editar" on:click={() => editarArticulo(articulo.id)}>✏️</button>
              <button class="delete" title="Eliminar" on:click={() => eliminarArticulo(articulo.id)}>🗑️</button>
              <button class="view" title="Ver" on:click={() => window.open(`/blog/${articulo.slug || articulo.id}`, '_blank')}>👁️</button>
            </div>
          </div>
        </div>
      {/each}
    {/if}
  </div>
</div>

<style>
.blog-admin-manager {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2.2rem 1.2rem 3rem 1.2rem;
}
.blog-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2.2rem;
}
.blog-header h1 {
  font-size: 2.1rem;
  font-weight: 900;
  color: #1b7e3c;
  letter-spacing: 1px;
}
.btn-nuevo {
  background: linear-gradient(90deg, #13b67a, #18e0e9);
  color: #fff;
  border: none;
  padding: 0.9rem 2.1rem;
  border-radius: 8px;
  font-size: 1.13rem;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 0 2px 12px #18e0e955, 0 1px 0 #fff8;
  transition: background 0.2s, transform 0.18s, box-shadow 0.18s, filter 0.18s;
}
.btn-nuevo:hover { background: linear-gradient(90deg, #18e0e9, #13b67a); filter: brightness(1.07); }

.formulario-desplegable {
  background: #f7f7fa;
  border-radius: 18px;
  box-shadow: 0 4px 24px #0001;
  padding: 2.5rem 2.5rem 2rem 2.5rem;
  margin-bottom: 2.8rem;
  margin-top: 0.8rem;
  animation: fadeInDown 0.7s cubic-bezier(.39,.58,.57,1) both;
}
.animate-expand {
  animation: expandDown 0.4s cubic-bezier(.39,.58,.57,1);
}
@keyframes expandDown {
  0% { opacity: 0; transform: scaleY(0.85) translateY(-30px); }
  100% { opacity: 1; transform: scaleY(1) translateY(0); }
}
.form-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.2rem 2rem;
}
@media (min-width: 700px) {
  .form-grid {
    grid-template-columns: 1fr 1fr;
  }
  .form-grid .full {
    grid-column: 1/3;
  }
}
.input-group {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}
.input-group label {
  font-weight: 700;
  color: #1b7e3c;
  margin-bottom: 0.2em;
}
.input-group input,
.input-group textarea,
.input-group select {
  padding: 0.8rem 1rem;
  border-radius: 8px;
  border: 1.5px solid #e0e0e0;
  font-size: 1.08rem;
  background: #fff;
  box-shadow: 0 1px 4px #0001;
  transition: border 0.2s;
}
.input-group input:focus,
.input-group textarea:focus,
.input-group select:focus {
  border: 1.5px solid #13b67a;
  outline: none;
}
.form-actions {
  display: flex;
  gap: 1.2rem;
  margin-top: 1.5rem;
}
.btn-guardar {
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
.btn-cancelar {
  background: #e0e0e0;
  color: #444;
  border: none;
  padding: 1rem 2.5rem;
  border-radius: 7px;
  font-size: 1.13rem;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s;
}
.btn-cancelar:hover { background: #bdbdbd; }

.msg.error {
  color: #b71c1c;
  font-weight: bold;
  margin: 0.5em 0 0.6em 0;
}
.msg.exito {
  color: #13b67a;
  font-weight: bold;
  margin: 0.5em 0 0.6em 0;
}

.articulos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(310px, 1fr));
  gap: 2.2rem;
}
.articulo-card {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 6px 24px rgba(44,85,48,0.10);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform 0.18s, box-shadow 0.18s;
  min-width: 260px;
  animation: fadeInUp 0.7s cubic-bezier(.77,0,.18,1);
}
.articulo-card:hover {
  transform: translateY(-5px) scale(1.015);
  box-shadow: 0 14px 36px rgba(44,85,48,0.16);
}
.imagen-wrap {
  width: 100%;
  height: 180px;
  background: #f4f4f4;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.imagen-wrap img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 16px 16px 0 0;
}
.contenido-wrap {
  padding: 1.5rem 1.2rem 1.2rem 1.2rem;
  display: flex;
  flex-direction: column;
  flex: 1;
}
.contenido-wrap h2 {
  font-size: 1.18rem;
  font-weight: 900;
  color: #1b7e3c;
  margin-bottom: 0.5rem;
}
.estado {
  display: inline-block;
  font-size: 0.92em;
  font-weight: 700;
  border-radius: 12px;
  padding: 0.18em 0.8em;
  margin-bottom: 0.7em;
  margin-right: 0.7em;
  background: #e0fbe9;
  color: #13b67a;
}
.estado.publicado {
  background: #d4f9e5;
  color: #1b7e3c;
}
.estado.borrador {
  background: #ffe5e5;
  color: #b71c1c;
}
.resumen {
  font-size: 1.02em;
  color: #444;
  margin-bottom: 0.7em;
  word-break: break-word;
}
.meta {
  font-size: 0.93em;
  color: #7a7a7a;
  margin-bottom: 0.9em;
  display: flex;
  gap: 1.2em;
}
.acciones {
  display: flex;
  gap: 1.2em;
  margin-top: auto;
}
.acciones button {
  background: none;
  border: none;
  font-size: 1.22em;
  cursor: pointer;
  transition: color 0.2s, transform 0.16s;
}
.acciones .edit:hover { color: #1976d2; transform: scale(1.13); }
.acciones .delete:hover { color: #d32f2f; transform: scale(1.13); }
.acciones .view:hover { color: #13b67a; transform: scale(1.13); }

.loader {
  text-align: center;
  color: #13b67a;
  font-size: 1.2em;
  padding: 2em 0;
}
.vacio {
  text-align: center;
  color: #aaa;
  font-size: 1.1em;
  padding: 2em 0;
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeInDown {
  0% { opacity: 0; transform: translateY(-30px); }
  100% { opacity: 1; transform: none; }
}
</style>
