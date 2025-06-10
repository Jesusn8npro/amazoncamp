<script>
  export let imagenes = [];
  let imagenSeleccionada = null;
  function abrirLightbox(img) {
    imagenSeleccionada = img;
  }
  function cerrarLightbox() {
    imagenSeleccionada = null;
  }
</script>

<section class="galeria-paquete">
  <div class="galeria-header">
  <span class="badge-naranja">EXPERIENCIAS REALES</span>
  <h2 class="galeria-titulo animate-titulo">¡Esto es lo que vivirás!</h2>
  <p class="galeria-subtitulo">Imagina tus próximas aventuras y emociones. Estas fotos son solo el comienzo de lo que te espera…</p>
</div>
  <div class="galeria-grid">
    {#each imagenes as img, i}
      <img src={img} alt="Foto del paquete" class="galeria-img" loading="lazy" on:click={() => abrirLightbox(img)} />
    {/each}
  </div>

  {#if imagenSeleccionada}
    <div class="lightbox" on:click={cerrarLightbox}>
      <img src={imagenSeleccionada} alt="Imagen ampliada" class="lightbox-img" />
      <button class="cerrar-lightbox" on:click|stopPropagation={cerrarLightbox}>✕</button>
    </div>
  {/if}
</section>

<style>
.galeria-paquete {
  margin: 0 auto 0px auto;
  width: 100%;
  padding: 62px 5vw 56px 5vw;
  background: linear-gradient(120deg, #fff7ed 70%, #fbbf24 100%);
  box-shadow: 0 8px 48px rgba(234,88,12,0.09);
  border: 2.5px solid #fbbf24;
  animation: fadeInUp 0.7s;
  position: relative;
  overflow: visible;
}
.galeria-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 18px;
  gap: 5px;
}
.badge-naranja {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  color: #fff;
  font-weight: 800;
  font-size: 0.98rem;
  border-radius: 8px;
  padding: 4px 18px;
  margin-bottom: 7px;
  letter-spacing: 1.5px;
  box-shadow: 0 2px 8px rgba(234,88,12,0.13);
  animation: popIn 0.8s;
  text-align: center;
}
.galeria-titulo {
  font-size: 2.25rem;
  font-weight: 900;
  color: #ea580c;
  margin-bottom: 7px;
  text-align: left;
  letter-spacing: -1px;
  animation: popIn 0.8s;
}
.galeria-subtitulo {
  color: #92400e;
  font-size: 1.13rem;
  font-weight: 600;
  margin-bottom: 0;
  margin-top: 0;
  text-shadow: 0 2px 8px rgba(251,191,36,0.08);
  animation: fadeInUp 1.1s;
}
.galeria-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 34px;
  width: 100%;
  margin-top: 18px;
}
.galeria-img {
  width: 100%;
  aspect-ratio: 4/3;
  object-fit: cover;
  border-radius: 22px;
  box-shadow: 0 8px 32px 0 rgba(234,88,12,0.13), 0 1.5px 32px 0 rgba(251,191,36,0.10);
  border: 2.5px solid #fbbf24;
  cursor: pointer;
  transition: transform 0.23s cubic-bezier(.4,0,.2,1), box-shadow 0.23s, border 0.23s, filter 0.23s;
  filter: brightness(0.97) saturate(1.07) blur(0.2px);
  position: relative;
  background: rgba(255,255,255,0.18);
  z-index: 1;
}
.galeria-img:hover {
  transform: scale(1.09) translateY(-10px) rotate(-2deg);
  box-shadow: 0 18px 64px 0 rgba(234,88,12,0.22), 0 2px 44px 0 rgba(251,191,36,0.18);
  filter: brightness(1.08) saturate(1.18) blur(0px);
  border: 2.5px solid #fbbf24;
  z-index: 2;
}
.galeria-img:hover + .img-overlay {
  opacity: 1;
  pointer-events: auto;
}
.img-overlay {
  pointer-events: none;
  opacity: 0;
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  border-radius: 22px;
  background: linear-gradient(120deg, rgba(251,191,36,0.22) 0%, rgba(234,88,12,0.13) 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  transition: opacity 0.23s;
  z-index: 3;
}
.galeria-img:hover ~ .img-overlay {
  opacity: 1;
  pointer-events: auto;
}
.img-overlay svg {
  width: 52px;
  height: 52px;
  color: #fff;
  filter: drop-shadow(0 2px 8px #ea580c);
  opacity: 0.95;
}
.lightbox {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(0,0,0,0.82);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  animation: fadeIn 0.2s;
}
.lightbox-img {
  max-width: 90vw;
  max-height: 80vh;
  border-radius: 18px;
  box-shadow: 0 8px 32px rgba(234,88,12,0.22);
  animation: popIn 0.3s;
}
.cerrar-lightbox {
  position: absolute;
  top: 36px;
  right: 54px;
  font-size: 2.2rem;
  color: #fff;
  background: transparent;
  border: none;
  cursor: pointer;
  z-index: 10000;
  transition: color 0.18s;
}
.cerrar-lightbox:hover {
  color: #ea580c;
}
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
@keyframes fadeInUp {
  0% { opacity: 0; transform: translateY(40px); }
  100% { opacity: 1; transform: translateY(0); }
}
@keyframes popIn {
  0% { opacity: 0; transform: scale(0.85); }
  100% { opacity: 1; transform: scale(1); }
}
@media (max-width: 700px) {
  .galeria-titulo {
    font-size: 1.3rem;
    margin-bottom: 13px;
  }
  .galeria-grid {
    gap: 11px;
  }
  .cerrar-lightbox {
    top: 14px;
    right: 16px;
    font-size: 1.4rem;
  }
}
</style>
