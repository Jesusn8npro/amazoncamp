<script>
// Datos de ejemplo: destinos para el slider
const destinos = [
  {
    subtitulo: 'Amazonía Peruana',
    titulo: 'Explora la Amazonía sin miedo',
    descripcion: 'Guías expertos, lodge equipado y experiencias que te transforman. Todo incluido, cero improvisación.',
    boton: 'Reserva tu experiencia',
    imagen: 'https://images.unsplash.com/photo-1591081658714-f576fb7ea3ed?q=80&w=2671&auto=format&fit=crop',
  },
  {
    subtitulo: 'Amazonía Peruana',
    titulo: 'Aventura sí, pero con Wi-Fi',
    descripcion: 'Amazonía profunda sin sacrificar tu comodidad. Así se viaja hoy.',
    boton: 'Quiero vivirlo',
    imagen: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
  },
  {
    subtitulo: 'Amazonía Peruana',
    titulo: 'No es un tour más… es una experiencia',
    descripcion: 'Incluye todo: traslados, comidas, guías, lodge premium y naturaleza viva.',
    boton: 'Descubre los programas',
    imagen: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80',
  },
  {
    subtitulo: 'Amazonía Peruana',
    titulo: 'Conecta con lo esencial',
    descripcion: 'Ceremonias de ayahuasca opcionales y experiencias conscientes en el corazón del Amazonas.',
    boton: 'Quiero algo real',
    imagen: 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=800&q=80',
  },
  {
    subtitulo: 'Amazonía Peruana',
    titulo: 'Selva y cultura en armonía',
    descripcion: 'Descubre comunidades nativas, arte, biodiversidad y paisajes únicos en un solo viaje.',
    boton: 'Ver experiencias',
    imagen: 'https://images.unsplash.com/photo-1508672019048-805c876b67e2?auto=format&fit=crop&w=800&q=80',
  }
];

let activeIndex = 0;
const total = destinos.length;
let lastAction = 'auto'; // 'auto' o 'click'

// Barra de progreso
let progress = 0;
let progressInterval;
const AUTOPLAY_TIME = 5000;

function startProgressBar() {
  clearInterval(progressInterval);
  progress = 0;
  const step = 40; // ms
  const increment = step / AUTOPLAY_TIME;
  progressInterval = setInterval(() => {
    progress += increment;
    if (progress >= 1) {
      progress = 1;
      clearInterval(progressInterval);
    }
  }, step);
}
function resetProgressBar() {
  clearInterval(progressInterval);
  progress = 0;
}

// Calcula los 4 siguientes destinos para el carrusel derecho (circular)


$: carrusel = Array.from({length: tarjetasVisibles}, (_, i) => destinos[(activeIndex + i + 1) % total]);

// Navegación circular
function siguiente(trigger = 'auto') {
  lastAction = trigger;
  activeIndex = (activeIndex + 1) % total;
  startProgressBar();
}
function anterior() {
  lastAction = 'auto';
  activeIndex = (activeIndex - 1 + total) % total;
  startProgressBar();
}
import { onMount, onDestroy } from 'svelte';

// Lógica responsiva para tarjetas visibles en el carrusel
let tarjetasVisibles = 4;

function actualizarTarjetas() {
  if (window.innerWidth < 1024) {
    tarjetasVisibles = 2;
  } else {
    tarjetasVisibles = 4;
  }
}

onMount(() => {
  actualizarTarjetas();
  window.addEventListener('resize', actualizarTarjetas);
});

// Autoplay: cambia de slide cada 5 segundos
let autoplay;
function startAutoplay() {
  stopAutoplay();
  autoplay = setInterval(() => {
    siguiente();
    startProgressBar();
  }, AUTOPLAY_TIME);
  startProgressBar();
}
function stopAutoplay() {
  if (autoplay) clearInterval(autoplay);
  clearInterval(progressInterval);
}

onMount(() => {
  startAutoplay();
  startProgressBar();
});
onDestroy(() => {
  stopAutoplay();
});

// Cuando el usuario hace clic en una tarjeta, cambia el slide y marca la acción
function goToSlide(idx) {
  lastAction = 'click';
  activeIndex = idx;
  restartAutoplay();
  startProgressBar();
}

// Reinicia el autoplay después de interacción manual
function restartAutoplay() {
  stopAutoplay();
  startAutoplay();
}

// Si quieres que el autoplay nunca se reinicie (loop continuo):
// (El autoplay solo se detiene al desmontar el componente)
// Elimina el reinicio automático para máxima suavidad.

</script>

<!-- HeroSlider: Slide activo a la izquierda, carrusel a la derecha -->
<!-- Sección principal con padding vertical amplio -->
<!-- Sección principal con fondo dinámico y overlay -->
<section
  class="w-full flex flex-col md:flex-row min-h-[60vh] py-20 md:py-32 relative overflow-hidden"
  style="background-image: url('{destinos[activeIndex].imagen}'); background-size: cover; background-position: center; transition: background-image 0.7s cubic-bezier(.4,0,.2,1);"
>
  <div class="absolute inset-0 bg-black/60 pointer-events-none z-0 transition-opacity duration-700"></div>
  <!-- Columna izquierda: Slide activo destacado -->
  <div class="flex-1 flex flex-col justify-center items-start p-8 pl-24 md:pl-24 sm:pl-8 relative z-10">
    <div class="max-w-xl animate-fade-slide-scale" key={activeIndex}>
      <span class="block text-white/80 text-base md:text-lg font-semibold mb-2">{destinos[activeIndex].subtitulo}</span>
      <h1 class="text-4xl md:text-6xl font-extrabold text-white leading-tight mb-4 drop-shadow-lg">
        {destinos[activeIndex].titulo}
      </h1>
      <p class="text-white/80 text-base md:text-lg mb-8 max-w-lg">
        {destinos[activeIndex].descripcion}
      </p>
      <button class="flex items-center gap-2 bg-white/90 hover:bg-white text-gray-900 font-bold rounded-full px-6 py-3 shadow-lg transition">
        <svg width="20" height="20" fill="none" viewBox="0 0 24 24" stroke="currentColor"><circle cx="12" cy="12" r="10" stroke-width="2"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 8l4 4-4 4"/></svg>
        {destinos[activeIndex].boton}
      </button>
    </div>
  </div>

<style>
  /* Animación fade+slide+scale para el texto activo y tarjetas */
  .animate-fade-slide-scale {
    animation: fade-slide-scale-in 0.7s cubic-bezier(.4,0,.2,1);
  }
  @keyframes fade-slide-scale-in {
    0% {
      opacity: 0;
      transform: translateY(40px) scale(0.96);
    }
    100% {
      opacity: 1;
      transform: translateY(0) scale(1);
    }
  }
  /* Animación para las tarjetas del carrusel: cambio automático */
  .animate-carrusel-card {
    animation: fade-scale-in 0.7s cubic-bezier(.4,0,.2,1);
  }
  @keyframes fade-scale-in {
    0% {
      opacity: 0;
      transform: scale(0.96);
    }
    100% {
      opacity: 1;
      transform: scale(1);
    }
  }
  /* Animación bounce para click */
  .animate-carrusel-bounce {
    animation: bounce-in 0.5s cubic-bezier(.4,0,.2,1);
  }
  @keyframes bounce-in {
    0% {
      transform: scale(0.95);
      opacity: 0.7;
    }
    60% {
      transform: scale(1.05);
      opacity: 1;
    }
    80% {
      transform: scale(0.98);
    }
    100% {
      transform: scale(1);
    }
  }
</style>
  <!-- Columna derecha alineada abajo y a la derecha para desplazar el carrusel -->
  <div class="flex-1 md:flex-[1.5] flex flex-col justify-center items-end p-8 mb-16 overflow-visible">
    <!-- Carrusel de tarjetas -->
    <!-- Carrusel alineado a la derecha y sobresaliendo con margen derecho negativo -->
    <div class="flex flex-row justify-end items-end gap-6 w-full max-w-[1200px] overflow-visible relative ml-auto md:-mr-[130px]">
      {#each carrusel as card, i (card.titulo)}
        <div
          class="w-[270px] h-[390px] rounded-2xl shadow-2xl flex flex-col justify-end p-0 bg-cover bg-center relative z-10 overflow-hidden group cursor-pointer transition-transform hover:scale-105 {lastAction === 'auto' ? 'animate-carrusel-card' : ''} {lastAction === 'click' ? 'animate-carrusel-bounce' : ''}"
          style="background-image: url('{card.imagen}');"
          on:click={() => goToSlide((activeIndex + i + 1) % total)}
          key={activeIndex + '-' + i}
        >
          <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
          <div class="relative z-10 p-5 pb-6 flex flex-col">
            <span class="text-xs font-semibold mb-1 text-white/80">{card.subtitulo}</span>
            <span class="text-lg md:text-xl leading-tight text-white font-bold">{card.titulo}</span>
          </div>
        </div>
      {/each}
      <!-- Navegación -->
      <!-- Nueva barra de navegación y progreso -->
      <div class="absolute left-0 right-60 -bottom-16 flex items-center justify-between gap-6 z-20 select-none px-4 md:px-8 max-w-[1000px] mx-auto w-full">
        <!-- Botones -->
        <div class="flex gap-4 flex-shrink-0">
          <button class="w-12 h-12 rounded-full bg-white/80 hover:bg-white text-gray-900 shadow flex items-center justify-center text-2xl font-bold transition" on:click={anterior} aria-label="Anterior">
            <svg width="28" height="28" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
          </button>
          <button class="w-12 h-12 rounded-full bg-white/80 hover:bg-white text-gray-900 shadow flex items-center justify-center text-2xl font-bold transition" on:click={() => siguiente('click')} aria-label="Siguiente">
            <svg width="28" height="28" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
          </button>
        </div>
        <!-- Barra de progreso -->
        <div class="relative flex-1 h-2 bg-white/30 rounded-full overflow-hidden mx-4 md:mx-6">
          <div class="absolute left-0 top-0 h-full bg-yellow-400 transition-all duration-150" style="width: {Math.round(progress * 100)}%"></div>
        </div>
        <!-- Slide actual -->
        <div class="text-3xl font-bold text-white/80 drop-shadow-lg min-w-[3.5rem] md:min-w-[4.5rem] text-right pr-4 md:pr-8 select-none flex-shrink-0">
          {String(activeIndex + 1).padStart(2, '0')}
        </div>
      </div>
    </div>
  </div>
</section>

<style>
/* Puedes añadir estilos base aquí si lo deseas */
section {
  padding-bottom: 280px;
}

@media (max-width: 900px) {
  section {
    padding-bottom: 100px;
  }
}
</style>
