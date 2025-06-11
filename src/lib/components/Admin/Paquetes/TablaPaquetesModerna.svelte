<script>
  import { supabase } from '$lib/../supabaseClient.js';
  import { createEventDispatcher } from 'svelte';
  export let paquetes = [];
  const dispatch = createEventDispatcher();

  async function eliminarPaquete(id) {
    if (confirm('¿Seguro que deseas eliminar este paquete?')) {
      const { error } = await supabase.from('paquetes').delete().eq('id', id);
      if (!error) dispatch('eliminado', id);
    }
  }
</script>

<!-- WRAPPER -->
<div class="tabla-paquetes-admin">
  <!-- Vista de escritorio: tabla -->
  <table class="tabla-admin" tabindex="0">
    <thead>
      <tr>
        <th>Imagen</th>
        <th>Galería</th>
        <th>Título</th>
        <th>Descripción corta</th>
        <th>Precio/día</th>
        <th>Duración</th>
        <th>Precio total</th>
        <th>Estado</th>
        <th>Acciones</th>
      </tr>
    </thead>
    <tbody>
      {#if paquetes.length === 0}
        <tr>
          <td colspan="9" class="tabla-vacia">No hay paquetes registrados</td>
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
            <td>{p.duracion} {+p.duracion === 1 ? 'día' : 'días'}</td>
            <td class="precio-col">
              ${(p.precio_desde * (+p.duracion || 1)).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })} USD
            </td>
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

  <!-- Vista móvil: cards -->
  <div class="cards-mobile">
    {#if paquetes.length === 0}
      <div class="card-vacia">No hay paquetes registrados</div>
    {:else}
      {#each paquetes as p}
        <div class="paquete-card">
          <div class="card-imgs">
            {#if p.imagen_principal}
              <img src={p.imagen_principal} alt={p.titulo} class="paquete-img-main" />
            {/if}
            {#if p.galeria && p.galeria.length > 0}
              <div class="galeria-preview">
                {#each p.galeria.slice(0, 2) as imgUrl}
                  <img src={imgUrl} alt="img galería" class="galeria-thumb" />
                {/each}
              </div>
            {/if}
          </div>
          <div class="card-info">
            <div class="titulo">{p.titulo}</div>
            <div class="desc">{p.descripcion_corta}</div>
            <div class="row-precios">
              <span class="precio-dia">${p.precio_desde?.toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })}/día</span>
              <span class="duracion">{p.duracion} {+p.duracion === 1 ? 'día' : 'días'}</span>
            </div>
            <div class="precio-total-card">
              Total: <b>${(p.precio_desde * (+p.duracion || 1)).toLocaleString(undefined, { minimumFractionDigits: 2, maximumFractionDigits: 2 })} USD</b>
            </div>
            <div class="estado-badges">
              {#if p.destacado}
                <span class="badge badge-destacado">Destacado</span>
              {:else}
                <span class="badge badge-normal">Normal</span>
              {/if}
            </div>
            <div class="acciones-cards">
              <button class="btn-editar" title="Editar paquete" on:click={() => dispatch('editar', p)}>✏️ Editar</button>
              <button class="btn-eliminar" title="Eliminar paquete" on:click={() => eliminarPaquete(p.id)}>🗑️ Eliminar</button>
            </div>
          </div>
        </div>
      {/each}
    {/if}
  </div>
</div>

<style>
.tabla-paquetes-admin {
  width: 100%;
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
  display: table;
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
  background: #e0f7fa44;
}
.paquete-img {
  width: 56px;
  height: 38px;
  object-fit: cover;
  border-radius: 0.4rem;
  box-shadow: 0 1px 4px #0001;
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
  padding: 1.5em 0;
}

/* MOBILE CARDS */
.cards-mobile {
  display: none;
}
@media (max-width: 900px) {
  .tabla-admin {
    display: none;
  }
  .cards-mobile {
    display: block;
    margin-top: 0.5em;
  }
  .paquete-card {
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 2px 14px #0001;
    margin-bottom: 1.2em;
    display: flex;
    gap: 12px;
    padding: 13px 13px 13px 10px;
    align-items: flex-start;
  }
  .card-imgs {
    min-width: 70px;
    display: flex;
    flex-direction: column;
    gap: 5px;
    align-items: center;
  }
  .paquete-img-main {
    width: 70px;
    height: 48px;
    object-fit: cover;
    border-radius: 0.5rem;
    box-shadow: 0 1px 6px #18e0e922;
    margin-bottom: 3px;
  }
  .galeria-preview {
    display: flex;
    gap: 4px;
  }
  .galeria-thumb {
    width: 28px;
    height: 28px;
    object-fit: cover;
    border-radius: 0.4rem;
    border: 1px solid #e0f7fa;
  }
  .card-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }
  .titulo {
    font-weight: bold;
    font-size: 1.09em;
    color: #0a3b4e;
    margin-bottom: 1px;
  }
  .desc {
    color: #666;
    font-size: 0.98em;
    margin-bottom: 3px;
  }
  .row-precios {
    display: flex;
    gap: 10px;
    font-size: 0.97em;
    color: #13b67a;
    align-items: center;
  }
  .precio-total-card {
    margin: 2px 0 2px 0;
    font-size: 1.03em;
    color: #14532d;
  }
  .estado-badges {
    margin: 2px 0 2px 0;
  }
  .acciones-cards {
    display: flex;
    gap: 8px;
    margin-top: 6px;
  }
  .acciones-cards button {
    font-size: 1em;
    padding: 0.4em 0.7em;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    background: #e0f7fa;
    color: #0097a7;
    transition: background 0.18s;
  }
  .acciones-cards .btn-eliminar {
    background: #ffebee;
    color: #e53935;
  }
  .acciones-cards button:hover {
    background: #18e0e9;
    color: #fff;
  }
  .card-vacia {
    text-align: center;
    color: #bdbdbd;
    font-style: italic;
    padding: 1.5em 0;
  }
}
</style>
