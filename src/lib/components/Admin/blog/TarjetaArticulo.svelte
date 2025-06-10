<script>
  import { goto } from '$app/navigation';
  export let titulo = 'Título del artículo';
  export let resumen = 'Resumen breve del artículo para mostrar en la tarjeta.';
  export let autor = 'Autor';
  export let creado_en = '';
  export let imagen_url = '';
  export let slug = '';

  // Formatear fecha a español
  $: fechaFormateada = creado_en ? new Date(creado_en).toLocaleDateString('es-ES', { year: 'numeric', month: 'short', day: 'numeric' }) : '';

  // Limitar resumen a 150 caracteres
  $: resumenLimitado = resumen && resumen.length > 150 ? resumen.slice(0, 150) + '…' : resumen;

  // Autor fijo
  $: autorFijo = 'AMAZON CAMP';

  function irAlArticulo() {
    if (slug) goto(`/blog/${slug}`);
  }
</script>

<div class="tarjeta-articulo" on:click={irAlArticulo} tabindex="0" role="button" aria-label={`Leer artículo: ${titulo}`}>
  <div class="imagen-articulo" style="background-image:url('{imagen_url || "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80"}')"></div>
  <div class="contenido-articulo">
    <h2>{titulo}</h2>
    <p class="resumen">{resumenLimitado}</p>
    <div class="meta">
      <span class="autor">{autorFijo}</span> · <span class="fecha">{fechaFormateada}</span>
    </div>
    <button class="leer-mas" on:click|stopPropagation={irAlArticulo}>Leer más</button>
  </div>
</div>

<style>
.tarjeta-articulo {
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 6px 24px rgba(44,85,48,0.10);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: transform 0.18s, box-shadow 0.18s;
  cursor: pointer;
  min-width: 260px;
  animation: fadeInUp 0.9s cubic-bezier(.77,0,.18,1);
}
.tarjeta-articulo:hover {
  transform: translateY(-5px) scale(1.015);
  box-shadow: 0 14px 36px rgba(44,85,48,0.16);
}
.imagen-articulo {
  width: 100%;
  height: 170px;
  background-size: cover;
  background-position: center;
}
.contenido-articulo {
  padding: 18px 20px 20px 20px;
  display: flex;
  flex-direction: column;
  flex: 1;
}
.contenido-articulo h2 {
  font-size: 1.18rem;
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  margin-bottom: 8px;
  font-weight: bold;
  color: #2c5530;
}
.resumen {
  font-size: 1rem;
  color: #444;
  margin-bottom: 10px;
}
.meta {
  font-size: 0.94rem;
  color: #7a7a7a;
  margin-bottom: 10px;
}
.leer-mas {
  align-self: flex-start;
  background: linear-gradient(90deg, #4CAF50, #8BC34A);
  color: #fff;
  border: none;
  border-radius: 20px;
  padding: 7px 24px;
  font-size: 0.98rem;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.3s, transform 0.2s;
}
.leer-mas:hover {
  background: linear-gradient(90deg, #388E3C, #689F38);
  transform: scale(1.04);
}
@media (max-width: 700px) {
  .tarjeta-articulo { min-width: 180px; }
  .imagen-articulo { height: 110px; }
  .contenido-articulo { padding: 12px 10px 14px 10px; }
  .contenido-articulo h2 { font-size: 1rem; }
}
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
