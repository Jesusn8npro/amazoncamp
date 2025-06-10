<script>
  export let beneficios = [];
  export let tituloPaquete = '';

  function scrollToHero() {
    const form = document.querySelector('.formulario-reserva');
    if(form) form.scrollIntoView({behavior:'smooth'});
  }
</script>

<section class="beneficios-exclusivos">
  <div class="beneficios-header">
    <span class="badge-beneficios">BENEFICIOS EXCLUSIVOS</span>
    <h2 class="beneficios-titulo">Beneficios exclusivos de <span class="paquete-titulo">{tituloPaquete}</span></h2>
    <p class="beneficios-subtitulo">Descubre lo que hace única tu experiencia con nosotros y por qué cientos de viajeros nos recomiendan.</p>
  </div>
  <div class="beneficios-grid">
    {#if beneficios && beneficios.length > 0}
      {#each beneficios.slice(0,6) as b, i}
        <div class="beneficio-card" style="animation-delay: {i * 110}ms">
          <span class="beneficio-icono">{b.icono ?? '🌟'}</span>
          <div class="beneficio-txt">
            <h3>{b.titulo ?? b}</h3>
            {#if b.descripcion}
              <p>{b.descripcion}</p>
            {/if}
          </div>
        </div>
      {/each}
    {:else}
      <div class="beneficio-card placeholder">
        <div class="beneficio-txt">
          <h3>No hay beneficios cargados para este paquete.</h3>
          <p>Pronto agregaremos información exclusiva.</p>
        </div>
      </div>
    {/if}
  </div>
  <button class="btn-cta-beneficios" on:click={scrollToHero}>
    ¡Reserva tu lugar ahora!
  </button>
</section>

<style>
.beneficios-exclusivos {
  width: 100%;
  padding: 54px 5vw 44px 5vw;
  background: linear-gradient(110deg, rgba(0,0,0,0.93) 60%, rgba(34,197,94,0.16) 120%), url('https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=1200&q=80');
  background-size: cover;
  background-position: center;
  box-shadow: 0 6px 32px rgba(16,185,129,0.12);
  border: 2.5px solid #222;
  animation: fadeInUp 0.7s;
  position: relative;
  overflow: visible;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 1;
}

.beneficios-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 22px;
  gap: 6px;
}
.badge-beneficios {
  background: linear-gradient(90deg, #16a34a 0%, #fbbf24 100%);
  color: #fff;
  font-weight: 900;
  font-size: 1.05rem;
  border-radius: 8px;
  padding: 4px 22px;
  margin-bottom: 7px;
  letter-spacing: 1.5px;
  box-shadow: 0 2px 8px rgba(16,185,129,0.13);
  animation: popIn 0.8s;
  text-align: center;
}
.beneficios-titulo {
  font-size: 2.1rem;
  font-weight: 900;
  color: #fbbf24;
  margin-bottom: 8px;
  text-align: center;
  letter-spacing: -1px;
  animation: popIn 0.8s;
  text-shadow: 0 2px 16px #0008;
}
.paquete-titulo {
  color: #fff;
  font-weight: 700;
  font-size: 1.1em;
  text-shadow: 0 2px 10px #000b;
}
.beneficios-subtitulo {
  color: #fff;
  font-size: 1.13rem;
  font-weight: 600;
  margin-bottom: 0;
  margin-top: 0;
  text-shadow: 0 2px 8px #000a;
  animation: fadeInUp 1.1s;
  text-align: center;
}
.beneficios-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 32px 40px;
  width: 100%;
  margin: 0 0 34px 0;
  padding: 0;
  align-items: stretch;
  justify-content: center;
}
.beneficio-card {
  background: rgba(24,24,24,0.93);
  border-radius: 18px;
  box-shadow: 0 2px 18px rgba(16,185,129,0.16);
  display: flex;
  align-items: flex-start;
  gap: 18px;
  padding: 22px 20px 18px 20px;
  font-size: 1.08rem;
  font-weight: 600;
  color: #fff;
  transition: box-shadow 0.19s, transform 0.19s;
  border: 2px solid #333;
  position: relative;
  opacity: 0;
  transform: translateY(40px) scale(0.97);
  animation: fadeInStagger 0.7s cubic-bezier(.4,0,.2,1) forwards;
}

.beneficio-card:hover {
  box-shadow: 0 8px 32px rgba(251,191,36,0.13);
  transform: scale(1.03) translateY(-2px);
  border-color: #fbbf24;
}
.beneficio-icono {
  font-size: 2.5rem;
  margin-right: 6px;
  filter: drop-shadow(0 2px 8px #fbbf24);
  flex-shrink: 0;
  align-self: flex-start;
  transition: transform 0.18s;
}
.beneficio-card:hover .beneficio-icono {
  transform: scale(1.13) rotate(-8deg);
}
.beneficio-txt h3 {
  font-size: 1.12rem;
  margin: 0 0 6px 0;
  color: #fbbf24;
  font-weight: 800;
  text-shadow: 0 2px 10px #000b;
}
.beneficio-txt p {
  margin: 0;
  color: #fff;
  font-size: 1.01rem;
  font-weight: 500;
  text-shadow: 0 1px 8px #0009;
}
.btn-cta-beneficios {
  margin-top: 18px;
  background: linear-gradient(90deg, #16a34a 0%, #fbbf24 100%);
  color: #fff;
  font-weight: 900;
  font-size: 1.17rem;
  border: none;
  border-radius: 12px;
  padding: 15px 38px;
  box-shadow: 0 4px 24px rgba(16,185,129,0.13), 0 0 0 0 #fbbf24;
  cursor: pointer;
  transition: background 0.2s, transform 0.2s, box-shadow 0.2s;
  animation: bounceIn 1.1s cubic-bezier(.4,0,.2,1), glowPulse 2.5s infinite alternate;
  position: relative;
  z-index: 2;
}
.btn-cta-beneficios:hover {
  background: linear-gradient(90deg, #fbbf24 0%, #16a34a 100%);
  transform: scale(1.05) translateY(-2px);
  box-shadow: 0 8px 32px rgba(251,191,36,0.18), 0 0 16px 6px #fbbf24cc;
}
@keyframes fadeInUp {
  0% { opacity: 0; transform: translateY(40px); }
  100% { opacity: 1; transform: translateY(0); }
}
@keyframes fadeInStagger {
  0% { opacity: 0; transform: translateY(40px) scale(0.97); }
  100% { opacity: 1; transform: translateY(0) scale(1); }
}
@keyframes glowPulse {
  0% { box-shadow: 0 0 0 0 #fbbf24cc, 0 4px 24px rgba(16,185,129,0.13); }
  100% { box-shadow: 0 0 24px 8px #fbbf24cc, 0 4px 24px rgba(16,185,129,0.13); }
}
@keyframes popIn {
  0% { opacity: 0; transform: scale(0.85); }
  100% { opacity: 1; transform: scale(1); }
}
@keyframes bounceIn {
  0% { opacity: 0; transform: scale(0.7) translateY(80px); }
  60% { opacity: 1; transform: scale(1.08) translateY(-12px); }
  80% { transform: scale(0.95) translateY(6px); }
  100% { opacity: 1; transform: scale(1) translateY(0); }
}
@media (max-width: 700px) {
  .beneficios-titulo {
    font-size: 1.3rem;
    margin-bottom: 13px;
  }
  .beneficios-grid {
    gap: 13px 6px;
  }
  .btn-cta-beneficios {
    width: 100%;
    padding: 14px 0;
    font-size: 1.05rem;
  }
}
</style>
