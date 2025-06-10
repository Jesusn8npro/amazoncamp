<script>
  // No props needed for ahora, todo hardcodeado
</script>

<section class="relative py-20 md:py-32 bg-gradient-to-br from-black via-zinc-900 to-gray-800 overflow-hidden">
  <img src="/Imagenes/Cocodrilos.jpg" alt="Fondo animales Cocodrilos" class="absolute inset-0 w-full h-full object-cover opacity-60 pointer-events-none select-none" style="z-index:1;" />
  <div class="absolute inset-0 w-full h-full bg-black opacity-40 pointer-events-none select-none" style="z-index:2;"></div>
  <div class="relative max-w-6xl mx-auto px-4 z-10">
    <h2 class="text-4xl md:text-5xl font-extrabold text-yellow-400 mb-8 text-center drop-shadow animate-fade-in">
      Donde las grandes historias se viven de verdad
    </h2>
    <p class="text-xl text-gray-200 text-center max-w-2xl mx-auto mb-12 animate-fade-in">
      Amazon Camp: elegido por Hollywood, por exploradores y por quienes buscan una experiencia única en la Amazonía. Aquí no solo vives la selva, ¡la protagonizas!
    </p>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-10 mb-16">
      <!-- Predator -->
      <div class="bg-zinc-900/80 rounded-2xl shadow-2xl p-6 flex flex-col md:flex-row items-center gap-6 border-l-8 border-yellow-400 animate-pop-in">
        <img src="/Imagenes/Predator Arnold.jpg" alt="Predator en Amazon Camp" class="w-40 h-56 object-cover rounded-xl border-4 border-yellow-400 shadow-md" loading="lazy" />
        <div>
          <h3 class="text-2xl font-bold text-yellow-300 mb-2">Depredador (Predator) - 1987</h3>
          <p class="text-gray-100 mb-2">Arnold Schwarzenegger y el equipo de Hollywood eligieron Amazon Camp como su base para filmar una de las películas más icónicas de acción. ¿Te imaginas vivir donde las leyendas pisan?</p>
          <span class="inline-block bg-yellow-500 text-black font-bold px-4 py-1 rounded-full text-xs mt-2">¡Escenario de Hollywood!</span>
        </div>
      </div>
      <!-- Anaconda -->
      <div class="bg-zinc-900/80 rounded-2xl shadow-2xl p-6 flex flex-col md:flex-row items-center gap-6 border-l-8 border-yellow-400 animate-pop-in">
        <img src="/Imagenes/Anaconda.jpg" alt="Anaconda en Amazon Camp" class="w-40 h-56 object-cover rounded-xl border-4 border-yellow-400 shadow-md" loading="lazy" />
        <div>
          <h3 class="text-2xl font-bold text-yellow-300 mb-2">Anaconda - 1997</h3>
          <p class="text-gray-100 mb-2">Jennifer Lopez, Ice Cube y el elenco de Anaconda vivieron la selva real en Amazon Camp. Aquí no solo se filman aventuras, ¡se viven en carne propia!</p>
          <span class="inline-block bg-yellow-500 text-black font-bold px-4 py-1 rounded-full text-xs mt-2">¡Donde nacen las leyendas!</span>
        </div>
      </div>
    </div>

    <!-- Beneficios puntuales y urgentes -->
    <div class="mt-10 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
      <div class="bg-gradient-to-br from-yellow-400 to-orange-500 text-white rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-center border-4 border-yellow-300 animate-pop-in">
        <span class="text-4xl mb-2">🛡️</span>
        <span class="font-bold text-lg mb-1">¡Reserva 100% Segura!</span>
        <span class="text-sm font-semibold">Cupos limitados, no te quedes fuera.</span>
      </div>
      <div class="bg-gradient-to-br from-green-400 to-green-600 text-white rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-center border-4 border-green-300 animate-pop-in">
        <span class="text-4xl mb-2">🔥</span>
        <span class="font-bold text-lg mb-1">Precio Final, Sin Sorpresas</span>
        <span class="text-sm font-semibold">Todo incluido, olvídate de cargos ocultos.</span>
      </div>
      <div class="bg-gradient-to-br from-pink-500 to-red-500 text-white rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-center border-4 border-pink-300 animate-pop-in">
        <span class="text-4xl mb-2">🌴</span>
        <span class="font-bold text-lg mb-1">Experiencia Real, Sin Turistas Masivos</span>
        <span class="text-sm font-semibold">¡Vive la selva como un verdadero explorador!</span>
      </div>
      <div class="bg-gradient-to-br from-blue-500 to-indigo-600 text-white rounded-2xl shadow-xl p-6 flex flex-col items-center justify-center text-center border-4 border-blue-300 animate-pop-in">
        <span class="text-4xl mb-2">⏰</span>
        <span class="font-bold text-lg mb-1">¡Últimas fechas disponibles!</span>
        <span class="text-sm font-semibold">No pierdas tu lugar, agenda hoy mismo.</span>
      </div>
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
</style>
