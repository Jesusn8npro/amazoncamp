<script>
  import { supabase } from '../../../supabaseClient.js';
  import { onMount } from 'svelte';
  let articulos = [];
  let loading = false;
  let error = '';

  async function cargarArticulos() {
    loading = true;
    error = '';
    const { data, error: err } = await supabase
      .from('blog_articulos')
      .select('id, titulo, creado_en')
      .order('creado_en', { ascending: false });
    if (err) {
      error = 'Error cargando artículos';
      articulos = [];
    } else {
      articulos = data;
    }
    loading = false;
  }

  async function eliminarArticulo(id) {
    if (!confirm('¿Seguro que deseas eliminar este artículo?')) return;
    loading = true;
    error = '';
    const { error: err } = await supabase
      .from('blog_articulos')
      .delete()
      .eq('id', id);
    if (err) {
      error = 'No se pudo eliminar el artículo.';
    } else {
      articulos = articulos.filter(a => a.id !== id);
    }
    loading = false;
  }

  onMount(() => {
    cargarArticulos();
  });
</script>

{#if error}
  <div class="text-red-600 font-bold mb-2">{error}</div>
{/if}

<table class="tabla-admin w-full">
  <thead>
    <tr>
      <th>ID</th>
      <th>Título</th>
      <th>Fecha</th>
      <th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    {#if loading}
      <tr><td colspan="4" class="text-center">Cargando...</td></tr>
    {:else if articulos.length === 0}
      <tr><td colspan="4" class="text-center">No hay artículos</td></tr>
    {:else}
      {#each articulos as articulo}
        <tr>
          <td>{articulo.id}</td>
          <td>{articulo.titulo}</td>
          <td>{new Date(articulo.creado_en).toLocaleDateString('es-PE', { day: 'numeric', month: 'short', year: 'numeric' })}</td>
          <td>
            <button class="btn-eliminar text-red-600 hover:text-red-800" title="Eliminar" on:click={() => eliminarArticulo(articulo.id)} disabled={loading}>🗑️</button>
          </td>
        </tr>
      {/each}
    {/if}
  </tbody>
</table>

<style>
.btn-eliminar {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
  transition: color 0.2s;
}
.btn-eliminar[disabled] {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
