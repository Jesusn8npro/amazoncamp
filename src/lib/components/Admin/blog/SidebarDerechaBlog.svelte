<script>
  // Placeholders para banners, suscripción y populares
</script>

<aside class="sidebar-derecha-blog">
  <div class="banner-suscripcion">
    <h3>Recibe novedades y tips exclusivos</h3>
    <p class="texto-suscripcion">Suscríbete y recibe cada mes los mejores consejos, historias y promociones únicas para tu próxima aventura en la Amazonía.</p>
    <div class="campo-suscripcion">
      <input type="email" placeholder="Tu correo electrónico" />
      <button>Suscribirme</button>
    </div>
  </div>
  <div class="banner-promocion">
    <img src="https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80" alt="Promo Amazon Camp" />
    <p class="promo-texto">¡Descubre nuestros <strong>tours exclusivos</strong> y vive la selva como nunca antes!</p>
  </div>
  <div class="articulos-populares">
    <h4>Artículos populares</h4>
    <ul>
      <li>¿Cómo preparar tu viaje a la Amazonía?</li>
      <li>Top 5 animales que verás en la selva</li>
      <li>Consejos para viajeros primerizos</li>
    </ul>
  </div>
  <div class="redes-sociales">
    <h4>Síguenos</h4>
    <div class="iconos-redes">
      <span title="Instagram" class="icono-red">📸</span>
      <span title="Facebook" class="icono-red">👍</span>
      <span title="Twitter" class="icono-red">🐦</span>
    </div>
  </div>
</aside>

<style>
.sidebar-derecha-blog {
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
  padding: 28px 20px 20px 20px;
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
.banner-promocion {
  background: #fff;
  border-radius: 18px;
  padding: 14px 10px 10px 10px;
  text-align: center;
  box-shadow: 0 4px 18px rgba(44,85,48,0.09);
}
.banner-promocion img {
  width: 100%;
  border-radius: 12px;
  margin-bottom: 8px;
}
.articulos-populares {
  background: #f4f4f4;
  border-radius: 16px;
  padding: 18px 16px;
}
.articulos-populares h4 {
  margin-bottom: 10px;
  color: #2c5530;
}
.articulos-populares ul {
  list-style: disc inside;
  color: #444;
  font-size: 0.98rem;
}
.redes-sociales {
  text-align: center;
}
.redes-sociales h4 {
  margin-bottom: 8px;
  color: #2c5530;
}
.iconos-redes a {
  font-size: 1.8rem;
  margin: 0 8px;
  text-decoration: none;
  color: #388E3C;
  transition: color 0.2s;
}
.iconos-redes a:hover {
  color: #8BC34A;
}
@media (max-width: 900px) {
  .sidebar-derecha-blog { margin-left: 0; min-width: 100%; max-width: 100%; }
}
</style>
