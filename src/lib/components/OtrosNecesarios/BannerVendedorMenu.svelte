<script>
  import { onMount } from 'svelte';
  export let minutos = 15; // Duración de la oferta en minutos
  let segundosRestantes = minutos * 60;
  let timer;

  $: minutosMostrar = Math.floor(segundosRestantes / 60);
  $: segundosMostrar = (segundosRestantes % 60).toString().padStart(2, '0');

  onMount(() => {
    timer = setInterval(() => {
      if (segundosRestantes > 0) {
        segundosRestantes--;
      } else {
        clearInterval(timer);
      }
    }, 500);
    return () => clearInterval(timer);
  });

  function reservarAhora() {
    // Puedes personalizar la acción (scroll, modal, redirección, etc.)
    window.location.href = '#formulario-reserva';
  }
</script>

<style>
.banner-vendedor {
  background: linear-gradient(90deg, #ffb347 0%, #ffcc33 100%);
  color: #222;
  border-radius: 1.2rem;
  box-shadow: 0 2px 12px rgba(255, 179, 71, 0.15);
  margin: 1.2rem 1rem 0.5rem 1rem;
  padding: 1.1rem 1.2rem 1.2rem 1.2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.7rem;
  animation: aparecerBanner 0.7s cubic-bezier(.6,-0.28,.74,.05);
  border: 2px solid #fffbe6;
  position: relative;
  overflow: hidden;
  top: -100px;
}
@keyframes aparecerBanner {
  from { opacity: 0; transform: translateY(-40px) scale(0.8); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}
.banner-titulo {
  font-size: 1.2rem;
  font-weight: bold;
  letter-spacing: 0.5px;
  color: #d35400;
  text-shadow: 0 1px 0 #fffbe6;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.banner-oferta {
  font-size: 1.1rem;
  color: #222;
  font-weight: 500;
}
.banner-contador {
  background: #fffbe6;
  color: #d35400;
  font-size: 1.1rem;
  border-radius: 1rem;
  padding: 0.3rem 1.2rem;
  font-weight: bold;
  margin: 0.3rem 0;
  animation: pulseContador 1.2s infinite;
}
@keyframes pulseContador {
  0% { box-shadow: 0 0 0 0 #ffb34755; }
  70% { box-shadow: 0 0 0 10px #ffb34700; }
  100% { box-shadow: 0 0 0 0 #ffb34700; }
}
.banner-btn-reserva {
  background: #25d366;
  color: white;
  border: none;
  border-radius: 2rem;
  padding: 0.6rem 1.8rem;
  font-size: 1.1rem;
  font-weight: bold;
  box-shadow: 0 2px 8px rgba(37, 211, 102, 0.13);
  cursor: pointer;
  transition: background 0.2s, transform 0.2s;
  margin-top: 0.2rem;
  display: flex;
  align-items: center;
  gap: 0.7rem;
}
.banner-btn-reserva:hover {
  background: #1da851;
  transform: scale(1.06) translateY(-2px);
}
.banner-fire {
  color: #e67e22;
  font-size: 1.3rem;
  animation: flame 1.1s infinite alternate;
}
@keyframes flame {
  0% { filter: drop-shadow(0 0 0px #ffb347); }
  100% { filter: drop-shadow(0 0 7px #ffb347); }
}
</style>

<div class="banner-vendedor">
  <div class="banner-titulo">
    <span class="banner-fire">🔥</span>
    ¡Oferta exclusiva por tiempo limitado!
  </div>
  <div class="banner-oferta">
    Reserva ahora y obtén un <b>descuento especial</b> solo hoy.
  </div>
  <div class="banner-contador">
    Termina en: {minutosMostrar}:{segundosMostrar}
  </div>
  <button class="banner-btn-reserva" on:click={reservarAhora}>
    Reservar ahora
    <i class="fab fa-whatsapp"></i>
  </button>
</div>
<!-- Asegúrate de tener FontAwesome cargado para el ícono -->
