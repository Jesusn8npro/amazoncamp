<script>
  export let incluye = [];
  
  // Íconos de ejemplo para los primeros 8 ítems, puedes personalizar según tu data
  const iconos = [
    '🌴', '🛶', '🍽️', '🛏️', '🚐', '👨‍🏫', '🔥', '🏞️'
  ];

  function scrollToHero() {
    const form = document.querySelector('.formulario-reserva');
    if(form) form.scrollIntoView({behavior:'smooth'});
  }
</script>

<section class="incluye-paquete">
  <!-- Partículas animadas -->
  <div class="particulas-bg">
    {#each Array(12) as _, i}
      <span class="particula" style="--i: {i};"></span>
    {/each}
  </div>
  <div class="incluye-header">
    <span class="badge-incluye">INCLUYE TODO ESTO</span>
    <h2 class="incluye-titulo">¿Qué incluye tu experiencia?</h2>
    <p class="incluye-subtitulo">Disfruta de beneficios exclusivos y todo lo necesario para una aventura sin preocupaciones.</p>
  </div>
  <ul class="incluye-lista">
    {#each incluye as item, i}
      <li class="incluye-item" style="animation-delay: {i * 90}ms">
        <span class="incluye-icono">{iconos[i % iconos.length]}</span>
        <span class="incluye-texto">{item}</span>
      </li>
    {/each}
  </ul>
  <button class="btn-cta-incluye" on:click={scrollToHero}>
    ¡Quiero reservar mi experiencia!
  </button>
</section>

<style>
.incluye-paquete {
  width: 100%;
  padding: 54px 5vw 44px 5vw;
  background: linear-gradient(110deg, rgba(0,0,0,0.86) 60%, rgba(34,197,94,0.14) 120%), url('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=1200&q=80');
  background-size: cover;
  background-position: center;
  box-shadow: 0 6px 32px rgba(16,185,129,0.08);
  border: 2.5px solid #222;
  animation: fadeInUp 0.7s;
  position: relative;
  overflow: visible;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 1;
}

.particulas-bg {
  pointer-events: none;
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  z-index: 0;
  overflow: hidden;
}
.particula {
  position: absolute;
  display: block;
  border-radius: 50%;
  opacity: 0.18;
  background: linear-gradient(120deg, #fbbf24 60%, #16a34a 100%);
  width: calc(22px + 2.5vw);
  height: calc(22px + 2.5vw);
  left: calc(var(--i) * 8% + 5%);
  top: calc(10% + (var(--i) % 6) * 12%);
  filter: blur(1.5px);
  animation: flotarParticula 8s linear infinite;
  animation-delay: calc(var(--i) * -0.7s);
}
@keyframes flotarParticula {
  0% { transform: translateY(0) scale(1); opacity: 0.18; }
  40% { opacity: 0.25; }
  60% { opacity: 0.22; }
  100% { transform: translateY(-40px) scale(1.13); opacity: 0.13; }
}

.incluye-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 22px;
  gap: 6px;
}
.badge-incluye {
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
.incluye-titulo {
  font-size: 2.1rem;
  font-weight: 900;
  color: #16a34a;
  margin-bottom: 8px;
  text-align: center;
  letter-spacing: -1px;
  animation: popIn 0.8s;
}
.incluye-subtitulo {
  color: #166534;
  font-size: 1.13rem;
  font-weight: 600;
  margin-bottom: 0;
  margin-top: 0;
  text-shadow: 0 2px 8px rgba(16,185,129,0.08);
  animation: fadeInUp 1.1s;
  text-align: center;
}
.incluye-lista {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
  gap: 22px 34px;
  width: 100%;
  margin: 0 0 34px 0;
  padding: 0;
  list-style: none;
  align-items: stretch;
  justify-content: center;
}
.incluye-item {
  background: rgba(255,255,255,0.97);
  border-radius: 16px;
  box-shadow: 0 2px 18px rgba(16,185,129,0.09);
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 17px 18px;
  font-size: 1.08rem;
  font-weight: 600;
  color: #166534;
  transition: box-shadow 0.19s, transform 0.19s;
  border: 2px solid #bbf7d0;
  position: relative;
  opacity: 0;
  transform: translateY(40px) scale(0.97);
  animation: fadeInStagger 0.7s cubic-bezier(.4,0,.2,1) forwards;
}

.incluye-item:hover {
  box-shadow: 0 8px 32px rgba(251,191,36,0.13);
  transform: scale(1.03) translateY(-2px);
  border-color: #fbbf24;
}
.incluye-icono {
  font-size: 2rem;
  margin-right: 6px;
  filter: drop-shadow(0 2px 8px #fbbf24);
  flex-shrink: 0;
}
.btn-cta-incluye {
  margin-top: 18px;
  background: linear-gradient(90deg, #fbbf24 0%, #16a34a 100%);
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
.btn-cta-incluye:hover {
  background: linear-gradient(90deg, #16a34a 0%, #fbbf24 100%);
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
  .incluye-titulo {
    font-size: 1.3rem;
    margin-bottom: 13px;
  }
  .incluye-lista {
    gap: 13px 6px;
  }
  .btn-cta-incluye {
    width: 100%;
    padding: 14px 0;
    font-size: 1.05rem;
  }
}
</style>
