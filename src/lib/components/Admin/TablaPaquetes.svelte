<script>
  export let paquetes = [];
</script>

<table class="tabla-admin">
  <thead>
    <tr>
      <th>ID</th>
      <th>Título</th>
      <th>Precio</th>
      <th>Estado</th>
      <th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    {#each paquetes as p}
      <tr>
        <td>{p.id}</td>
        <td>{p.titulo}</td>
        <td>S/ {p.precio_desde}</td>
        <td>{p.destacado ? 'Destacado' : 'Normal'}</td>
        <td><button on:click={() => dispatch('editar', p)}>Editar</button></td>
      </tr>
    {/each}
  </tbody>
</table>

