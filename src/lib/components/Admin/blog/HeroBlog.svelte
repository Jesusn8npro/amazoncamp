<script>
  export let titulo = 'Blog Amazon Camp';
  export let descripcion = 'Sumérgete en relatos inspiradores, guías prácticas, experiencias reales y los mejores consejos para vivir la Amazonía al máximo. Descubre cómo transformar tu próxima aventura en una experiencia inolvidable, conecta con la naturaleza y mantente al día con las novedades de Amazon Camp.';
  export let ctaTexto = 'Suscríbete a las novedades';
  export let onCta = () => {};
  // Animación typing para el título
  let tituloAnimado = '';
  let index = 0;
  let typingInterval;
  
  import { onMount, onDestroy } from 'svelte';
  
  onMount(() => {
    typingInterval = setInterval(() => {
      if (index < titulo.length) {
        tituloAnimado += titulo[index];
        index++;
      } else {
        clearInterval(typingInterval);
      }
    }, 70);
  });
  
  onDestroy(() => {
    clearInterval(typingInterval);
  });
</script>

<section class="hero-blog">
  <div class="overlay"></div>
  <div class="contenido-hero">
    <h1 class="titulo-animado">{tituloAnimado}</h1>
    <p>{descripcion}</p>
    <button class="boton-cta" on:click={onCta}>{ctaTexto}</button>
  </div>
</section>

<style>
.hero-blog {
  position: relative;
  width: 100vw;
  left: 50%;
  right: 50%;
  margin-left: -50vw;
  margin-right: -50vw;
  min-height: 340px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: url('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1400&q=80') center/cover no-repeat;
  box-shadow: 0 8px 40px rgba(44,85,48,0.14);
  z-index: 1;
}
.overlay {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: linear-gradient(135deg, rgba(44,85,48,0.7) 0%, rgba(26,77,31,0.8) 100%);
  z-index: 2;
}
.contenido-hero {
  position: relative;
  z-index: 3;
  color: #fff;
  text-align: center;
  max-width: 700px;
  margin: 0 auto;
  animation: fadeInDown 1.1s cubic-bezier(.77,0,.18,1);
}
.contenido-hero h1 {
  font-size: 3rem;
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  margin-bottom: 16px;
  letter-spacing: 1px;
}
.contenido-hero p {
  font-size: 1.25rem;
  margin-bottom: 28px;
  font-weight: 400;
}
.boton-cta {
  background: linear-gradient(90deg, #4CAF50, #8BC34A);
  color: #fff;
  border: none;
  border-radius: 30px;
  padding: 14px 38px;
  font-size: 1.1rem;
  font-weight: bold;
  cursor: pointer;
  box-shadow: 0 4px 18px rgba(44,85,48,0.13);
  transition: background 0.3s, transform 0.2s;
}
.boton-cta:hover {
  background: linear-gradient(90deg, #388E3C, #689F38);
  transform: translateY(-2px) scale(1.04);
}
@media (max-width: 700px) {
  .contenido-hero h1 { font-size: 2rem; }
  .contenido-hero p { font-size: 1rem; }
  .hero-blog { min-height: 200px; }
}
@keyframes fadeInDown {
  from { opacity: 0; transform: translateY(-60px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
