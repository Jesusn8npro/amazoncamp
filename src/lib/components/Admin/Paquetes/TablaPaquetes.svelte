<script>
  import { supabase } from '$lib/../supabaseClient.js';
  import { onMount, createEventDispatcher } from 'svelte';
  export let paquetes = [];
  const dispatch = createEventDispatcher();

  async function eliminarPaquete(id) {
    if (confirm('¿Seguro que deseas eliminar este paquete?')) {
      const { error } = await supabase.from('paquetes').delete().eq('id', id);
      if (!error) dispatch('eliminado');
    }
  }
</script>

<div class="tabla-paquetes-wrapper">
  <table class="tabla-admin">
    <thead>
      <tr>
        <th>Imagen</th>
      <th>Galería</th>
        <th>Título</th>
        <th>Descripción corta</th>
        <th>Precio</th>
        <th>Duración</th>
        <th>Estado</th>
        <th>Acciones</th>
      </tr>
    </thead>
    <tbody>
      {#if paquetes.length === 0}
        <tr>
          <td colspan="8" class="tabla-vacia">No hay paquetes registrados</td>
        </tr>
      {:else}
        {#each paquetes as p}
          <tr>
            <td>
              {#if p.imagen_principal}
                <img src={p.imagen_principal} alt={p.titulo} class="paquete-img" />
              {/if}
            </td>
            <td>
              {#if p.galeria && p.galeria.length > 0}
                <div class="galeria-table-preview">
                  {#each p.galeria.slice(0, 3) as imgUrl}
                    <img src={imgUrl} alt="img galería" class="galeria-thumb" />
                  {/each}
                </div>
              {:else}
                <span>-</span>
              {/if}
            </td>
            <td class="titulo-col">{p.titulo}</td>
            <td>{p.descripcion_corta}</td>
            <td class="precio-col">${p.precio_desde?.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })} USD</td>
            <td>{p.duracion}</td>
            <td>
              {#if p.destacado}
                <span class="badge badge-destacado" title="Paquete destacado">Destacado</span>
              {:else}
                <span class="badge badge-normal" title="Paquete estándar">Normal</span>
              {/if}
            </td>
            <td class="acciones-col">
              <button class="btn-editar" title="Editar paquete" on:click={() => dispatch('editar', p)}>
                ✏️
              </button>
              <button class="btn-eliminar" title="Eliminar paquete" on:click={() => eliminarPaquete(p.id)}>
                🗑️
              </button>
            </td>
          </tr>
        {/each}
      {/if}
    </tbody>
  </table>
</div>

<style>
.tabla-paquetes-wrapper {
  width: 100%;
  overflow-x: auto;
  margin-top: 1.5rem;
}
.tabla-admin {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  background: #fff;
  border-radius: 14px;
  box-shadow: 0 2px 12px #0001;
  overflow: hidden;
  font-size: 1em;
}
.tabla-admin th, .tabla-admin td {
  padding: 1rem 0.7rem;
  text-align: left;
}
.tabla-admin thead {
  background: #18e0e9;
}
.tabla-admin th {
  color: #fff;
  font-weight: 600;
  letter-spacing: 0.5px;
  border-bottom: 2px solid #e0f7fa;
}
.tabla-admin tr {
  transition: background 0.15s;
}
.tabla-admin tbody tr:hover {
  background: #f2fcfd;
}
.paquete-img {
  width: 64px;
  height: 40px;
  object-fit: cover;
  border-radius: 8px;
  box-shadow: 0 1px 4px #18e0e922;
  border: 2px solid #e0f7fa;
}
.galeria-table-preview {
  display: flex;
  flex-direction: row;
  gap: 6px;
  align-items: center;
}
.galeria-thumb {
  width: 36px;
  height: 36px;
  object-fit: cover;
  border-radius: 0.5rem;
  border: 1.5px solid #e0f7fa;
  box-shadow: 0 1px 4px #18e0e922;
}
.titulo-col {
  font-weight: bold;
  color: #0a3b4e;
  max-width: 220px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.precio-col {
  color: #13b67a;
  font-weight: 600;
  font-size: 1.05em;
}
.badge {
  display: inline-block;
  padding: 0.3em 0.9em;
  border-radius: 12px;
  font-size: 0.92em;
  font-weight: 600;
}
.badge-destacado {
  background: #ffe082;
  color: #b28900;
  border: 1px solid #ffecb3;
}
.badge-normal {
  background: #e0f7fa;
  color: #0097a7;
  border: 1px solid #b2ebf2;
}
.acciones-col {
  display: flex;
  gap: 0.5rem;
}
.btn-editar, .btn-eliminar {
  background: none;
  border: none;
  font-size: 1.3em;
  cursor: pointer;
  padding: 0.35em 0.5em;
  border-radius: 6px;
  transition: background 0.18s;
}
.btn-editar:hover {
  background: #e0f7fa;
}
.btn-eliminar {
  color: #e53935;
}
.btn-eliminar:hover {
  background: #ffebee;
}
.tabla-vacia {
  text-align: center;
  color: #bdbdbd;
  font-style: italic;
  padding: 2.5rem 0;
}
@media (max-width: 700px) {
  .tabla-admin th, .tabla-admin td {
    padding: 0.6rem 0.3rem;
    font-size: 0.97em;
  }
  .titulo-col {
    max-width: 110px;
  }
  .paquete-img {
    width: 46px;
    height: 32px;
  }
}
.tabla-admin {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
  margin-top: 1.5rem;
  border-radius: 1rem;
  overflow: hidden;
}
.tabla-admin th, .tabla-admin td {
  padding: 0.8rem 1rem;
  border-bottom: 1px solid #eee;
  text-align: left;
}
.tabla-admin th {
  background: #f5f5f5;
  color: #18e0e9;
  font-weight: 600;
}
.tabla-admin tr:hover {
  background: #f0f9fa;
}
.thumb {
  width: 56px;
  height: 38px;
  object-fit: cover;
  border-radius: 0.4rem;
  box-shadow: 0 1px 4px #0001;
}
button {
  background: #18e0e9;
  color: #fff;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.5rem;
  font-size: 0.97em;
  margin-right: 0.5rem;
  cursor: pointer;
  transition: background 0.2s;
}
button.eliminar {
  background: #e01818;
}
button:disabled {
  opacity: 0.7;
  cursor: wait;
}
</style>
