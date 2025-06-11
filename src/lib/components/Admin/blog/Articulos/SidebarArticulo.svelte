<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js'; // Ajusta la ruta si es necesario

  export let recientes = [];
  let paquetes = [];

  // Cargar paquetes recomendados/destacados desde Supabase
  onMount(async () => {
    const { data, error } = await supabase
      .from('paquetes')
      .select('id, slug, titulo, ubicacion, precio_desde, imagen_principal')
      .eq('destacado', true)
      .order('creado_en', { ascending: false })
      .limit(8);
    if (!error && data) paquetes = data;
  });
</script>

<aside class="sidebar-articulo">
  <div class="banner-suscripcion">
    <h3>Suscríbete a nuestro boletín</h3>
    <input type="email" placeholder="Tu correo electrónico" />
    <button>Suscribirme</button>
  </div>
  <div class="noticias-recientes">
    <h4>Últimas noticias</h4>
    <div class="noticias-lista">
      {#each recientes as noticia}
        <div class="noticia-tarjeta">
          <img src={noticia.imagen_url} alt={noticia.titulo} />
          <div class="noticia-info">
            <a href={`/blog/${noticia.slug}`} class="noticia-titulo">{noticia.titulo}</a>
            <span class="noticia-fecha">{new Date(noticia.creado_en).toLocaleDateString('es-ES', { month: 'short', day: 'numeric' })}</span>
          </div>
        </div>
      {/each}
    </div>
  </div>
  <div class="recomendados-paquetes">
    <h4>Recomendados</h4>
    <ul>
      {#each paquetes as paquete}
        <li>
          <img src={paquete.imagen_principal} alt={paquete.titulo} />
          <div>
            <a href={`/paquetes/${paquete.slug}`}>{paquete.titulo}</a>
            <span class="ubicacion">{paquete.ubicacion}</span>
            <span class="precio">Desde S/ {paquete.precio_desde}</span>
            <a class="cta-paquete" href={`/paquetes/${paquete.slug}`}>Ver paquete</a>
          </div>
        </li>
      {/each}
    </ul>
  </div>
</aside>

<style>
.sidebar-articulo {
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-width: 270px;
  max-width: 320px;
  margin-left: 30px;
  position: sticky;
  top: 32px;
  align-self: flex-start;
  z-index: 10;
}
.banner-suscripcion {
  background: linear-gradient(120deg, #4CAF50 80%, #8BC34A 100%);
  color: #fff;
  border-radius: 18px;
  padding: 22px 20px 18px 20px;
  box-shadow: 0 4px 18px rgba(44,85,48,0.13);
  text-align: center;
}
.banner-suscripcion input {
  width: 100%;
  padding: 10px;
  border-radius: 12px;
  border: none;
  margin-top: 10px;
  font-size: 1rem;
}
.banner-suscripcion button {
  background: #fff;
  color: #388E3C;
  font-weight: bold;
  border: none;
  border-radius: 12px;
  padding: 8px 26px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  margin-top: 20px;
}
.banner-suscripcion button:hover {
  background: #388E3C;
  color: #fff;
}
.noticias-recientes {
  background: #fff;
  border-radius: 18px;
  padding: 14px 10px 10px 10px;
  box-shadow: 0 4px 18px rgba(44,85,48,0.09);
}
.noticias-lista {
  display: flex;
  flex-direction: column;
  gap: 1px;
}
.noticia-tarjeta {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  background: #f7fff9;
  border-radius: 13px;
  box-shadow: 0 2px 10px #b5e3a326;
  padding: 8px 8px 4px 8px;
  margin-bottom: 0;
  transition: box-shadow 0.18s, transform 0.18s;
}
.noticia-tarjeta:hover {
  box-shadow: 0 6px 18px #4caf5030;
  transform: translateY(-2px) scale(1.028);
}
.noticia-tarjeta img {
  width: 52px;
  height: 52px;
  object-fit: cover;
  border-radius: 8px;
}
.noticia-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  min-width: 0;
}
.noticia-titulo {
  color: #388E3C;
  font-weight: 700;
  text-decoration: none;
  font-size: 1.03rem;
  margin-bottom: 1px;
  line-height: 1.15;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.noticia-titulo:hover {
  text-decoration: underline;
}
.noticia-fecha {
  color: #888;
  font-size: 0.88rem;
  margin-top: 2px;
  display: block;
}
.noticias-recientes h4, .destacados h4 {
  margin-bottom: 12px;
  color: #2c5530;
}
.noticias-recientes ul, .destacados ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.noticias-recientes li, .destacados li {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}
.noticias-recientes img, .destacados img {
  width: 48px;
  height: 48px;
  object-fit: cover;
  border-radius: 8px;
}
.noticias-recientes a, .destacados a {
  color: #388E3C;
  font-weight: 600;
  text-decoration: none;
  font-size: 0.98rem;
}
.noticias-recientes a:hover, .destacados a:hover {
  text-decoration: underline;
}
.noticias-recientes span, .destacados span {
  display: block;
  color: #888;
  font-size: 0.85rem;
}
@media (max-width: 900px) {
  .sidebar-articulo { margin-left: 0; min-width: 100%; max-width: 100%; position: static; top: unset; }
}
.recomendados-paquetes {
  background: #f7fff9;
  border-radius: 18px;
  padding: 14px 10px 10px 10px;
  box-shadow: 0 4px 18px rgba(44,85,48,0.09);
  margin-top: 14px;
}
.recomendados-paquetes h4 {
  margin-bottom: 12px;
  color: #1b5e20;
}
.recomendados-paquetes ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.recomendados-paquetes li {
  display: flex;
  align-items: flex-start;
  gap: 13px;
  margin-bottom: 17px;
}
.recomendados-paquetes img {
  width: 54px;
  height: 54px;
  object-fit: cover;
  border-radius: 11px;
  box-shadow: 0 2px 8px #b5e3a326;
}
.recomendados-paquetes a.cta-paquete {
  display: inline-block;
  margin-top: 7px;
  background: linear-gradient(90deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
  font-weight: 700;
  padding: 4px 14px;
  border-radius: 8px;
  text-decoration: none;
  font-size: 0.95em;
  transition: background 0.15s, color 0.15s;
}
.recomendados-paquetes a.cta-paquete:hover {
  background: #388E3C;
  color: #fff;
}
.recomendados-paquetes .ubicacion {
  display: block;
  color: #2c5530;
  font-size: 0.93em;
  margin-top: 2px;
}
.recomendados-paquetes .precio {
  display: block;
  color: #1976d2;
  font-size: 0.95em;
  margin-top: 2px;
  font-weight: 600;
}
</style>
