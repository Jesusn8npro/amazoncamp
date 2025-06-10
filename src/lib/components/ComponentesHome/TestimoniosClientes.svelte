<script>
  // Testimonios hardcodeados, puedes luego cargarlos dinámicamente si quieres
  const testimonios = [
    {
      nombre: "María G.",
      pais: "Colombia",
      imagen: "/Imagenes/Testimonios/Clienta com simio.jpg",
      texto: "¡La mejor experiencia de mi vida! Navegar el Amazonas y convivir con la naturaleza fue simplemente mágico. El equipo de Amazon Camp nos hizo sentir seguros y especiales en todo momento.",
      estrellas: 5,
      logo: 'tripadvisor'
    },
    {
      nombre: "Juan P.",
      pais: "Perú",
      imagen: "/Imagenes/Testimonios/Cliente con simio.jpg",
      texto: "Nunca imaginé estar tan cerca de animales increíbles. Todo fue auténtico, sin shows armados. ¡Volvería mil veces más!",
      estrellas: 5,
      logo: 'airbnb'
    },
    {
      nombre: "Sofía R.",
      pais: "Argentina",
      imagen: "/Imagenes/Testimonios/Pescando.jpg",
      texto: "Pesqué mi primer pez en el Amazonas y aprendí de la cultura local. Amazon Camp superó todas mis expectativas. ¡Gracias por tantas aventuras!",
      estrellas: 5,
      logo: 'tripadvisor'
    },
    {
      nombre: "Carlos T.",
      pais: "España",
      imagen: "/Imagenes/Testimonios/Tortuga dragon.jpg",
      texto: "Ver tortugas y animales salvajes en su hábitat fue brutal. El lodge es cómodo y la comida deliciosa. ¡Repetiría sin dudar!",
      estrellas: 5,
      logo: 'airbnb'
    }
  ];
</script>

<section class="relative py-20 bg-gradient-to-br from-green-50 via-green-100 to-green-200 overflow-hidden">
  <img src="/Imagenes/Cocodrilos.jpg" alt="Fondo selva" class="absolute inset-0 w-full h-full object-cover opacity-10 pointer-events-none select-none" />
  <div class="relative max-w-5xl mx-auto px-4 z-10">
    <h2 class="text-3xl md:text-4xl font-extrabold text-green-700 mb-8 text-center drop-shadow animate-fade-in">
      ¿Qué dicen quienes ya vivieron Amazon Camp?
    </h2>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      {#each testimonios as t}
      <div class="bg-white/95 rounded-2xl shadow-2xl p-8 flex flex-col items-center border-b-8 border-green-400 hover:scale-105 transition-transform animate-pop-in">
        <img src={t.imagen} alt={t.nombre} class="w-28 h-28 object-cover rounded-full border-4 border-green-400 mb-4 shadow-lg" loading="lazy" />
        <div class="flex items-center gap-1 mb-2">
          {#each Array(t.estrellas) as _, i}
            <span class="text-yellow-400 text-xl">★</span>
          {/each}
        </div>
        <p class="text-gray-700 font-semibold italic mb-3">"{t.texto}"</p>
        <span class="font-bold text-green-700 flex items-center gap-2">{t.nombre}
          {#if t.logo === 'tripadvisor'}
            <img src="/Imagenes/Recomendaciones/tripadvisor-viajes.png" alt="Tripadvisor" class="h-6 w-auto ml-1" style="max-width:38px;" />
          {/if}
          {#if t.logo === 'airbnb'}
            <img src="/Imagenes/Recomendaciones/Airbnb.webp" alt="Airbnb" class="h-6 w-auto ml-1" style="max-width:38px;" />
          {/if}
        </span>
        <span class="text-green-500 text-sm">{t.pais}</span>
      </div>
      {/each}
    </div>
    <div class="mt-10 text-center">
      <span class="inline-block bg-green-600 text-white font-bold px-8 py-3 rounded-full shadow-lg text-lg animate-pop-in cursor-pointer hover:bg-green-700 transition">¡Quiero vivir mi aventura!</span>
    </div>
  </div>
</section>

<style>
  .animate-fade-in {
    animation: fadeIn 0.7s cubic-bezier(.4,0,.2,1);
  }
  .animate-pop-in {
    animation: popIn 0.7s cubic-bezier(.4,0,.2,1);
  }
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(24px) scale(0.98); }
    to { opacity: 1; transform: none; }
  }
  @keyframes popIn {
    from { opacity: 0; transform: scale(0.8); }
    to { opacity: 1; transform: scale(1); }
  }
  .animate-bounce-slow {
    animation: bounceSlow 2s infinite;
  }
  @keyframes bounceSlow {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
  }
</style>
