<script>
  export let recientes = [];
  export let destacados = [];
</script>

<aside class="sidebar-articulo">
  <div class="banner-suscripcion">
    <h3>Suscríbete a nuestro boletín</h3>
    <input type="email" placeholder="Tu correo electrónico" />
    <button>Suscribirme</button>
  </div>
  <div class="noticias-recientes">
    <h4>Últimas noticias</h4>
    <ul>
      {#each recientes as noticia}
        <li>
          <img src={noticia.imagen_url} alt={noticia.titulo} />
          <div>
            <a href={`/blog/${noticia.slug}`}>{noticia.titulo}</a>
            <span>{new Date(noticia.creado_en).toLocaleDateString('es-ES', { month: 'short', day: 'numeric' })}</span>
          </div>
        </li>
      {/each}
    </ul>
  </div>
  <div class="destacados">
    <h4>Recomendados</h4>
    <ul>
      {#each destacados as destacado}
        <li>
          <img src={destacado.imagen_url} alt={destacado.titulo} />
          <div>
            <a href={`/blog/${destacado.slug}`}>{destacado.titulo}</a>
            <span>{new Date(destacado.creado_en).toLocaleDateString('es-ES', { month: 'short', day: 'numeric' })}</span>
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
  gap: 32px;
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
  margin-bottom: 8px;
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
}
.banner-suscripcion button:hover {
  background: #388E3C;
  color: #fff;
}
.noticias-recientes, .destacados {
  background: #fff;
  border-radius: 18px;
  padding: 14px 10px 10px 10px;
  box-shadow: 0 4px 18px rgba(44,85,48,0.09);
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
</style>
